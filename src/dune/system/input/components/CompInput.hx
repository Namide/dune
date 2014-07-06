package dune.system.input.components;

import dune.compBasic.ComponentBasic;
import dune.entities.Entity;

/**
 * ...
 * @author Namide
 */
class CompInput implements ComponentBasic
{
	/**
	 * Entity attached to the body
	 */
	public var entity(default, default):Entity;
	
	public var type(default, null):UInt;
	
	private function new() 
	{
		
	}
	
	public function execute():Void
	{
		
	}
	
	/* INTERFACE dune.compBasic.Component */
	
	public function clear() 
	{
		
	}
	
}