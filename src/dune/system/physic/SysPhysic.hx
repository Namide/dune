package dune.system.physic;

import dune.system.space.SysSpace;

/**
 * ...
 * @author Namide
 */
class SysPhysic
{
	/**
	 * Scene of the bodies
	 */
	public var space(default, null):SysSpace;
	
	/**
	 * Gravity in X axis
	 */
	//public var gX(default, default):Float = 0;
	
	/**
	 * Gravity in Y axis
	 */
	//public var gY(default, default):Float = 9;
	
	public function new() 
	{
		space = new SysSpace();
	}
	
	public function refresh( dt:Float ):Void 
	{
		space.refreshGrid();
		space.hitTest( true );
	}
	
}