package dune.system.graphic;

import h2d.Sprite;

/**
 * ...
 * @author Namide
 */
class Camera2d
{
	public var display(default, null):Sprite;
	
	public var x(get, set):Float;
	inline function get_x():Float
	{
		return display.x;
	}
	inline function set_x(val:Float):Float
	{
		return display.x = val;
	}
	
	public var y(get, set):Float;
	inline function get_y():Float
	{
		return display.y;
	}
	inline function set_y(val:Float):Float
	{
		return display.y = val;
	}
	
	public inline function zoom( val:Float ):Void
	{
		display.scale(val);
	}
	
	public var zoomX(get, set):Float;
	inline function get_zoomX():Float
	{
		return display.scaleX;
	}
	inline function set_zoomX(val:Float):Float
	{
		return display.scaleX = val;
	}
	
	public var zoomY(get, set):Float;
	inline function get_zoomY():Float
	{
		return display.scaleY;
	}
	inline function set_zoomY(val:Float):Float
	{
		return display.scaleY = val;
	}
	
	public function new(?parent:Sprite) 
	{
		display = new Sprite(parent);
	}
	
	public inline function setPos( x:Float, y:Float ):Void
	{
		display.setPos( x, y );
	}
	
}