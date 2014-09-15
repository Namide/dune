package dune.helpers.core;

/**
 * ...
 * @author Namide
 */
class TimeUtil
{

	public function new() 
	{
		
	}
	
	public static inline function getTime():UInt
	{
		#if flash
			return flash.Lib.getTimer();
		#elseif (neko || php)
			return Sys.time() * 1000;
		#elseif js
			return Date.now().getTime();
		#elseif cpp
			return untyped __global__.__time_stamp() * 1000;
		#else
			return 0;
		#end
	}
	
}