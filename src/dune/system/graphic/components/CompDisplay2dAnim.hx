package dune.system.graphic.components;

import dune.compBasic.ComponentBasic;
import dune.compBasic.ComponentType;
import dune.compBasic.Display;
import dune.helpers.core.ArrayUtils;
import h2d.Anim;
import h2d.Sprite;

class AnimData
{
	public var label(default, default):String;
	public var frames(default, default):Array<h2d.Tile>;
	
	public function new( label:String, frames:Array<h2d.Tile> ) 
	{
		this.label = label;
		this.frames = frames;
	}
}

/**
 * ...
 * @author Namide
 */
class CompDisplay2dAnim implements Display//, ComponentAnim
{

	var _graphic:Anim;
	public inline function getObject():Sprite { return _graphic; }
	
	var _listAnimDatas:Array<AnimData>;
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
	
	public var type(default, null):UInt;
	
	public function new( graphic:Anim ) 
	{
		type = ComponentType.DISPLAY_2D;// | ComponentType.ANIMATION;
		_toRight = true;
		_graphic = graphic;
		_listAnimDatas = [];
	}
	
	
	public inline function pushAnimData( animData:AnimData )
	{
		_listAnimDatas.push( animData );
	}
	
	public inline function play( label:String ):Void
	{
		_graphic.play( Lambda.find( _listAnimDatas, function( ad:AnimData ):Bool { return ad.label == label; } ).frames );
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
		_graphic = null;
		ArrayUtils.clear( _listAnimDatas );
	}
}