package dune.input;

import dune.input.core.IInput;

/**
 * ...
 * @author Namide
 */
class MultiInput implements IInput
{

	var _a:IInput;
	var _b:IInput;
	
	public function new( a:IInput, b:IInput ) 
	{
		_a = a;
		_b = b;
	}
	
	/* INTERFACE dune.input.core.IInput */
	
	public function getAxisX():Float 
	{
		var valA:Float = _a.getAxisX();
		if ( valA != 0 ) return valA;
		return _b.getAxisX();
	}
	
	public function getAxisY():Float 
	{
		var valA:Float = _a.getAxisY();
		if ( valA != 0 ) return valA;
		return _b.getAxisY();
	}
	
	public function getB1():Float 
	{
		var valA:Float = _a.getB1();
		if ( valA != 0 ) return valA;
		return _b.getB1();
	}
	
	public function getB2():Float 
	{
		var valA:Float = _a.getB2();
		if ( valA != 0 ) return valA;
		return _b.getB2();
	}
	
	public function getStart():Bool 
	{
		var valA:Bool = _a.getStart();
		if ( valA ) return valA;
		return _b.getStart();
	}
	
	public function getSelect():Bool 
	{
		var valA:Bool = _a.getSelect();
		if ( valA ) return valA;
		return _b.getSelect();
	}
	
}