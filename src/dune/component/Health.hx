package dune.component;

/**
 * ...
 * @author Namide
 */
class Health implements IComponent
{
	public var type(default, null):UInt;
	
	public var health:Float;
	public var lifes:Int;

	public function new( health:Float = 1, lifes:Int = 1 ) 
	{
		type = ComponentType.HEALTH;
		this.health = health;
		this.lifes = lifes;
	}
	
	
	public function clear():Void 
	{
		
	}
	
}