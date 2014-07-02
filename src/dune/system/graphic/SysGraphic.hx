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
		var engine = new h3d.Engine();
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
	
	/* INTERFACE dune.system.System */
	
	public function refresh(dt:Float):Void 
	{
		engine.render(s3d);
	}
	
}