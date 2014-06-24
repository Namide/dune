package dune.system.physic.components;
import dune.compBasic.CompTransform;

/**
 * ...
 * @author Namide
 */
class CompTransformPhysic implements CompTransform
{
	public inline static var TYPE_MOVABLE:UInt = 2;
	
	private var _moved:Bool;
	public inline function getMoved( restart:Bool = false ):Bool
	{
		if ( !restart ) return _moved;
		if ( !_moved )	return false;
		
		_moved = false;
		return true;
	}
	
	override public function setX(x:Float):Void 
	{
		if ( x != _x && !_moved ) _moved = true;
		super.setX(x);
	}
	
	override public function setY(y:Float):Void 
	{
		if ( y != _y && !_moved ) _moved = true;
		super.setY(y);
	}
	
	private var _vx:Float;
	public inline function getVX():Float { return _vx; }
	public inline function setVX( vx:Float ):Void { _vx = vx; }
	
	private var _vy:Float;
	public inline function getVY():Float { return _vy; }
	public inline function setVY( vy:Float ):Void { _vy = vy; }
	
	public function new() 
	{
		super();
		_type = CompTransformPhysic.TYPE_MOVABLE;
		_moved = false;
		_vx = 0;
		_vy = 0;
	}
	
}