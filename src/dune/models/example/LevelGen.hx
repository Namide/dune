package dune.models.example;
import dune.entities.Entity;
import dune.helpers.entity.EntityFact;
import dune.models.controller.ControllerPlatformPlayer;
import dune.system.physic.components.CompBody;
import dune.system.physic.components.CompBodyType;
import dune.system.physic.shapes.PhysShapeRect;
import dune.system.Settings;
import dune.system.SysManager;
import flash.display.Loader;
import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
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
	
	private function construct( levelDatas:LevelData ):Void
	{
		var TS:Float = Settings.TILE_SIZE;
		
		// PLAYER
		var e3 = new Entity();
		e3.transform.x = levelDatas.playerPosX * TS;
		e3.transform.y = levelDatas.playerPosY * TS;
			
			// graphic
			
				e3.display = EntityFact.getSolidDisplay( sm, TS, TS );
			
			// collision
			
				var b3:CompBody = new CompBody();
				b3.typeOfCollision = CompBodyType.COLLISION_TYPE_ACTIVE;
				b3.typeOfSolid = CompBodyType.SOLID_TYPE_MOVER;
				b3.insomniac = true;
				var psr3:PhysShapeRect = new PhysShapeRect();
				psr3.w = TS;
				psr3.h = TS;
				b3.shape = psr3;
				e3.addBody( b3 );
			
			// Keyboard
			
				var i3:ControllerPlatformPlayer = new ControllerPlatformPlayer();
				i3.setRun( levelDatas.playerVelX, 0.06 );
				i3.setJump( levelDatas.playerJumpMin, levelDatas.playerJumpMax, levelDatas.playerJumpVelX, 0.06, 0.2 );
				e3.addController( i3 );
			
		sm.addEntity( e3 );
		
		for ( j in 0...levelDatas.solids.length )
		{
			for ( i in 0...levelDatas.solids[j].length )
			{
				var type:UInt = levelDatas.solids[j][i];
				
				if ( type == LevelData.SOLID_PLATFORM )
					EntityFact.addSolid( sm, i*TS, j*TS, TS, TS, CompBodyType.SOLID_TYPE_PLATFORM );
		
				else if ( type == LevelData.SOLID_WALL )
					EntityFact.addSolid( sm, i*TS, j*TS, TS, TS, CompBodyType.SOLID_TYPE_WALL );
				
				
			}
		}
	}
	
}