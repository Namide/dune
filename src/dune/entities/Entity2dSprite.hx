package dune.entities;
import h2d.Sprite;

/**
 * ...
 * @author Namide
 */
class Entity2dSprite extends Entity
{
	public var display(default, default):Sprite;
	
	public function new() 
	{
		super();
	}
	
	override public function clear():Void 
	{
		super.clear();
		
		type = EntityType.H2D_SPRITE;
		display.remove();
		display = null;
	}
}