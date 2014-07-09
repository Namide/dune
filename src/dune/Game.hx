package dune;

import dune.compBasic.CompTransform;
import dune.entities.Entity;
import dune.system.graphic.components.CompDisplay2dSprite;
import dune.system.SysManager;

/**
 * ...
 * @author Namide
 */
class Game
{
	public var systemManager:SysManager;
	
	public function new() 
	{
		hxd.Res.initEmbed();
		//hxd.Res.loader = new hxd.res.Loader(hxd.res.EmbedFileSystem.create());
		
		systemManager = new SysManager();
		systemManager.sysGraphic.onInit = run;
	}
	
	public function run()
	{
		
		var e1:Entity = new Entity();
		var spr = new h2d.Sprite( systemManager.sysGraphic.s2d );
		spr.x = systemManager.sysGraphic.s2d.width >> 1;
		spr.y = systemManager.sysGraphic.s2d.height >> 1;

		var tile = hxd.Res.hxlogo.toTile();
		var bmp = new h2d.Bitmap(tile, spr);
		
		e1.display = new CompDisplay2dSprite( spr );
		e1.transform = new CompTransform();
		
		systemManager.addEntity( e1 );
		
		systemManager.refresh(0);
	}
}