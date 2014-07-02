package dune.system.graphic.components;

import dune.compBasic.Component;
import h2d.Sprite;

/**
 * ...
 * @author Namide
 */
class CompDisplay2dSprite implements Component, CompDisplay
{

	function _graphic:Sprite;
	
	public function new( graphic:Sprite ) 
	{
		_graphic = graphic;
	}
	
	/* INTERFACE dune.system.graphic.components.CompDisplay */
	
	public inline function setAnim( anim:UInt ):Void
	{
		return;
	}
	
	public inline function setX( val:Float ):Void
	{
		_graphic.x = val;
	}
	public inline function setY( val:Float ):Void
	{
		_graphic.y = val;
	}
	
	/* INTERFACE dune.compBasic.Component */
	
	public function clear():Void 
	{
		
	}
	
}