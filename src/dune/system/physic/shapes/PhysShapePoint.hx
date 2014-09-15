package dune.system.physic.shapes;
import dune.compBasic.CompTransform;

/**
 * ...
 * @author Namide
 */
class PhysShapePoint
{
	
	public var aabbXMin(default, null):Float;
	public var aabbXMax(default, null):Float;
	public var aabbYMin(default, null):Float;
	public var aabbYMax(default, null):Float;
	
	public var type(default, null):UInt;
	
	public var anchorX(default, default):Float;
	public var anchorY(default, default):Float;
	
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
	public function updateAABB( pe:CompTransform )
	{
		aabbXMin =
		aabbXMax = pe.x - anchorX;
		aabbYMin =
		aabbYMax = pe.y - anchorY;
	}
}