package dune.model.example ;
import dune.entity.Entity;
import dune.model.factory.DisplayFactory;
import dune.model.controller.ControllerMobile;
import dune.model.controller.ControllerPlatformPlayer;
import dune.model.example.LevelGen.TileData;
import dune.model.factory.EntityFactory;
import dune.system.physic.component.Body;
import dune.system.physic.component.BodyType;
import dune.system.physic.shapes.ShapeRect;
import dune.system.Settings;
import dune.system.SysManager;
import flash.display.Loader;
import flash.events.Event;
import flash.Lib;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.utils.Object;
import haxe.Json;

class TileData
{
	public var id:UInt;
	public var type:String;
	public var datas:Dynamic;
	
	public function new( dat:Dynamic ) 
	{
		id = dat.id;
		type = dat.type;
		datas = dat.datas;
	}
}

class LevelData
{
	/*public static inline var SOLID_EMPTY:UInt = 0;
	public static inline var SOLID_WALL:UInt = 1;
	public static inline var SOLID_PLATFORM:UInt = 2;*/
	
	var _tiles:Array<TileData>;	
	public var grid(default, null):Array<Array<UInt>>;
	
	public function new( dat:Dynamic ) 
	{
		_tiles = [];
		
		var datTiles:Array<Dynamic> = cast( dat.tiles, Array<Dynamic> );
		
		for ( tileDyn in datTiles )
		{
			_tiles.push( new TileData( tileDyn ) );
		}
		
		grid = dat.grid;
	}
	
	public function getTile(i:Int, j:Int):TileData
	{
		var getTile:TileData->Bool = function( td:TileData ):Bool { return td.id == grid[j][i]; };
		
		if ( 	j < grid.length &&
				i < grid[j].length &&
				Lambda.exists( _tiles, getTile )
				)
		{
			return Lambda.find( _tiles, getTile );
		}
		return null;
	}
}

/**
 * ...
 * @author Namide
 */
class LevelGen
{

	public var onLoaded:LevelData -> Void;
	
	var sm:SysManager;
	
	public function new( sm:SysManager ) 
	{
		this.sm = sm;
	}
	
	public function loadJson( uri:String ):Void
	{
		//trace( uri );
		var req:URLRequest = new URLRequest( uri );
		var load:URLLoader = new URLLoader(req);
		load.addEventListener(Event.COMPLETE, jsonLoaded);
	}
	
	private function jsonLoaded( e:Event ):Void
	{
		var loader:URLLoader = e.target;
		var dat:Dynamic = Json.parse( Std.string(loader.data) );
		
		var level:LevelData = new LevelData( dat );
		gridAnalyse(level);
	}
	
	function gridAnalyse( levelDatas:LevelData ):Void
	{
		var constructed:Array<String> = [];
		for ( j in 0...levelDatas.grid.length )
		{
			for ( i in 0...levelDatas.grid[j].length )
			{
				tileAnalyseSize( levelDatas, i, j, constructed );
			}
		}
	}
	
	function tileAnalyseSize( levelDatas:LevelData, iMin:Int, jMin:Int, c:Array<String> ):Void
	{
		var i:Int = iMin;
		var j:Int = jMin;
		
		var tile:TileData = levelDatas.getTile( i, j );
		if ( tile == null ) return;
		
		if ( Lambda.has( c, posToStr(i, j) ) ) return;
		
		var iMax:Int = iMin;
		var jMax:Int = jMin;
		
		if ( levelDatas.getTile( i+1, j ) == tile && !Lambda.has( c, posToStr(i,j) ) )
		{
			while ( levelDatas.getTile( i, j ) == tile && !Lambda.has( c, posToStr(i,j) ) )
			{
				iMax = i;
				c.push( posToStr(i, j) );
				i++;
			}
		}
		else if ( levelDatas.getTile( i, j+1 ) == tile && !Lambda.has( c, posToStr(i,j) ) )
		{
			while ( levelDatas.getTile( i, j ) == tile && !Lambda.has( c, posToStr(i,j) ) )
			{
				jMax = j;
				c.push( posToStr(i, j) );
				j++;
			}
		}
		
		tileAnalyseType( iMin, jMin, 1 + iMax - iMin, 1 + jMax - jMin, tile );
	}
	
