package dune.system.graphic;

import dune.component.ComponentType;
import dune.entity.Entity;
import dune.helper.core.BitUtils;
import dune.system.SysManager;
import flash.events.Event;
import flash.Lib;
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
	var _sm:SysManager;
	
	public function new( sm:SysManager, onInitCallback:Void->Void ) 
	{
		_sm = sm;
		
		engine = new h3d.Engine( true, 8 );
		engine.onReady = function():Void { init(onInitCallback); };
		
		engine.init();
	}
	
	public dynamic function resize( e:Dynamic = null ):Void
	{
		var iw:Int = flash.Lib.current.stage.stageWidth;
		var ih:Int = flash.Lib.current.stage.stageHeight;
		
		var w:Int = 0;
		var h:Int = 0;
		
		var ip:Float = iw / ih;
		var p:Float = _sm.settings.renderProp;
		if ( p > ip )
		{
			w = iw;
			h = Math.floor(w/p);
		}
		else
		{
			h = ih;
			w = Math.floor(h*p);
		}
		//engine.setRenderZone( (iw - w) >> 1, (ih - h) >> 1, w, h );
		engine.resize( w, h );
		var s3d = flash.Lib.current.stage.stage3Ds[0];
		s3d.x = (iw - w) >> 1;
		s3d.y = (ih - h) >> 1;
		camera2d.stageZoom( w / _sm.settings.width );
	}
	
	function init( onInitCallback:Void->Void )
	{
		s3d = new h3d.scene.Scene();
		s2d = new h2d.Scene();
		s3d.addPass(s2d);
		
		camera2d = new Camera2d( _sm, s2d );
		
		//engine.onResized = resize;
		flash.Lib.current.stage.addEventListener( flash.events.Event.RESIZE, resize );
		engine.autoResize = false;
		resize();
		
		//engine.onResized = function() { onResize(); };
		engine.backgroundColor = 0xCCCCCC;
		
		//trace(engine.driverName(true));
		
		
		
		
		//s3d.camera.zNear = 2;
		//s3d.camera.zFar = 15;
		//s3d.camera.pos.set( 6 * Math.cos(time*0.3), 6 * Math.sin(time*0.3), 3 );
		//s3d.camera.movePosAxis( 0, 0, 1 );// .set( 6 * Math.cos(time * 0.3), 6 * Math.sin(time * 0.3), 3 );
		s3d.camera.zNear = 1;
		s3d.camera.zFar = 1000;
		s3d.camera.pos.set( 0, 0, 0 );
		//s3d.camera.moveTargetAxis( _sm.settings.width * 0.5, _sm.settings.height * 0.5, 0 );
		//s3d.camera.m.prependRotate( Math.PI / 2, 0, 0 );
		s3d.camera.target.set( 0, 0, -1 );
		//s3d.camera.up.set( 0, 0, -1 );
		s3d.camera.up.set( 0, -1, 0 );
		
		s3d.lightSystem.ambientLight.set(0.5, 0.5, 0.5);
		var dir = new h3d.scene.DirLight(new h3d.Vector(-0.3, -0.2, -1), s3d);

		var shadow = cast(s3d.renderer.getPass("shadow"), h3d.pass.ShadowMap);
		shadow.lightDirection = dir.direction;
		shadow.blur.count = 3;
		
		
		
		onInitCallback();
		
		//onInit();
	}
	
	/*public dynamic function onInit()
	{
		
	}*/

	/*public dynamic function onResize()
	{
		
	}*/
	
	public function add( entity:Entity ):Void
	{
		if ( entity.display == null ) return;
		
		entity.display.setPos( entity.transform.x, entity.transform.y );
		if ( BitUtils.has( entity.display.type, ComponentType.DISPLAY_2D ) )
		{
			camera2d.display.addChild( entity.display.getObject() );
		}
		else if ( BitUtils.has( entity.display.type, ComponentType.DISPLAY_3D ) )
		{
			s3d.addChild( entity.display.getObject() );
		}
	}
	
	public function remove( entity:Entity ):Void
	{
		if ( entity.display == null ) return;
		
		if ( BitUtils.has( entity.display.type, ComponentType.DISPLAY_2D ) )
		{
			camera2d.display.removeChild( entity.display.getObject() );
		}
		else if ( BitUtils.has( entity.display.type, ComponentType.DISPLAY_3D ) )
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
		
		camera2d.refresh();
		
		engine.render(s3d);
		//engine.begin(); ... render objects ... engine.end()
	}
	
	public function dispose():Void
	{
		flash.Lib.current.stage.removeEventListener( flash.events.Event.RESIZE, resize );
		//engine.dispose();
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