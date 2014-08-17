package dune;

import dune.compBasic.CompTransform;
import dune.entities.Entity;
import dune.models.inputs.InputMobile;
import dune.system.graphic.components.CompDisplay2dSprite;
import dune.system.input.components.CompKeyboard;
import dune.system.SysManager;
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
		
		_entity1 = new Entity();
		var spr = new h2d.Sprite( systemManager.sysGraphic.s2d );
		var tile = hxd.Res.mainChar128x128.toTile();
		var bmp = new h2d.Bitmap(tile, spr);
		var i:InputMobile = new InputMobile();
		i.initX( InputMobile.TYPE_COS, 50, 100, 1000 );
		_entity1.addInput( i );
		_entity1.display = new CompDisplay2dSprite( spr );
		systemManager.addEntity( _entity1 );
		
		var e2 = new Entity();
		var spr2 = new h2d.Sprite( systemManager.sysGraphic.s2d );
		var bmp2 = new h2d.Bitmap(tile, spr2);
		var i2:InputMobile = new InputMobile();
		i2.initX( InputMobile.TYPE_LINEAR, 50, 100, 1000 );
		i2.anchorY = 200;
		e2.addInput( i2 );
		e2.display = new CompDisplay2dSprite( spr2 );
		systemManager.addEntity( e2 );
		
		var e3 = new Entity();
		var spr3 = new h2d.Sprite( systemManager.sysGraphic.s2d );
		var bmp3 = new h2d.Bitmap(tile, spr3);
		var i3:CompKeyboard = new CompKeyboard();
		i3.onTop = 		function ( e:Entity ):Void 	{ e.transform.y -= 5; }
		i3.onRight = 	function ( e:Entity ):Void 	{ e.transform.x += 5; }
		i3.onBottom = 	function ( e:Entity ):Void 	{ e.transform.y += 5; }
		i3.onLeft = 	function ( e:Entity ):Void 	{ e.transform.x -= 5; }
		e3.addInput( i3 );
		e3.display = new CompDisplay2dSprite( spr3 );
		systemManager.addEntity( e3 );
		
		systemManager.refresh(0);
		hxd.System.setLoop( refresh );
	}
	
	private function refresh()
	{
		//_entity1.transform.x += 5;
		systemManager.refresh(0);
		
	}
}