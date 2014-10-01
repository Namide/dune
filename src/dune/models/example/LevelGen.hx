package dune.models.example;
import dune.entities.Entity;
import dune.helpers.display.DisplayFact;
import dune.helpers.entity.EntityFact;
import dune.models.controller.ControllerPlatformPlayer;
import dune.system.physic.components.CompBody;
import dune.system.physic.components.CompBodyType;
import dune.system.physic.shapes.PhysShapeRect;
import dune.system.Settings;
import dune.system.SysManager;
import flash.display.Loader;
import flash.events.Event;
import flash.Lib;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.utils.Object;
import haxe.Json;

class LevelData
{
	public static inline var SOLID_EMPTY:UInt = 0;
	public static inline var SOLID_WALL:UInt = 1;
	public static inline var SOLID_PLATFORM:UInt = 2;
	
	public var playerPosX(default,default):Float;
	public var playerPosY(default,default):Float;
	public var playerVelX(default,default):Float;
	public var playerJumpMin(default,default):Float;
	public var playerJumpMax(default,default):Float;
	public var playerJumpVelX(default,default):Float;
	
	public var solids(default, default):Array<Array<UInt>>;
	
	public function new( dat:Dynamic ) 
	{
		playerPosX = dat.player.x;
		playerPosY = dat.player.y;
		playerVelX = dat.player.runVelocity;
		playerJumpMin = dat.player.jumpMin;
		playerJumpMax = dat.player.jumpMax;
		playerJumpVelX = dat.player.jumpVelocity;
		
		solids = dat.level;
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
		construct(level);
	}
	
	function construct( levelDatas:LevelData ):Void
	{
		var TS:Float = Settings.TILE_SIZE;
		
		// PLAYER
		var e3 = new Entity();
		e3.transform.x = levelDatas.playerPosX * TS;
		e3.transform.y = levelDatas.playerPosY * TS;
			
			// graphic
			
				e3.display = DisplayFact.movieClipToDisplay2dAnim( Lib.attach( "PlayerMC" ), sm, 1.5 * Settings.TILE_SIZE / 128 );
				//e3.display = EntityFact.getSolidDisplay( sm, TS, TS );
			
			// collision
			
				var b3:CompBody = new CompBody();
				b3.typeOfCollision = CompBodyType.COLLISION_TYPE_ACTIVE;
				b3.typeOfSolid = CompBodyType.SOLID_TYPE_MOVER;
				b3.insomniac = true;
				var psr3:PhysShapeRect = new PhysShapeRect();
				psr3.w = TS * 0.8;
				psr3.h = TS;
				psr3.anchorX = -0.35 * TS;
				psr3.anchorY = -0.35 * TS;
				b3.shape = psr3;
				e3.addBody( b3 );
			
			// Keyboard
			
				var i3:ControllerPlatformPlayer = new ControllerPlatformPlayer();
				//i3.setRun( levelDatas.playerVelX, 0.06 );
				//i3.setJump( levelDatas.playerJumpMin, levelDatas.playerJumpMax, levelDatas.playerJumpVelX, 0.06, 0.2 );
				e3.addController( i3 );
			
		sm.addEntity( e3 );
		
		var constructed:Array<String> = [];
		
		for ( j in 0...levelDatas.solids.length )
		{
			for ( i in 0...levelDatas.solids[j].length )
			{
				
				merge( levelDatas.solids, i, j, constructed, sm );
				/*var type:UInt = Std.int( levelDatas.solids[j][i] );
				
				if ( type == LevelData.SOLID_PLATFORM )
					EntityFact.addSolid( sm, i*TS, j*TS, TS, TS, CompBodyType.SOLID_TYPE_PLATFORM );
		
				else if ( type == LevelData.SOLID_WALL )
					EntityFact.addSolid( sm, i*TS, j*TS, TS, TS, CompBodyType.SOLID_TYPE_WALL );*/
				
				
			}
		}
	}
	
	function merge( a:Array<Array<UInt>>, iMin:Int, jMin:Int, c:Array<String>, sm:SysManager ):Void
	{
		var i:Int = iMin;
		var j:Int = jMin;
		var type:UInt = Std.int( a[j][i] );
		if ( type != LevelData.SOLID_PLATFORM && type != LevelData.SOLID_WALL ) return;
		
		var iMax:Int = -1;
		var jMax:Int = -1;
		var TS:Float = Settings.TILE_SIZE;
		
		while ( j < a.length && a[j][i] == type && !Lambda.has( c, posToStr(i,j) ) )
		{
			jMax = j;
			while ( i < a[j].length && a[j][i] == type && !Lambda.has( c, posToStr(i,j) ) )
			{
				if ( j == jMin ) iMax = i;
				c.push( posToStr(i,j) );
				i++;
			}
			
			if ( iMax < --i ) iMax = i;
			
			i = iMin;
			j++;
		}
		
		
		if ( iMax < iMin || jMax < jMin ) return;
		
		EntityFact.addSolid( sm, iMin*TS, jMin*TS, (1+iMax-iMin)*TS, (1+jMax-jMin)*TS, type );
	}
	
	function posToStr( i:Int, j:Int ):String
	{
		return Std.string(i) + "-" + Std.string(j);
	}
	
}