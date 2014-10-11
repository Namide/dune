package dune.system.graphic;

import dune.component.ComponentType;
import dune.entity.Entity;
import h2d.Sprite;

/**
 * ...
 * @author Namide
 */
class SysGraphic
{
	public var engine : h3d.Engine;
	public var s3d : h3d.scene.Scene;
	public var s2d : h2d.Scene;
	
	public var camera2d(default, null):Camera2d;
	
	public function new( onInitCallback:Void->Void ) 
	{
		engine = new h3d.Engine();
		engine.onReady = function():Void { init(onInitCallback); };
		engine.init();
	}
	
	function init( onInitCallback:Void->Void )
	{
		s3d = new h3d.scene.Scene();
		s2d = new h2d.Scene();
		s3d.addPass(s2d);
		
		camera2d = new Camera2d( s2d );
		
		engine.onResized = function() { onResize(); };
		engine.backgroundColor = 0xFFFFFF;
		
		//trace(engine.driverName(true));
		
		onInitCallback();
		
		//onInit();
	}
	
	/*public dynamic function onInit()
	{
		
	}*/

	public dynamic function onResize()
	{
		
	}
	
	public function add( entity:Entity ):Void
	{
		if ( entity.display == null ) return;
		
		entity.display.setPos( entity.transform.x, entity.transform.y );
		if ( entity.display.type | ComponentType.DISPLAY_2D == ComponentType.DISPLAY_2D   )
		{
			camera2d.display.addChild( entity.display.getObject() );
		}
		else if ( entity.display.type | ComponentType.DISPLAY_3D == ComponentType.DISPLAY_3D )
		{
			s3d.addChild( entity.display.getObject() );
		}
	}
	
	public function remove( entity:Entity ):Void
	{
		if ( entity.display == null ) return;
		
		if ( entity.display.type | ComponentType.DISPLAY_2D == ComponentType.DISPLAY_2D   )
		{
			camera2d.display.removeChild( entity.display.getObject() );
		}
		else if ( entity.display.type | ComponentType.DISPLAY_3D == ComponentType.DISPLAY_3D )
		{
			s3d.removeChild( entity.display.getObject() );
		}
	}
	
	public function refresh( entities:Array<Entity> ):Void 
	{
		for ( entity in entities )
		{
			entity.display.setPos( entity.transform.x, entity.transform.y );
			//entity.transform.moved = false;
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