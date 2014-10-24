package dune.system;

/**
 * ...
 * @author ...
 */
class Settings
{
	public var frameDelay:UInt = 20; 	// =20; - 50 FPS => 1000 / 50
	public var gravity:Float = 2; 		// 40 / FRAME_DELAY
	
	public var textQuality:Float =  1;
	//public static inline var FRAME_ANIM:UInt = 100;
	
	public var tileSize:UInt = 64;
	//public inline static var TILE_SIZE:UInt = 32;
	/*
	public inline var X_MIN:UInt = - TILE_SIZE;
	public inline var Y_MIN:UInt = - TILE_SIZE;
	public inline var X_MAX:UInt = 50 * TILE_SIZE;
	public inline var Y_MAX:UInt = 50 * TILE_SIZE;
	*/
	public var limitXMin:Float = Math.POSITIVE_INFINITY;
	public var limitXMax:Float = Math.NEGATIVE_INFINITY;//12 * TILE_SIZE;
	public var limitYMin:Float = Math.POSITIVE_INFINITY;
	public var limitYMax:Float = Math.NEGATIVE_INFINITY;//50 * TILE_SIZE;
	
	public var autoLimit:Bool = true;
	
	public function new() 
	{
		
		//throw "Static class!";
	}
	
	
	
}