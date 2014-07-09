package dune.system.physic;

import dune.system.space.SysSpace;

/**
 * ...
 * @author Namide
 */
class SysPhysic
{
	public var space(default, null):SysSpace;
	
	public var gX(default, default):Float = 0;
	public var gY(default, default):Float = 9;
	
	public function new() 
	{
		space = new SysSpace();
		
	}
	
	/* INTERFACE dune.system.System */
	
	public function refresh():Void 
	{
		
	}
	
}