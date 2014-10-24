package dune.component ;

/**
* @author Namide
*/
interface IDisplay
{
	public var type(default, null):UInt;
	public var width(default, default):Int;
	public function clear():Void;
	
	public function getObject():Dynamic;
	
	public function setX( val:Float ):Void;
	public function setY( val:Float ):Void;
	public function setPos( x:Float, y:Float ):Void;
	
	public function play( label:String ):Void;
	public function isToRight():Bool;
	public function setToRight(val:Bool):Void;
}