package dune.system.graphic.components;

import dune.compBasic.ComponentBasic;
import dune.compBasic.ComponentType;
import h2d.Sprite;

/**
 * ...
 * @author Namide
 */
class CompDisplay2dSprite implements ComponentDisplay
{
	var _graphic:Sprite;
	
	public var type(default, null):UInt;
	
	public inline function getObject():Sprite
	{
		return _graphic;
	}
	
	public function new( graphic:Sprite ) 
	{
		type = ComponentType.DISPLAY_2D;
		_graphic = graphic;
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