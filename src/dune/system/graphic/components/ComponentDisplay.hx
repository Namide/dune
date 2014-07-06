package dune.system.graphic.components;

/**
 * @author Namide
 */

interface ComponentDisplay 
{
	public var type(default, null):UInt;
	public function clear():Void;
	
	public function setX( val:Float ):Void;
	public function setY( val:Float ):Void;
	
}