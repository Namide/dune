package dune.compBasic;
import dune.entities.Entity;

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
	
	public function getAbsVx():Float
	{
		var v:Float = vX;
		for ( e in entity.attachedTo )
		{
			v += e.transform.vX;
		}
		return v;
	}
	public function getAbsVy():Float
	{
		var v:Float = vY;
		for ( e in entity.attachedTo )
		{
			v += e.transform.vY;
		}
		return v;
	}
	
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
	
	public function new( parent:Entity ) 
	{
		entity = parent;
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