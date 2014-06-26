package dune.system.physic.shapes;
import dune.compBasic.CompTransform;

/**
 * ...
 * @author Namide
 */
class PhysShapePoint
{
	
	public var aabbXMin(get, set):Float;
	inline function get_aabbXMin():Float { return aabbXMin; }
	inline function set_aabbXMin(value:Float):Float { return aabbXMin = value; }
	
	public var aabbXMax(get, set):Float;
	inline function get_aabbXMax():Float { return aabbXMax; }
	inline function set_aabbXMax(value:Float):Float { return aabbXMax = value; }
	
	public var aabbYMin(get, set):Float;
	inline function get_aabbYMin():Float { return aabbYMin; }
	inline function set_aabbYMin(value:Float):Float { return aabbYMin = value; }
	
	public var aabbYMax(get, set):Float;
	inline function get_aabbYMax():Float { return aabbYMax; }
	inline function set_aabbYMax(value:Float):Float { return aabbYMax = value; }
	
	public var type(get, null):UInt;
	inline function get_type():UInt { return type; }
	
	public var anchorX(get, set):Float;
	inline function get_anchorX():Float { return anchorX; }
	inline function set_anchorX(value:Float):Float { return anchorX = value; }
	
	public var anchorY:Float;
	inline function get_anchorY():Float { return anchorY; }
	inline function set_anchorY(value:Float):Float { return anchorY = value; }
	
	private function new()
	{
		type = PhysShapeType.POINT;
		anchorX = 0;
		anchorY = 0;
	}
	
	/**
	 * 
	 * @param	pe	transform of entity parent of this shape
	 */
	public inline function updateAABB( pe:CompTransform )
	{
		aabbXMin =
		aabbXMax = pe.x - anchorX;
		aabbYMin =
		aabbYMax = pe.y - anchorY;
	}
	
}