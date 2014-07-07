package dune.system.graphic;

import dune.compBasic.ComponentType;
import dune.entities.Entity;
import dune.system.System;

/**
 * ...
 * @author Namide
 */
class SysGraphic implements System
{

	var _movables:Array<Entity>;
	
	public var engine : h3d.Engine;
	public var s3d : h3d.scene.Scene;
	public var s2d : h2d.Scene;
	
	public function new() 
	{
		engine = new h3d.Engine();
		engine.onReady = init;
		engine.init();
		
		_movables = [];
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
	
	public function add( entity:Entity ):Void
	{
		if ( entity.display == null ) return;
		
		if ( entity.display.type | ComponentType.TRANSFORM_MOVABLE == ComponentType.TRANSFORM_MOVABLE )
		{
			_movables.push( engine );
		}
		
		if ( entity.display.type | ComponentType.DISPLAY_2D == ComponentType.DISPLAY_2D   )
		{
			s2d.addChild( entity.display.getObject() );
		}
		else if ( entity.display.type | ComponentType.DISPLAY_3D == ComponentType.DISPLAY_3D )
		{
			s3d.addChild( entity.display.getObject() );
		}
	}
	
	public function remove( entity:Entity ):Void
	{
		if ( entity.display == null ) return;
		
		if ( entity.display.type | ComponentType.TRANSFORM_MOVABLE == ComponentType.TRANSFORM_MOVABLE )
		{
			_movables.remove( engine );
		}
		
		if ( entity.display.type | ComponentType.DISPLAY_2D == ComponentType.DISPLAY_2D   )
		{
			s2d.removeChild( entity.display.getObject() );
		}
		else if ( entity.display.type | ComponentType.DISPLAY_3D == ComponentType.DISPLAY_3D )
		{
			s3d.removeChild( entity.display.getObject() );
		}
	}
	
	public function refresh( dt:Float ):Void 
	{
		for ( entity in _movables )
		{
			if ( entity.transform )
		}
		
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