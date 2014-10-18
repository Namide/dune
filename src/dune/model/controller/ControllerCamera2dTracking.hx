package dune.model.controller;

import dune.component.Controller;
import dune.system.graphic.Camera2d;
import dune.system.graphic.SysGraphic;
import dune.system.Settings;
import h2d.Anim;

/**
 * ...
 * @author Namide
 */
class ControllerCamera2dTracking extends Controller
{

	var _cam:Camera2d;
	var _anchorX:Float;
	var _anchorY:Float;
	//var _miSizeX:Float;
	//var _miSizeY:Float;
	//var _centerX:Void->Float;
	//var _centerY:Void->Float;
	var _sysGraphic:SysGraphic;
	
	public var velocity(default, default):Float = 0.2;
	
	public inline function setAnchor( x:Float, y:Float ):Void
	{
		_anchorX = x;
		_anchorY = y;
	}
	
	/*public inline function setCenterScene( x:Void->Float, y:Void->Float ):Void
	{
		_centerX = x;
		_centerY = y;
	}*/
	
	/*public inline function setSize( w:Float, h:Float ):Void
	{
		_miSizeX = w * 0.5;
		_miSizeY = h * 0.5;
	}*/
	
	public function new( sysGraphic:SysGraphic ) 
	{
		super();
		setAnchor( 0, 0 );
		_cam = sysGraphic.camera2d;
		_sysGraphic = sysGraphic;
	}
	
	public override function execute( dt:UInt ):Void
	{
		var lastX:Float = _cam.x;
		var lastY:Float = _cam.y;
		var newX:Float, newY:Float;
		
		
		if ( _sysGraphic.engine.width > Std.int(Settings.LIMIT_RIGHT - Settings.LIMIT_LEFT) )
		{
			newX = ( (_sysGraphic.engine.width - Std.int(Settings.LIMIT_RIGHT - Settings.LIMIT_LEFT) ) >> 1);
		}
		else
		{
			newX = (_sysGraphic.engine.width >> 1) - (entity.transform.x + _anchorX);
			if ( newX > Settings.LIMIT_LEFT ) newX = Settings.LIMIT_LEFT;
			if ( newX < _sysGraphic.engine.width - Std.int(Settings.LIMIT_RIGHT)) newX = _sysGraphic.engine.width - Std.int(Settings.LIMIT_RIGHT);
		}
		
		if ( _sysGraphic.engine.height > Std.int(Settings.LIMIT_DOWN - Settings.LIMIT_TOP) )
		{
			newY = ( (_sysGraphic.engine.height - Std.int(Settings.LIMIT_DOWN - Settings.LIMIT_TOP) ) >> 1);
		}
		else
		{
			newY = (_sysGraphic.engine.height >> 1) - (entity.transform.y + _anchorY);
			if ( newY > Settings.LIMIT_TOP ) newY = Settings.LIMIT_TOP;
			if ( newY < _sysGraphic.engine.height - Std.int(Settings.LIMIT_DOWN)) newY = _sysGraphic.engine.height - Std.int(Settings.LIMIT_DOWN);
		}
		
		_cam.setPos( lastX + (newX-lastX) * velocity, lastY + (newY-lastY) * velocity );
		//trace( cast(entity.display.getObject(), Anim).parent );
	}
	
}