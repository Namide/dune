package dune.entities;
import dune.compBasic.CompTransform;
import dune.system.input.components.CompInput;

/**
 * ...
 * @author Namide
 */
class Entity
{

	public var transform:CompTransform;
	public var display:Dynamic;
	public var inputs:Array<CompInput>;
	
	public function new() 
	{
		
	}
	
	public function clear():Void
	{
		transform.clear();
		for ( input in inputs )
		{
			input.clear();
		}
	}
	
}