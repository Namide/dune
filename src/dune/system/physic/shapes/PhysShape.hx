package dune.system.physic.shapes;

/**
 * ...
 * @author Namide
 */
class PhysShape
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
	
	private function new()
	{
		
	}
	
	public var hitTestAabb( shape:PhysShape ):Bool
	{
		if (	shape.aabbXMin >= aabbXMax &&
				shape.aabbXMax < aabbXMin &&
				shape.aabbYMin >= aabbYMax &&
				shape.aabbYMax < aabbYMin	)
		{
			return true;
		}
		
		return false;
	}
	
}