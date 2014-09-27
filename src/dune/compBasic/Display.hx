package dune.compBasic;

/**
* @author Namide
*/
interface Display
{
	public var type(default, null):UInt;
	public function clear():Void;
	
	public function getObject():Dynamic;
	
	public function setX( val:Float ):Void;
	public function setY( val:Float ):Void;
	public function setPos( x:Float, y:Float ):Void;
	
	public function play( label:String ):Void;
	public function isToRight():Bool;
	public function setToRight(val:Bool):Void;
}