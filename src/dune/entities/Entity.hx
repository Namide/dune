package dune.entities;
import dune.compBasic.CompTransform;
import dune.helpers.core.ArrayUtils;
import dune.system.graphic.components.ComponentDisplay;
import dune.system.input.components.CompInput;
import dune.system.physic.components.CompBody;

/**
 * ...
 * @author Namide
 */
class Entity
{
	public var type(default, default):UInt;
	
	public var transform(default, null):CompTransform;
	
	public var inputs(default, null):Array<CompInput>;
	public var bodies(default, null):Array<CompBody>;
	//public var attachedTo(default, null):Array<Entity>;
	
	public var display(default, set):ComponentDisplay;
	private function set_display( cd:ComponentDisplay ):ComponentDisplay
	{
		//transform.moved = true;
		cd.setX( transform.x );
		cd.setY( transform.y );
		return display = cd;
	}
	
	public function new() 
	{
		clear();
	}
	
	public function clear():Void
	{
		type = 0;
		
		if ( transform == null )	{ transform = new CompTransform( this ); }
		else 						{ transform.clear(); }
		
		if ( inputs == null ) { inputs = []; }
		if ( bodies == null ) { bodies = []; }
		//if ( attachedTo == null ) { attachedTo = []; }
		
		for ( input in inputs )	{ input.clear(); }
		for ( body in bodies ) 	{ body.clear(); }
		
		//ArrayUtils.clear( attachedTo );
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