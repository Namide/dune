package dune.system.physic.components;
import dune.compBasic.CompTransform;

/**
 * ...
 * @author Namide
 */
class CompTransformPhysic extends CompTransform
{
	public inline static var TYPE_MOVABLE:UInt = 2;
	
	public var moved(default, null):Bool;
	
	public var vx(default, default):Float;
	public var vy(default, default):Float;
	
	public function new() 
	{
		super();
	}
	
	override function set_x( value:Float ):Float
	{
		if ( value != x && !moved ) moved = true;
		super.x = value;
		return value;
	}
	
	override function set_y( value:Float ):Float
	{
		if ( value != y && !moved ) moved = true;
		super.y = value;
		return value;
	}
	
	public override function clear()
	{
		super.clear();
		type = CompTransformPhysic.TYPE_MOVABLE;
		moved = false;
		vx = 0;
		vy = 0;
	}
	
}