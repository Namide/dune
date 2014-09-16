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
	public var entity(default, set):Entity;
	function set_entity(value:Entity):Entity 
	{
		return entity = value;
	}
	
	/**
	 * Keyboard inputs are dependant, but mobiles (
	 */
	public var beforePhysic(default, default):Bool = false;
	
	public var type(default, null):UInt;
	
	
	
	private function new() 
	{
		clear();
	}
	
	public function execute( dt:UInt ):Void
	{
		
	}
	
	public function clear() 
	{
		
	}
	
}