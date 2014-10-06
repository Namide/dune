package dune.helper.core ;

/**
 * ...
 * @author Namide
 */
class BitUtils
{

	public function new() 
	{
		throw "static class!";
	}
	
	public static inline function is( src:UInt, v:UInt ):Bool
	{
		return src == v;
	}
	
	public static inline function has( src:UInt, v:UInt ):Bool
	{
		return src & v == Std.int(v);
	}
	
	public static inline function hasOnly( src:UInt, v:UInt ):Bool
	{
		return src == v;
	}
	
}