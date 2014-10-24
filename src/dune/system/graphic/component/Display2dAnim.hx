package dune.system.graphic.component ;

import dune.component.IComponent;
import dune.component.ComponentType;
import dune.component.IDisplay;
import dune.helper.core.ArrayUtils;
import dune.helper.core.DRect;
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
class Display2dAnim implements IDisplay//, ComponentAnim
{

	var _graphic:Anim;
	public inline function getObject():Sprite { return _graphic; }
	
	var _listAnimDatas:Array<AnimData>;
	
	var _currentAnim:String;
	var _bounds:DRect;
	
	var _toRight:Bool;
	public inline function isToRight():Bool { return _toRight; }
	public inline function setToRight(val:Bool):Void
	{
		if ( val != _toRight )
		{
			var q:Float = _graphic.scaleY;
			_graphic.scaleX = (val) ? q : -q;
			_graphic.x += (val) ? _bounds.w * q : -_bounds.w * q;
		}
		_toRight = val;
	}
	
	//var _width:Float;
	public var type(default, null):UInt;
	
	public function new( graphic:Anim, bounds:DRect/*width:Float*/ ) 
	{
		type = ComponentType.DISPLAY_2D| ComponentType.DISPLAY_ANIMATED;
		_toRight = true;
		_graphic = graphic;
		_bounds = bounds;
		_listAnimDatas = [];
	}
	
	
	public inline function pushAnimData( animData:AnimData )
	{
		_listAnimDatas.push( animData );
	}
	
	public inline function play( label:String ):Void
	{
		if ( label != _currentAnim )
		{
			if ( !Lambda.exists( _listAnimDatas, function( ad:AnimData ):Bool { return ad.label == label; } ) )
			{
				throw "The animation label \""+label+"\" don't exist";
			}
			_graphic.play( Lambda.find( _listAnimDatas, function( ad:AnimData ):Bool { return ad.label == label; } ).frames );
			_currentAnim = label;
		}
	}
	
	public inline function setPos( x:Float, y:Float ):Void
	{
		_graphic.setPos( _bounds.x + ( (_toRight) ? x : (x+_bounds.w) ), _bounds.y + y );
	}
	public inline function setX( val:Float ):Void
	{
		_graphic.x = _bounds.x + ( (_toRight) ? val : (val+_bounds.w) );
	}
	public inline function setY( val:Float ):Void
	{
		_graphic.y = _bounds.y + val;
	}

	public function clear():Void 
	{
		_graphic = null;
		ArrayUtils.clear( _listAnimDatas );
	}
}