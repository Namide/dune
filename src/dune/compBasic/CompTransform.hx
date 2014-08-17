package dune.compBasic;

/**
 * ...
 * @author Namide
 */
class CompTransform implements ComponentBasic
{

	/*public inline static var TYPE_STATIC:UInt = 1;
	public inline static var TYPE_MOVABLE:UInt = 2;*/
	
	public var type(default, null):UInt;
	
	/**
	 * If v (velocity) is activated,
	 * the position is updated by the velocity.
	 * Without, you must use vX and vY to storage.
	 */
	public var vActive(default, default):Bool;
	
	/**
	 * Velocity in X-axis.
	 * Used if the entitie is physic dependant
	 */
	public var vX(default, default):Float;
	
	/**
	 * Velocity in Y-axis.
	 * Used if the entitie is physic dependant
	 */
	public var vY(default, default):Float;
	
	/**
	 * X-axis position
	 */
	public var x(default, set):Float;
	inline function set_x( value:Float ):Float
	{
		if ( value != x && !moved )
		{
			moved = true;
			onMoved();
		}
		return x = value;
	}
	
	/**
	 * Y-axis position
	 */
	public var y(default, set):Float;
	inline function set_y( value:Float ):Float
	{
		if ( value != y && !moved )
		{
			moved = true;
			onMoved();
		}
		return y = value;
	}
	
	public var moved(default, default):Bool;
	
	/**
	 * Used in the system manager, don't change it
	 */
	public dynamic function onMoved():Void { }
	
	public function new() 
	{
		//type = ComponentType.TRANSFORM;
		clear();
	}
	
	public function clear()
	{
		x = 0.0;
		y = 0.0;
		vX = 0.0;
		vY = 0.0;
		moved = false;
	}
	
}