package dune.compBasic;

/**
 * ...
 * @author namide.com
 */
class ComponentType
{
	public inline static var TRANSFORM:UInt = 1;
	//public inline static var TRANSFORM_MOVABLE:UInt = 2;
	//public inline static var TRANSFORM_PHYSIC:UInt = 4;
	
	//public inline static var ANIMATION:UInt = 8;
	
	public inline static var PHYSIC_BODY:UInt = 16;
	
	public inline static var DISPLAY:UInt = 32;
	public inline static var DISPLAY_2D:UInt = 64 | 32;			// 64 | DISPLAY
	public inline static var DISPLAY_3D:UInt = 128 | 32;		// 128 | DISPLAY
	public inline static var DISPLAY_ANIMATED:UInt = 256 | 32;	// 256 | DISPLAY
	
	public function new() 
	{
		throw "This class can't be instancied";
	}
	
}