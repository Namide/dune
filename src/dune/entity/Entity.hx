package dune.entity ;

import dune.component.IDisplay;
import dune.component.Transform;
import dune.helper.core.ArrayUtils;
import dune.component.Controller;
import dune.system.physic.component.Body;

/**
 * ...
 * @author Namide
 */
class Entity
{
	public var type(default, default):UInt;
	
	public var transform(default, null):Transform;
	
	public var controllers(default, null):Array<Controller>;
	public var bodies(default, null):Array<Body>;
	
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
	
	public function addBody( body:Body ):Void
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