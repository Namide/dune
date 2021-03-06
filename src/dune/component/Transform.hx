package dune.component ;
import dune.entity.Entity;

/**
 * ...
 * @author Namide
 */
class Transform implements IComponent
{

	/*public inline static var TYPE_STATIC:UInt = 1;
	public inline static var TYPE_MOVABLE:UInt = 2;*/
	
	public var type(default, null):UInt;
	
	/**
	 * Entity attached to the transform component
	 */
	public var entity(default, null):Entity;
	
	/**
	 * If v (velocity) is activated,
	 * the position is updated by the velocity.
	 * Without, you must use vX and vY to storage.
	 */
	public var vActive(default, default):Bool;
	
	/**
	 * Velocity in X-axis (in pixel per frame).
	 * Used if the entitie is physic dependant
	 */
	public var vX(default, default):Float;
	
	/**
	 * Velocity in Y-axis (in pixel per frame).
	 * Used if the entitie is physic dependant
	 */
	public var vY(default, default):Float;
	
	/**
	 * center X-axis
	 */
	public var centerX(default, default):Float;
	
	/**
	 * center Y-axis
	 */
	public var centerY(default, default):Float;
	
	/**
	 * Direction in X-axis (-1, 0 or 1).
	 */
	public var dirX(default, default):Int = 1;
	
	/**
	 * Direction in Y-axis (-1, 0 or 1).
	 */
	public var dirY(default, default):Int = 0;
	
	
	public function setXY( x:Float, y:Float ):Void
	{
		if ( x != this.x || y != this.y )
		{
			this.x = x;
			this.y = y;
			onMoved();
		}
	}
	
	/**
	 * X-axis position
	 */
	public var x(default, set):Float;
	inline function set_x( value:Float ):Float
	{
		if ( value != x )
		{
			x = value;
			onMoved();
		}
		return x;
	}
	
	/**
	 * Y-axis position
	 */
	public var y(default, set):Float;
	inline function set_y( value:Float ):Float
	{
		if ( value != y )
		{
			y = value;
			onMoved();
		}
		return y;
	}
	
	//public var moved(default, default):Bool;
	
	/**
	 * Used in the system manager, don't change it
	 */
	public dynamic function onMoved():Void { }
	
	public function new( parent:Entity ) 
	{
		entity = parent;
		centerX = 0;
		centerY = 0;
		//type = ComponentType.TRANSFORM;
		clear();
	}
	
	public function clear()
	{
		x = 0.0;
		y = 0.0;
		vX = 0.0;
		vY = 0.0;
		//moved = false;
	}
	
}