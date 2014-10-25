package dune.model.controller;

import dune.component.Controller;
import dune.system.graphic.Camera2d;
import dune.system.graphic.SysGraphic;
import dune.system.Settings;
import dune.system.SysManager;
import h2d.Anim;

/**
 * ...
 * @author Namide
 */
class ControllerCamera2dTracking extends Controller
{

	//var _cam:Camera2d;
	var _anchorX:Float;
	var _anchorY:Float;
	//var _miSizeX:Float;
	//var _miSizeY:Float;
	//var _centerX:Void->Float;
	//var _centerY:Void->Float;
	var _sm:SysManager;
	
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
	
	public function new( sm:SysManager ) 
	{
		super();
		setAnchor( 0, 0 );
		//_cam = sm.sysGraphic.camera2d;
		_sm = sm;
	}
	
	public override function execute( dt:UInt ):Void
	{
		var cam = _sm.sysGraphic.camera2d;
		//var eng = _sm.sysGraphic.engine;
		//var set = _sm.settings;
		
		var lastX:Float = cam.x;
		var lastY:Float = cam.y;
		var newX:Float, newY:Float;
		
		
		
		/*if ( eng.width > Std.int(set.limitXMax - set.limitXMin) )
		{
			newX = set.limitXMin - ( ( ( eng.width - Std.int(set.limitXMax - set.limitXMin) ) >> 1 ) + _anchorX );
		}
		else
		{
			newX = -( ( (eng.width >> 1) - (entity.transform.x + _anchorX) ) );
			if ( newX < set.limitXMin ) newX = set.limitXMin;
			if ( newX > Std.int(set.limitXMax) - eng.width ) newX = Std.int(set.limitXMax) - eng.width;
		}
		
		if ( eng.height > Std.int(set.limitYMax - set.limitYMin) )
		{
			newY = set.limitYMin - ( ( ( eng.height - Std.int(set.limitYMax - set.limitYMin) ) >> 1 ) + _anchorY );
		}
		else
		{
			newY = -( (eng.height >> 1) - (entity.transform.y + _anchorY) );
			if ( newY < set.limitYMin ) newY = set.limitYMin;
			if ( newY > Std.int(set.limitYMax) - eng.height ) newY = Std.int(set.limitYMax) - eng.height;
		}
		
		cam.setPos( lastX + (newX-lastX) * velocity, lastY + (newY-lastY) * velocity );
		*/
		
		cam.setPos( lastX + (entity.transform.x - (_anchorX + lastX) ) * velocity, lastY + (entity.transform.y - (_anchorY + lastY) ) * velocity );
	}
	
}