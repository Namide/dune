package dune.system;

/**
 * ...
 * @author ...
 */
class Settings
{
	public static inline var FRAME_DELAY:UInt = 20;
	public static inline var GRAVITY:Float =  10 / Settings.FRAME_DELAY;
	
	public static inline var TILE_SIZE:UInt = 32;
	//public inline static var TILE_SIZE:UInt = 32;
	
	
	public function new() 
	{
		throw "Static class!";
	}
	
	public inline static function getVX( tilesBySec:Float ):Float
	{
		var f:Float = 1000 / FRAME_DELAY;
		var p:Float = tilesBySec * TILE_SIZE;
		return p / f;
	}
	
	public inline static function getAccX( distTile:Float, timeMS:UInt ):Float
	{
		var a:Float = distTile * TILE_SIZE / ( 1000 * timeMS / FRAME_DELAY );
		return a;
	}
	
	/**
	 * 
	 * @param	jumpTiles		To jump 4 tiles use 4
	 * @param	gravity			In pixels added by frames
	 * @return
	 */
	public inline static function getJumpStartVY( jumpTiles:Float, gravity:Float = Settings.GRAVITY ):Float
	{
		var y:Float = jumpTiles * TILE_SIZE;
		var vY:Float = 0;
		while ( y > 0 )
		{
			vY += gravity;
			y -= vY;
		}
		return vY;
	}
	
	public inline static function getJumpVY( jumpMoreTiles:Float, jumpStartVY:Float, gravity:Float = Settings.GRAVITY ):Float
	{
		var n:Float = jumpStartVY / gravity;
		return jumpMoreTiles * TILE_SIZE / n;
	}
	
}