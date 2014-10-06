package dune.helper.core ;

/**
 * ...
 * @author Namide
 */
class FloatUtils
{

	public function new() 
	{
		throw "static class!";
	}
	
	public inline static function getExposant( n:Float, pow:Float = 2 ):Float
	{
		return Math.log( n ) / Math.log( pow );
	}
	
	public inline static function getExposantInt( n:Float, pow:Float = 2 ):Int
	{
		return Math.round( Math.log( n ) / Math.log( pow ) );
	}
	
	public inline static function getNextPow( n:Float, pow:Float = 2 ):Int
	{
		return Math.round( Math.pow( pow, Math.ceil( getExposant(n, pow) ) ) );
	}
	
}