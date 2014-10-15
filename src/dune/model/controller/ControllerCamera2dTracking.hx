package dune.model.controller;

import dune.component.Controller;
import dune.system.graphic.Camera2d;
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
	var _miSizeX:Float;
	var _miSizeY:Float;
	public var velocity(default, default):Float = 0.2;
	
	public inline function setAnchor( x:Float, y:Float ):Void
	{
		_anchorX = x;
		_anchorY = y;
	}
	
	public inline function setSize( w:Float, h:Float ):Void
	{
		_miSizeX = w * 0.5;
		_miSizeY = h * 0.5;
	}
	
	public function new( camera2d:Camera2d ) 
	{
		super();
		setAnchor( 0, 0 );
		_cam = camera2d;
	}
	
	public override function execute( dt:UInt ):Void
	{
		var lastX:Float = _cam.x;
		var lastY:Float = _cam.y;
		var newX:Float = _miSizeX-(entity.transform.x+_anchorX);
		var newY:Float = _miSizeY-(entity.transform.y+_anchorY);
		
		_cam.setPos( lastX + (newX-lastX) * velocity, lastY + (newY-lastY) * velocity );
		//trace( cast(entity.display.getObject(), Anim).parent );
	}
	
}