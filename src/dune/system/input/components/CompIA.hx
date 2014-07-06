package dune.system.input.components;

/**
 * ...
 * @author Namide
 */
class CompIA extends CompInput
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