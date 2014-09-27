package dune.system.graphic.components;

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

class Animator2D
{
	//public var display(default, default):Sprite;
	public var anim(default, default):Anim;
	
	var _listAnimDatas:Array<AnimData>;
	
	public function new() 
	{
		_listAnimDatas = [];
	}
	
	public inline function push( animData:AnimData )
	{
		_listAnimDatas.push( animData );
	}
	
	public inline function play( label:String ):Void
	{
		anim.play( Lambda.find( _listAnimDatas, function( ad:AnimData ):Bool { return ad.label == label; } ).frames );
	}
}

/**
 * ...
 * @author Namide
 */
class AnimController
{

	public function new() 
	{
		
	}
	
}