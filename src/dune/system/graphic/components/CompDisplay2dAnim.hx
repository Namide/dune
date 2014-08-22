package dune.system.graphic.components;

import dune.compBasic.ComponentBasic;
import dune.compBasic.ComponentType;
import h2d.Anim;

/**
 * ...
 * @author Namide
 */
class CompDisplay2dAnim implements ComponentDisplay, ComponentAnim
{

	var _graphic:Anim;
	var _anims:Array<UInt>;
	
	public var type(default, null):UInt;
	
	public function new( graphic:Anim ) 
	{
		type = ComponentType.DISPLAY_2D | ComponentType.ANIMATION;
		_graphic = graphic;
	}

	public function setAnim( anim:UInt, loop:Bool = true ):Void
	{
		_graphic.loop = loop;
		
		var i:UInt = anim >> 1;
		var frameBegin:UInt = _anims[i];
		var frameEnd:UInt = _anims[i+1];
		
		_graphic.play( frameEnd - frameBegin, frameBegin );
	}
	
	public function addAnim( anim:UInt, frameBegin:UInt, frameEnd:UInt ):Void
	{
		var i:UInt = anim >> 1;
		_anims[i] = frameBegin;
		_anims[i + 1] = frameEnd;
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
		_anims = [];
	}
}