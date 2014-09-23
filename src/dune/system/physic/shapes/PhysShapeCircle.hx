package dune.system.physic.shapes;
import dune.compBasic.Transform;
import dune.system.physic.shapes.PhysShapePoint;

/**
 * ...
 * @author Namide
 */
class PhysShapeCircle extends PhysShapePoint
{

	public var r(default, default):Float;
	
	public function new() 
	{
		super();
		type = PhysShapeType.CIRCLE;
		
		r = 0.0;
	}
	
	override public function updateAABB( pe:Transform ) 
	{
		var cx:Float = pe.x - anchorX;
		var cy:Float = pe.y - anchorY;
		
		aabbXMin = cx - r;
		aabbXMax = cx + r;
		aabbYMin = cy - r;
		aabbYMax = cy + r;
	}
	
}