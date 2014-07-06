package dune.system.input.components;

/**
 * ...
 * @author Namide
 */
class CompMouse extends CompInput
{

	var type(default, null):UInt;
	
	public function new() 
	{
		super();
		
	}
	
	/* INTERFACE dune.compBasic.Component */
	
	public function clear() 
	{
		super.clear();
	}
}