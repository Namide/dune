package dune;

import dune.component.ComponentType;
import dune.component.Transform;
import dune.entity.Entity;
import dune.helper.core.UrlUtils;
import dune.model.controller.ControllerPlatform;
import dune.model.controller.ControllerPlatformPlayer;
import dune.model.controller.ControllerGravity;
import dune.model.controller.ControllerMobile;
import dune.model.example.LevelGen;
import dune.model.factory.EntityFactory;
import dune.system.graphic.component.Display2dSprite;
import dune.system.physic.component.Body;
import dune.system.physic.component.BodyType;
import dune.system.physic.shapes.ShapeRect;
import dune.system.physic.shapes.ShapeType;
import dune.system.Settings;
import dune.system.SysManager;
import h2d.comp.Input;
import hxd.Stage;
import hxd.System;

/**
 * ...
 * @author Namide
 */
class Game
{
	
	public var systemManager:SysManager;
	
	private var _entity1:Entity;
	
	public function new() 
	{
		//hxd.Res.initEmbed();
		//hxd.Res.loader = new hxd.res.Loader(hxd.res.EmbedFileSystem.create());
		systemManager = new SysManager( run );
		
		//systemManager.sysGraphic.onInit = run;

	}
	
	public function run()
	{
		var rootURL:String = UrlUtils.getCurrentSwfDir() + "/";
		var levelGen:LevelGen = new LevelGen( systemManager );
		
		levelGen.listLevels( rootURL + "level/level-list.json", function(a:Array<LevelInfos>):Void
		{
			levelGen.generateLevel( rootURL + "level/" + a[0].path );
			systemManager.start();
		} );
		
		
		
		//var tile = hxd.Res.mainChar128x128.toTile();
		
		
		
		//systemManager.refresh();
		//hxd.System.setLoop( refresh );
		
		
		// MOBILE LINEAR
		
		
		/*var TS:Float = Settings.TILE_SIZE;
		
		
		// MOBILE COS
		var e2 = new Entity();
		e2.transform.x = 12*TS;
		e2.transform.y = 9*TS;
		
			// graphic
			
				//var spr2 = new h2d.Sprite( systemManager.sysGraphic.s2d );
				//var bmp2 = new h2d.Bitmap(tile, spr2);
				//e2.display = new CompDisplay2dSprite( spr2 );
				e2.display = EntityFact.getSolidDisplay( systemManager, 3*TS, TS );
			
			// move
			
				var i2:ControllerMobile = new ControllerMobile();
				i2.initX( ControllerMobile.TYPE_COS, 4*TS, 2000 );
				//i2.anchorY = 3*TS;
				e2.addController( i2 );
				
			// collision
			
				var b2:CompBody = new CompBody();
				var psr2:PhysShapeRect = new PhysShapeRect();
				psr2.w = 3*TS;
				psr2.h = TS;
				b2.shape = psr2;
				b2.typeOfCollision = CompBodyType.COLLISION_TYPE_PASSIVE;
				b2.typeOfSolid = CompBodyType.SOLID_TYPE_WALL;
				e2.addBody( b2 );
				
		systemManager.addEntity( e2 );
		
		
		// PLAYER
		var e3 = new Entity();
		e3.transform.x = 2*TS;
		e3.transform.y = 2*TS;
			
			// graphic
			
				//var spr3 = new h2d.Sprite( systemManager.sysGraphic.s2d );
				//var bmp3 = new h2d.Bitmap(tile, spr3);
				//e3.display = new CompDisplay2dSprite( spr3 );
				e3.display = EntityFact.getSolidDisplay( systemManager, TS, TS );
				
			// gravity
			
				var g3:ControllerGravity = new ControllerGravity();
				//e3.addController( new ControllerGravity() );
				
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
				//i3.groundVX = 5;
				e3.addController( i3 );
			
		systemManager.addEntity( e3 );
		
		// GROUND
		EntityFact.addSolid( systemManager, 0, 12*TS, 4*TS, 1*TS, CompBodyType.SOLID_TYPE_PLATFORM );
		EntityFact.addSolid( systemManager, 4*TS, 12*TS, 4*TS, 1*TS, CompBodyType.SOLID_TYPE_PLATFORM );
		EntityFact.addSolid( systemManager, 8*TS, 12*TS, 4*TS, 1*TS, CompBodyType.SOLID_TYPE_PLATFORM );
		EntityFact.addSolid( systemManager, 12*TS, 12*TS, 4*TS, 1*TS, CompBodyType.SOLID_TYPE_PLATFORM );
		EntityFact.addSolid( systemManager, 16*TS, 12*TS, 4*TS, 1*TS, CompBodyType.SOLID_TYPE_PLATFORM );
		EntityFact.addSolid( systemManager, 20*TS, 12*TS, 4*TS, 1*TS, CompBodyType.SOLID_TYPE_PLATFORM );
		EntityFact.addSolid( systemManager, 24*TS, 12*TS, 4*TS, 1*TS, CompBodyType.SOLID_TYPE_PLATFORM );
		
		// PLATFORMS
		EntityFact.addSolid( systemManager, 8*TS, 11*TS, TS, TS, CompBodyType.SOLID_TYPE_PLATFORM );
		EntityFact.addSolid( systemManager, 11*TS, 10*TS, TS, 2*TS, CompBodyType.SOLID_TYPE_PLATFORM );
		EntityFact.addSolid( systemManager, 13*TS, 9*TS, TS, 3*TS, CompBodyType.SOLID_TYPE_PLATFORM );
		EntityFact.addSolid( systemManager, 15*TS, 8*TS, TS, 4*TS, CompBodyType.SOLID_TYPE_PLATFORM );
		
		// WALL LEFT
		EntityFact.addSolid( systemManager, 0, 7 * TS, TS, 5 * TS, CompBodyType.SOLID_TYPE_WALL );
		EntityFact.addSolid( systemManager, 27*TS, 7 * TS, TS, 5 * TS, CompBodyType.SOLID_TYPE_WALL );
		
		//addBounceBall();
		
		//systemManager.sysPhysic.space.setSize( -1024, -1024, 1024, 1024, 64, 64 );
		systemManager.refresh(0);
		hxd.System.setLoop( refresh );
		
		addBounceBall();*/
	}
	
	private function addBounceBall():Void
	{
		var TS:Float = Settings.TILE_SIZE;
		
		var size:Float = ( Math.random() + 0.5 ) * TS;
		
		var ball = new Entity();
		ball.transform.x = ( 1 + Math.random() * 10 ) * TS;
		ball.transform.y = -size;
		ball.transform.vX = Math.random() * 5;
		
		// graphic
		
			ball.display = EntityFactory.getSolidDisplay( systemManager, size, size );
		
		// collision
		
			var b4:Body = new Body();
			var psr4:ShapeRect = new ShapeRect();
			psr4.w = size;
			psr4.h = size;
			b4.shape = psr4;
			b4.typeOfCollision = BodyType.COLLISION_TYPE_ACTIVE;
			b4.typeOfSolid = BodyType.SOLID_TYPE_MOVER; //| CompBodyType.SOLID_TYPE_WALL;
			ball.addBody( b4 );
		
		// move
	
			var i4:ControllerPlatform = new ControllerPlatform();
			ball.addController( i4 );
			
		systemManager.addEntity( ball );
		
	}
	
	/*var frameN:UInt = 0;
	private function refresh()
	{		
		frameN++;
		if ( frameN % 16 == 0 && frameN >> 4 < 1001 )
		{
			addBounceBall();
			//trace( frameN >> 4 );
		}
		
		systemManager.refresh();
		
	}*/
}