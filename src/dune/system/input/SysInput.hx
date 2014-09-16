package dune.system.input;

import dune.system.input.components.CompInput;

/**
 * ...
 * @author Namide
 */
class SysInput
{

	private var _befPhys:List<CompInput>;
	private var _aftPhys:List<CompInput>;
	
	public function new() 
	{
		_befPhys = new List();
		_aftPhys = new List();
	}
	
	public inline function addInput( input:CompInput ):Void
	{
		if ( input.beforePhysic ) 	_befPhys.push( input );
		else						_aftPhys.push(input);
	}
	
	public inline function removeInput( input:CompInput ):Void
	{
		if ( input.beforePhysic ) 	_befPhys.remove( input );
		else						_aftPhys.remove(input);
	}
	
	public inline function refresh( dt:UInt, beforePhysic:Bool ):Void 
	{
		if ( beforePhysic )
		{
			for ( input in _befPhys )
			{
				input.execute( dt );
			}
		}
		else
		{
			for ( input in _aftPhys )
			{
				input.execute( dt );
			}
		}
	}
	
}