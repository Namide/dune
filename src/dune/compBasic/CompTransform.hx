package dune.compBasic;

/**
 * ...
 * @author Namide
 */
class CompTransform
{

	public inline static var TYPE_STATIC:UInt = 1;
	
	private var _type:UInt;
	public inline function getType():UInt { return _type; }
	
	private var _x:Float;
	public inline function getX():Float { return _x; }
	public inline function setX( x:Float ):Void { _x = x; }
	
	private var _y:Float;
	public inline function getY():Float { return _y; }
	public inline function setY( y:Float ):Void { _y = y; }
	
	public function new() 
	{
		_type = CompTransform.TYPE_STATIC;
		_x = 0.0;
		_y = 0.0;
	}
	
}