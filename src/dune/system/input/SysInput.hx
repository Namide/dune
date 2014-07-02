package dune.system.input;

import dune.system.input.components.CompInput;
import dune.system.System;

/**
 * ...
 * @author Namide
 */
class SysInput implements System
{

	private var _inputs:Array<CompInput>;
	
	public function new() 
	{
		_inputs = [];
	}
	
	public inline function addInput( input:CompInput ):Void
	{
		_inputs.push(input);
	}
	
	public inline function removeInput( input:CompInput ):Void
	{
		_inputs.remove(input);
	}
	
	/* INTERFACE dune.system.System */
	
	public inline function refresh(dt:Float):Void 
	{
		for ( input in _inputs )
		{
			input.execute();
		}
	}
	
}