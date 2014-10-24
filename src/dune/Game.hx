package dune;

import dune.component.ComponentType;
import dune.component.MultiInput;
import dune.component.Transform;
import dune.entity.Entity;
import dune.helper.core.UrlUtils;
import dune.model.controller.ControllerCamera2dTracking;
import dune.model.controller.ControllerPlatform;
import dune.model.controller.ControllerPlatformPlayer;
import dune.model.controller.ControllerGravity;
import dune.model.controller.ControllerMobile;
import dune.model.factory.DisplayFactory;
import dune.model.factory.EntityFactory;
import dune.system.graphic.component.Display2dSprite;
import dune.system.physic.component.Body;
import dune.system.physic.component.BodyType;
import dune.system.physic.shapes.ShapeRect;
import dune.system.physic.shapes.ShapeType;
import dune.system.Settings;
import dune.system.SysManager;
import h2d.comp.Input;
import haxe.Timer;
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
		/*var rootURL:String = UrlUtils.getCurrentSwfDir() + "/";
		
		LevelGen.listLevels( rootURL + "level/level-list.json", function(a:Array<String>):Void
		{
			var levelGen:LevelGen = new LevelGen( systemManager );
			levelGen.load( rootURL + "level/" + a[0], function( levelGen:LevelGen ):Void
			{
				levelGen.generateLevel();
				systemManager.draw();
				haxe.Timer.delay( systemManager.start, 500 );
				
				//systemManager.start();
				//systemManager.draw();
			} );
		} );*/
		
		//var tile = hxd.Res.mainChar128x128.toTile();
		
		//systemManager.refresh();
		//hxd.System.setLoop( refresh );
		
		
		// MOBILE LINEAR
		
		
		var TS:Float = systemManager.settings.tileSize;//Settings.TILE_SIZE;
		var size:Array<Float>;
		
		
		// MOBILE COS
		var e2 = new Entity();
		e2.transform.x = 12 * TS;
		e2.transform.y = 9 * TS;
		size = [3 * TS, TS];
		
			// graphic
			
				//var spr2 = new h2d.Sprite( systemManager.sysGraphic.s2d );
				//var bmp2 = new h2d.Bitmap(tile, spr2);
				//e2.display = new CompDisplay2dSprite( spr2 );
				e2.display = EntityFactory.getSolidDisplay( systemManager, size[0], size[1] );
			
			// move
			
				var i2:ControllerMobile = new ControllerMobile();
				i2.initX( ControllerMobile.TYPE_COS, 4*TS, 2000 );
				//i2.anchorY = 3*TS;
				e2.addController( i2 );
				
			// collision
			
				var b2:Body = new Body();
				var psr2:ShapeRect = new ShapeRect();
				psr2.w = size[0];
				psr2.h = size[1];
				b2.shape = psr2;
				b2.typeOfCollision = BodyType.COLLISION_TYPE_PASSIVE;
				b2.typeOfSolid = BodyType.SOLID_TYPE_WALL;
				e2.addBody( b2 );
				
		systemManager.addEntity( e2 );
		
		
		// PLAYER
		var e3 = new Entity();
		e3.transform.x = 2*TS;
		e3.transform.y = 7*TS;
		size = [TS, TS];
		
			// graphic
			
				//var spr3 = new h2d.Sprite( systemManager.sysGraphic.s2d );
				//var bmp3 = new h2d.Bitmap(tile, spr3);
				//e3.display = new CompDisplay2dSprite( spr3 );
				e3.display = DisplayFactory.assetMcToDisplay2dAnim( "PlayerMC", systemManager, 1 );//EntityFactory.getSolidDisplay( systemManager, size[0], size[1] );
				e3.display.width = Math.round(size[0]);
				
			// gravity
			
				var g3:ControllerGravity = new ControllerGravity( 0, systemManager.settings.gravity );
				//e3.addController( new ControllerGravity() );
				
			// collision
			
				var b3:Body = new Body();
				b3.typeOfCollision = BodyType.COLLISION_TYPE_ACTIVE;
				b3.typeOfSolid = BodyType.SOLID_TYPE_MOVER;
				b3.insomniac = true;
				var psr3:ShapeRect = new ShapeRect();
				psr3.w = size[0];
				psr3.h = size[1];
				b3.shape = psr3;
				e3.addBody( b3 );
			
			// Inputs
			
				e3.input = new dune.component.MultiInput( new dune.input.KeyboardHandler(), new dune.input.GamepadJsHandler() );
			
			// Platform controller
			
				var i3:ControllerPlatformPlayer = new ControllerPlatformPlayer( systemManager );
				//i3.groundVX = 5;
				e3.addController( i3 );
			
			// Camera traking
			
				var ct = new ControllerCamera2dTracking( systemManager );
				e3.addController( ct );
			
			
		systemManager.addEntity( e3 );
		
		// GROUND
		EntityFactory.addSolid( systemManager, 0, 12*TS, 4*TS, 1*TS, BodyType.SOLID_TYPE_PLATFORM );
		EntityFactory.addSolid( systemManager, 4*TS, 12*TS, 4*TS, 1*TS, BodyType.SOLID_TYPE_PLATFORM );
		EntityFactory.addSolid( systemManager, 8*TS, 12*TS, 4*TS, 1*TS, BodyType.SOLID_TYPE_PLATFORM );
		EntityFactory.addSolid( systemManager, 12*TS, 12*TS, 4*TS, 1*TS, BodyType.SOLID_TYPE_PLATFORM );
		EntityFactory.addSolid( systemManager, 16*TS, 12*TS, 4*TS, 1*TS, BodyType.SOLID_TYPE_PLATFORM );
		EntityFactory.addSolid( systemManager, 20*TS, 12*TS, 4*TS, 1*TS, BodyType.SOLID_TYPE_PLATFORM );
		EntityFactory.addSolid( systemManager, 24*TS, 12*TS, 4*TS, 1*TS, BodyType.SOLID_TYPE_PLATFORM );
		
		// PLATFORMS
		EntityFactory.addSolid( systemManager, 8*TS, 11*TS, TS, TS, BodyType.SOLID_TYPE_PLATFORM );
		EntityFactory.addSolid( systemManager, 11*TS, 10*TS, TS, 2*TS, BodyType.SOLID_TYPE_PLATFORM );
		EntityFactory.addSolid( systemManager, 13*TS, 9*TS, TS, 3*TS, BodyType.SOLID_TYPE_PLATFORM );
		EntityFactory.addSolid( systemManager, 15*TS, 8*TS, TS, 4*TS, BodyType.SOLID_TYPE_PLATFORM );
		
		// WALL LEFT
		EntityFactory.addSolid( systemManager, 0, 7 * TS, TS, 5 * TS, BodyType.SOLID_TYPE_WALL );
		EntityFactory.addSolid( systemManager, 27*TS, 7 * TS, TS, 5 * TS, BodyType.SOLID_TYPE_WALL );
		
		//addBounceBall();
		
		//systemManager.sysPhysic.space.setSize( -1024, -1024, 1024, 1024, 64, 64 );
		systemManager.start();
		//hxd.System.setLoop( refresh );
		
		
		//addBounceBall();
	}
	
	private function addBounceBall():Void
	{
		var TS:Float = systemManager.settings.tileSize;//Settings.TILE_SIZE;
		
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
			b4.typeOfSolid = BodyType.SOLID_TYPE_MOVER; //| BodyType.SOLID_TYPE_WALL;
			ball.addBody( b4 );
		
		// move
	
			var i4:ControllerPlatform = new ControllerPlatform( systemManager );
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