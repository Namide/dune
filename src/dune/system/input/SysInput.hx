package dune.system.input;

import dune.system.input.components.CompInput;

/**
 * ...
 * @author Namide
 */
class SysInput
{

	private var _inputs:List<CompInput>;
	
	public function new() 
	{
		_inputs = new List();
	}
	
	public inline function addInput( input:CompInput ):Void
	{
		if ( input.priority ) 	_inputs.push( input );
		else					_inputs.add(input);
	}
	
	public inline function removeInput( input:CompInput ):Void
	{
		_inputs.remove(input);
	}
	
	public inline function refresh( dt:UInt ):Void 
	{
		for ( input in _inputs )
		{
			input.execute( dt );
		}
	}
	
}