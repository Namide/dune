package dune.helpers.core;

/**
 * ...
 * @author namide.com
 */
class ArrayUtils
{

	public function new() 
	{
		throw "static class!";
	}
	
	public static inline function clear( arr:Array<Dynamic> ):Void
	{
        #if (cpp||php)
           arr.splice(0,arr.length);          
        #else
           untyped arr.length = 0;
        #end
    }
	
}