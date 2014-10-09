package dune.helper.core;

/**
 * ...
 * @author Namide
 */
class UrlUtils
{

	public function new() 
	{
		
	}
	
	public static inline function getCurrentSwfDir():String
	{
		return flash.Lib.current.loaderInfo.url.split("/").slice(0, -1).join("/");
	}
}