package dune.system.graphic.components;

import dune.compBasic.Component;
import dune.compBasic.ComponentType;
import dune.compBasic.IDisplay;
import h2d.Sprite;

/**
 * ...
 * @author Namide
 */
class Display2dSprite implements IDisplay
{
	var _graphic:Sprite;
	
	public var type(default, null):UInt;
	
	public inline function getObject():Sprite
	{
		return _graphic;
	}
	
	var _toRight:Bool;
	public inline function isToRight():Bool { return _toRight; }
	public inline function setToRight(val:Bool):Void
	{
		if ( val != _toRight )
		{
			_graphic.scaleX = (val) ? 1 : -1;
		}
		_toRight = val;
	}
	
	public function new( graphic:Sprite ) 
	{
		type = ComponentType.DISPLAY_2D;
		_graphic = graphic;
	}
	
	public inline function play(label:String):Void
	{
		throw "It has'nt animations";
	}
	
	public inline function setPos( x:Float, y:Float ):Void
	{
		_graphic.setPos( x, y );
	}
	
	public inline function setX( val:Float ):Void
	{
		_graphic.x = val;
	}
	public inline function setY( val:Float ):Void
	{
		_graphic.y = val;
	}

	public function clear():Void 
	{
		
	}
	
}