	function tileAnalyseType( xTile:Int, yTile:Int, wTile:Int, hTile:Int, tile:TileData ):Void
	{
		var TS:Float = Settings.TILE_SIZE;
		
		if ( tile.type == "platform" )
			EntityFactory.addSolid( sm, xTile * TS, yTile * TS, wTile * TS, hTile * TS, BodyType.SOLID_TYPE_PLATFORM );
		else if ( tile.type == "wall" )
			EntityFactory.addSolid( sm, xTile * TS, yTile * TS, wTile * TS, hTile * TS, BodyType.SOLID_TYPE_WALL );
		else if ( tile.type == "spawn" )
			addPlayer( xTile * TS, yTile * TS );
		else if ( tile.type == "mobile" )
			addMobile( xTile * TS, yTile * TS, wTile * TS, hTile * TS, tile.datas );
	}
	
	function addMobile( i:Float, j:Float, w:Float, h:Float, datas:Dynamic ):Void
	{
		var e2 = new Entity();
		e2.transform.x = i;
		e2.transform.y = j;
		
		var tweens:Dynamic =
		{
			cos:ControllerMobile.TYPE_COS,
			linear:ControllerMobile.TYPE_LINEAR,
			sin:ControllerMobile.TYPE_SIN
		}
		
		var solidType:Dynamic =
		{
			wall:BodyType.SOLID_TYPE_PLATFORM,
			platform:BodyType.SOLID_TYPE_WALL
		}
		
		
			// graphic
			
				//var spr2 = new h2d.Sprite( systemManager.sysGraphic.s2d );
				//var bmp2 = new h2d.Bitmap(tile, spr2);
				//e2.display = new CompDisplay2dSprite( spr2 );
				e2.display = EntityFactory.getSolidDisplay( sm, w, h );
			
			// move
			
				var i2:ControllerMobile = new ControllerMobile();
				
				if ( datas.moveX != null )
					i2.initX( tweens[datas.moveX.type], datas.moveX.dist * Settings.TILE_SIZE, datas.moveX.time );
				
				if ( datas.moveY != null )
					i2.initY( tweens[datas.moveY.type], datas.moveY.dist * Settings.TILE_SIZE, datas.moveY.time );
				
				e2.addController( i2 );
				
			// collision
			
				var b2:Body = new Body();
				var psr2:ShapeRect = new ShapeRect();
				psr2.w = w;
				psr2.h = h;
				b2.shape = psr2;
				b2.typeOfCollision = BodyType.COLLISION_TYPE_PASSIVE;
				b2.typeOfSolid = solidType[datas.type];
				e2.addBody( b2 );
				
		sm.addEntity( e2 );
	}
	
	function addPlayer( i:Float, j:Float ):Void
	{
		var TS:Float = Settings.TILE_SIZE;
		
		// PLAYER
		var e3 = new Entity();
		e3.transform.x = i;
		e3.transform.y = j;
			
			// graphic
			
				e3.display = DisplayFactory.movieClipToDisplay2dAnim( Lib.attach( "PlayerMC" ), sm, 1.5 * Settings.TILE_SIZE / 128 );
				//e3.display = EntityFact.getSolidDisplay( sm, TS, TS );
			
			// collision
			
				var b3:Body = new Body();
				b3.typeOfCollision = BodyType.COLLISION_TYPE_ACTIVE;
				b3.typeOfSolid = BodyType.SOLID_TYPE_MOVER;
				b3.insomniac = true;
				var psr3:ShapeRect = new ShapeRect();
				psr3.w = TS * 0.8;
				psr3.h = TS;
				psr3.anchorX = -0.35 * TS;
				psr3.anchorY = -0.4 * TS;
				b3.shape = psr3;
				e3.addBody( b3 );
			
			// Keyboard
			
				var i3:ControllerPlatformPlayer = new ControllerPlatformPlayer();
				e3.addController( i3 );
			
		sm.addEntity( e3 );
	}
	
	function posToStr( i:Int, j:Int ):String
	{
		return Std.string(i) + "-" + Std.string(j);
	}
	
}