package dune.entities;

import dune.compBasic.IDisplay;
import dune.compBasic.Transform;
import dune.helpers.core.ArrayUtils;
import dune.compBasic.Controller;
import dune.system.physic.components.CompBody;

/**
 * ...
 * @author Namide
 */
class Entity
{
	public var type(default, default):UInt;
	
	public var transform(default, null):Transform;
	
	public var controllers(default, null):Array<Controller>;
	public var bodies(default, null):Array<CompBody>;
	
	public var display(default, set):IDisplay;
	private function set_display( cd:IDisplay ):IDisplay
	{
		cd.setPos( transform.x, transform.y );
		return display = cd;
	}
	
	public function new() 
	{
		clear();
	}
	
	public function clear():Void
	{
		type = 0;
		
		if ( transform == null )	{ transform = new Transform( this ); }
		else 						{ transform.clear(); }
		
		if ( controllers == null ) 	{ controllers = []; }
		if ( bodies == null ) 		{ bodies = []; }
		
		for ( input in controllers )	{ input.clear(); }
		for ( body in bodies ) 			{ body.clear(); }
	}
	
	public function addBody( body:CompBody ):Void
	{
		body.entity = this;
		bodies.push( body );
	}
	
	public function addController( input:Controller ):Void
	{
		input.entity = this;
		controllers.push( input );
	}
}