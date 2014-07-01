package dune.entities;
import h2d.Anim;

/**
 * ...
 * @author Namide
 */
class Entity2dAnim extends Entity
{
	public var display(default, default):Anim;
	
	public function new() 
	{
		super();
	}
	
	override public function clear():Void 
	{
		super.clear();
		
		type = EntityType.H2D_ANIME;
		display.remove();
		display = null;
	}
}