package dune.system.physic.shapes;
import dune.compBasic.CompTransform;
import dune.system.physic.shapes.PhysShape.PhysShapePoint;

/**
 * ...
 * @author Namide
 */
class PhysShapeCircle extends PhysShapePoint
{

	public var r(get, set):Float;
	inline function get_r():Float { return r; }
	inline function set_r(value:Float):Float { return r = value; }
	
	public function new() 
	{
		super();
		type = PhysShapeType.CIRCLE;
		
		radius = 0.0;
	}
	
	override public function updateAABB( pe:CompTransform ) 
	{
		var cx:Float = pe.x - anchorX;
		var cy:Float = pe.y - anchorY;
		
		aabbXMin = cx - r;
		aabbXMax = cx + r;
		aabbYMin = cy - r;
		aabbYMax = cy + r;
	}
	
}