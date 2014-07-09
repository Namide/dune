package dune.entities;
import dune.compBasic.CompAnimation;
import dune.compBasic.CompTransform;
import dune.system.graphic.components.ComponentDisplay;
import dune.system.input.components.CompInput;
import dune.system.physic.components.CompBody;

/**
 * ...
 * @author Namide
 */
class Entity
{
	public var type:UInt;
	
	public var transform:CompTransform;
	public var inputs(default, null):Array<CompInput>;
	public var bodies(default, null):Array<CompBody>;
	public var display(default, default):ComponentDisplay;
	
	public function new() 
	{
		clear();
	}
	
	public function clear():Void
	{
		type = 0;
		
		if ( transform == null ) transform = new CompTransform();
		else transform.clear();
		
		if ( inputs == null ) { inputs = []; }
		if ( bodies == null ) { bodies = []; }
		
		for ( input in inputs )	{ input.clear(); }
		for ( body in bodies ) { body.clear(); }
	}
	
	public function addBody( body:CompBody ):Void
	{
		body.entity = this;
		bodies.push( body );
	}
	
	public function addInput( input:CompInput ):Void
	{
		input.entity = this;
		inputs.push( input );
	}
}