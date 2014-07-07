package dune.system.graphic.components;
import h2d.Sprite;
import h3d.scene.Object;

/**
 * @author Namide
 */

interface ComponentDisplay 
{
	public function getObject();
	
	public var type(default, null):UInt;
	public function clear():Void;
	
	public function setX( val:Float ):Void;
	public function setY( val:Float ):Void;
}