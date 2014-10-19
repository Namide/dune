package dune.component;
import dune.helper.core.DTime;

/**
 * ...
 * @author Namide
 */
class Health implements IComponent
{
	public var type(default, null):UInt;
	
	public var health:Float;
	public var lifes:Int;
	
	var _heartedTime:UInt = 0;
	public inline function isHearted():Bool
	{
		return _heartedTime > DTime.getRealMS();
	}
	public inline function heart()
	{
		_heartedTime = DTime.getRealMS() + 500;
	}

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