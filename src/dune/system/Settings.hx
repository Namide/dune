package dune.system;

/**
 * ...
 * @author ...
 */
class Settings
{
	public static inline var FRAME_DELAY:UInt = 20;
	public static inline var GRAVITY:Float =  16 / Settings.FRAME_DELAY;
	
	public static inline var TILE_SIZE:UInt = 32;
	//public inline static var TILE_SIZE:UInt = 32;
	
	public static inline var X_MIN:UInt = - TILE_SIZE;
	public static inline var Y_MIN:UInt = - TILE_SIZE;
	public static inline var X_MAX:UInt = 50 * TILE_SIZE;
	public static inline var Y_MAX:UInt = 50 * TILE_SIZE;
	
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
		return a * FRAME_DELAY;
	}
	
	/**
	 * 
	 * @param	jumpTiles		To jump 4 tiles use 4
	 * @param	gravity			In pixels added by frames
	 * @return
	 */
	public inline static function getJumpStartVY( jumpTiles:Float, gravity:Float = Settings.GRAVITY ):Float
	{
		return Math.sqrt( 2 * gravity * jumpTiles * TILE_SIZE );
	}
	
	public inline static function getJumpVY( maxTilesJump:Float, jumpStartVY:Float, gravity:Float = Settings.GRAVITY ):Float
	{
		return - (jumpStartVY * jumpStartVY / (2 * maxTilesJump * TILE_SIZE) - gravity );
	}
	
	public inline static function getJumpVX( maxTilesJump:Float, jumpStartVY:Float, jumpVY:Float = 0, gravity:Float = Settings.GRAVITY ):Float
	{
		//var frames:Float = jumpStartVY / ( gravity - jumpVY );
		return maxTilesJump * TILE_SIZE * ( gravity - jumpVY ) / jumpStartVY;
	}
}