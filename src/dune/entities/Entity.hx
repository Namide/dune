package dune.entities;
import dune.compBasic.CompAnimation;
import dune.compBasic.CompTransform;
import dune.system.input.components.CompInput;

/**
 * ...
 * @author Namide
 */
class Entity
{
	public var type:UInt;
	
	public var transform:CompTransform;
	public var inputs:Array<CompInput>;
	
	public function new() 
	{
		
	}
	
	public function clear():Void
	{
		type = EntityType.SIMPLE;
		
		transform.clear();
		for ( input in inputs )
		{
			input.clear();
		}
	}
	
}