package dune.system.graphic;

import dune.system.System;

/**
 * ...
 * @author Namide
 */
class SysGraphic implements System
{

	public var engine : h3d.Engine;
	public var s3d : h3d.scene.Scene;
	public var s2d : h2d.Scene;
	
	public function new() 
	{
		engine = new h3d.Engine();
		engine.onReady = init;
		engine.init();
	}
	
	function init()
	{
		engine.onResized = onResize;
		s3d = new h3d.scene.Scene();
		s2d = new h2d.Scene();
		
		s3d.addPass(s2d);
	}

	function onResize()
	{
		
	}
	
	public function refresh(dt:Float):Void 
	{
		engine.render(s3d);
		//engine.begin(); ... render objects ... engine.end()
	}
	
	/*public function begin():Void
	{
		engine.begin();
	}
	
	public function end():Void
	{
		engine.end();
	}*/
	
}