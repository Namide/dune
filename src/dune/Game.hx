package dune;

import dune.compBasic.CompTransform;
import dune.entities.Entity;
import dune.helpers.entity.EntityFact;
import dune.models.inputs.IntputKeyboard;
import dune.models.inputs.InputGravity;
import dune.models.inputs.InputMobile;
import dune.system.graphic.components.CompDisplay2dSprite;
import dune.system.physic.components.CompBody;
import dune.system.physic.components.CompBodyType;
import dune.system.physic.shapes.PhysShapeRect;
import dune.system.physic.shapes.PhysShapeType;
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
		hxd.Res.initEmbed();
		//hxd.Res.loader = new hxd.res.Loader(hxd.res.EmbedFileSystem.create());
		
		systemManager = new SysManager();
		systemManager.sysGraphic.onInit = run;
	}
	
	public function run()
	{
		var tile = hxd.Res.mainChar128x128.toTile();
		
		
		
		// MOBILE LINEAR
		/*_entity1 = new Entity();
		var spr = new h2d.Sprite( systemManager.sysGraphic.s2d );
		var bmp = new h2d.Bitmap(tile, spr);
		var i:InputMobile = new InputMobile();
		i.initX( InputMobile.TYPE_LINEAR, 50, 100, 1000 );
		_entity1.addInput( i );
		_entity1.display = new CompDisplay2dSprite( spr );
		systemManager.addEntity( _entity1 );*/
		
		
		
		// MOBILE COS
		var e2 = new Entity();
		
			// graphic
			
				var spr2 = new h2d.Sprite( systemManager.sysGraphic.s2d );
				var bmp2 = new h2d.Bitmap(tile, spr2);
				e2.display = new CompDisplay2dSprite( spr2 );
			
			// move
			
				var i2:InputMobile = new InputMobile();
				i2.initX( InputMobile.TYPE_COS, 128, 100, 1000 );
				i2.anchorY = 250;
				e2.addInput( i2 );
				
			// collision
			
				var b2:CompBody = new CompBody();
				var psr2:PhysShapeRect = new PhysShapeRect();
				psr2.w = 128;
				psr2.h = 128;
				b2.shape = psr2;
				b2.typeOfCollision = CompBodyType.COLLISION_TYPE_PASSIVE;
				b2.typeOfSolid = CompBodyType.SOLID_TYPE_PLATFORM;
				e2.addBody( b2 );
				
		systemManager.addEntity( e2 );
		
		
		
		// PLAYER
		var e3 = new Entity();
		
			// graphic
			
				var spr3 = new h2d.Sprite( systemManager.sysGraphic.s2d );
				var bmp3 = new h2d.Bitmap(tile, spr3);
				e3.display = new CompDisplay2dSprite( spr3 );
				
			// gravity
			
				var g3:InputGravity = new InputGravity();
				e3.addInput( new InputGravity() );
				
			// collision
			
				var b3:CompBody = new CompBody();
				b3.typeOfCollision = CompBodyType.COLLISION_TYPE_ACTIVE;
				b3.typeOfSolid = CompBodyType.SOLID_TYPE_MOVER;
				var psr3:PhysShapeRect = new PhysShapeRect();
				psr3.w = 128;
				psr3.h = 128;
				b3.shape = psr3;
				e3.addBody( b3 );
			
			// Keyboard
			
				var i3:IntputKeyboard = new IntputKeyboard();
				i3.groundVX = 5;
				e3.addInput( i3 );
				
		systemManager.addEntity( e3 );
		
		
		EntityFact.addSolid( systemManager, 0, 512, 256, 256, CompBodyType.SOLID_TYPE_PLATFORM );
		EntityFact.addSolid( systemManager, 256, 512, 256, 256, CompBodyType.SOLID_TYPE_PLATFORM );
		EntityFact.addSolid( systemManager, 512, 512, 256, 256, CompBodyType.SOLID_TYPE_PLATFORM );
		EntityFact.addSolid( systemManager, 512+256, 512, 256, 256, CompBodyType.SOLID_TYPE_PLATFORM );
		
		EntityFact.addSolid( systemManager, 512, 512-128, 128, 128, CompBodyType.SOLID_TYPE_WALL );
		
		
		systemManager.sysPhysic.space.setSize( -1024, -1024, 1024, 1024, 64, 64 );
		systemManager.refresh(0);
		hxd.System.setLoop( refresh );
	}
	
	private function refresh()
	{
		//_entity1.transform.x += 5;
		systemManager.refresh(0);
		
	}
}