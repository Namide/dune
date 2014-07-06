package dune.compBasic;

/**
 * ...
 * @author Namide
 */
class CompTransform implements ComponentBasic
{

	public inline static var TYPE_STATIC:UInt = 1;
	
	public var type(default, null):UInt;
	
	public var x(default, set):Float;
	function set_x(value:Float):Float { return x = value; }
	
	public var y(default, set):Float;
	function set_y(value:Float):Float { return y = value; }
	
	public function new() 
	{
		type = ComponentType.TRANSFORM;
		clear();
	}
	
	public function clear()
	{
		type = CompTransform.TYPE_STATIC;
		x = 0.0;
		y = 0.0;
	}
	
}