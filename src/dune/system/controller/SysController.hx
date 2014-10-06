package dune.system.controller ;

import dune.composition.Controller;

/**
 * ...
 * @author Namide
 */
class SysController
{

	private var _befPhys:List<Controller>;
	private var _aftPhys:List<Controller>;
	
	public function new() 
	{
		_befPhys = new List();
		_aftPhys = new List();
	}
	
	public inline function addController( input:Controller ):Void
	{
		if ( input.beforePhysic ) 	_befPhys.push( input );
		else						_aftPhys.push(input);
	}
	
	public inline function removeController( input:Controller ):Void
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