package dune.entities;
import dune.compBasic.CompAnimation;
import dune.compBasic.CompTransform;
import dune.system.graphic.components.CompDisplay;
import dune.system.input.components.CompInput;

/**
 * ...
 * @author Namide
 */
class Entity
{

	public var transform:CompTransform;
	public var display:CompDisplay;
	public var inputs:Array<CompInput>;
	
	public var animation:CompAnimation;
	
	public function new() 
	{
		
	}
	
	public function clear():Void
	{
		transform.clear();
		display.clear();
		for ( input in inputs )
		{
			input.clear();
		}
		animation.clear();
		animation = null;
	}
	
}