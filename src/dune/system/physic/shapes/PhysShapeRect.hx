package dune.system.physic.shapes;
import dune.compBasic.Transform;

/**
 * ...
 * @author Namide
 */
class PhysShapeRect extends PhysShapePoint
{

	public var w(default, default):Float;
	public var h(default, default):Float;
	
	public function new() 
	{
		super();
		type = PhysShapeType.RECT;
		
		w = 0.0;
		h = 0.0;
	}
	
	override public function updateAABB(pe:Transform) 
	{
		aabbXMin = pe.x - anchorX;
		aabbXMax = aabbXMin + w;
		aabbYMin = pe.y - anchorY;
		aabbYMax = aabbYMin + h;
	}
	
}