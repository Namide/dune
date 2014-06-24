package dune.system.physic;

import dune.system.System;

/**
 * ...
 * @author Namide
 */
class SysPhysic implements System
{

	public var _gX(get, set):Float;
	function get_gX():Float { return _gX; }
	function set_gX(value:Float):Float { return _gX = value; }
	
	public var _gY(get, set):Float;
	function get_gY():Float { return _gY; }
	function set_gY(value:Float):Float { return _gY = value; }
	
	public function new() 
	{
		
	}
	
	/* INTERFACE dune.system.System */
	
	public function refresh(dt:Float):Void 
	{
		
	}
	
	
}