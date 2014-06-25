package dune.system.physic.shapes;
import dune.compBasic.CompTransform;

/**
 * ...
 * @author Namide
 */
class PhysShapeRect extends PhysShapePoint
{

	public var w(get, set):Float;
	inline function get_w():Float { return w; 	}
	inline function set_w(value:Float):Float { return w = value; }
	
	public var h(get, set):Float;
	inline function get_h():Float { return h; }
	inline function set_h(value:Float):Float { return h = value; }
	
	public function new() 
	{
		super();
		type = PhysShapeType.rect;
		
		w = 0.0;
		h = 0.0;
	}
	
	override public function updateAABB(pe:CompTransform) 
	{
		aabbXMin = pe.x - anchorX;
		aabbXMax = aabbXMin + w;
		aabbYMin = pe.y - anchorY;
		aabbYMax = aabbYMin + h;
	}
	
}