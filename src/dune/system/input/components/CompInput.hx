package dune.system.input.components;

import dune.compBasic.Component;
import dune.entities.Entity;

/**
 * ...
 * @author Namide
 */
class CompInput implements Component
{
	/**
	 * Entity attached to the body
	 */
	public var entity(default, default):Entity;
	
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