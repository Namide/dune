package dune.compBasic;
import openfl.utils.UInt;

/**
 * ...
 * @author namide.com
 */
class CompAnimation implements Component
{
	
	public static inline var TYPE_STAND:UInt = 0;
	public static inline var TYPE_WALK:UInt = 1;
	public static inline var TYPE_RUN:UInt = 2;
	public static inline var TYPE_JUMP:UInt = 3;
	public static inline var TYPE_CLIMB:UInt = 4;
	
	public var dirRight(default, set_type):Bool;
	inline function set_type(value:Bool):Bool 
	{
		if ( value != dirRight && onChange.length > 0 ) 
		{
			dirRight = value;
			for ( fct in onChange )
			{
				fct.bind();
			}
		}
		return dirRight = value;
	}
	
	public var type(default, set_type):UInt;
	inline function set_type(value:UInt):UInt 
	{
		if ( value != type && onChange.length > 0 ) 
		{
			type = value;
			for ( fct in onChange )
			{
				fct.bind();
			}
		}
		return type = value;
	}
	
	
	
	/**
	 * Like a signal, add to this array the functions called at an animation change
	 */
	public var onChange(default, default):Array < Void -> Void >;
	
	
	public function new() 
	{
		clear();
	}
	
	/* INTERFACE dune.compBasic.Component */
	
	public function clear():Void 
	{
		onChange = [];
		dirRight = true;
		type = CompAnimation.TYPE_STAND;
	}
	
	
	
	
}