package dune;

import dune.compBasic.CompTransform;
import dune.entities.Entity;
import dune.system.graphic.components.CompDisplay2dSprite;
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
		//spr.x = systemManager.sysGraphic.s2d.width >> 1;
		//spr.y = systemManager.sysGraphic.s2d.height >> 1;

		var tile = hxd.Res.mainChar128x128.toTile();
		var bmp = new h2d.Bitmap(tile, spr);
		
		_entity1.display = new CompDisplay2dSprite( spr );
		
		systemManager.addEntity( _entity1 );
		
		systemManager.refresh(0);
		hxd.System.setLoop( refresh );
	}
	
	private function refresh()
	{
		_entity1.transform.x += 5;
		systemManager.refresh(0);
		
	}
}