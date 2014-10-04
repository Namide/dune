package dune.system.physic.shapes;
import dune.compBasic.Transform;
/**
 * ...
 * @author Namide
 */
class ShapeCircle extends ShapePoint
{

	public var r(default, default):Float;
	
	public function new() 
	{
		super();
		type = ShapeType.CIRCLE;
		
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