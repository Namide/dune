package dune.system.physic.components;
import dune.compBasic.CompTransform;

/**
 * ...
 * @author Namide
 */
class CompTransformPhysic implements CompTransform
{
	public inline static var TYPE_MOVABLE:UInt = 2;
	
	public var moved(get, null):Bool;
	
	
	function get_moved():Bool 
	{
		if ( !restart ) return moved;
		if ( !moved )	return false;
		
		moved = false;
		return true;
	}
	
	override function set_x(value:Float):Float
	{
		if ( value != x && !_moved ) _moved = true;
		super.x = value;
	}
	
	override function set_y(value:Float):Float
	{
		if ( value != y && !_moved ) _moved = true;
		super.y = value;
	}
	
	
	
	private var vx(get, set):Float;
	function get_vx():Float { return vx; }
	function set_vx(value:Float):Float { return vx = value; }
	
	private var vy(get, set):Float;
	function get_vy():Float { return vy; }
	function set_vy(value:Float):Float { return vy = value; }
	
	public function new() 
	{
		super();
	}
	
	public override function clear()
	{
		super.clear();
		type = CompTransformPhysic.TYPE_MOVABLE;
		_moved = false;
		vx = 0;
		vy = 0;
	}
	
}