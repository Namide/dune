package dune.system.input.components;

/**
 * ...
 * @author Namide
 */
class CompMouse extends CompInput
{

	var type(default, null):UInt;
	
	private function new() 
	{
		super(Z);
	}
	
	public function clear() 
	{
		super.clear();
	}
}