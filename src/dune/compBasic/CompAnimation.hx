package dune.compBasic;

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
	
	public var dirRight(default, set):Bool;
	function set_dirRight(value:Bool):Bool 
	{
		if ( value != dirRight ) 
		{
			dirRight = value;
			onChange();
		}
		return dirRight = value;
	}
	
	public var type(default, set):UInt;
	function set_type(value:UInt):UInt 
	{
		if ( value != type ) 
		{
			type = value;
			onChange();
		}
		return type = value;
	}
	
	
	
	/**
	 * called at the animation changed
	 */
	public dynamic function onChange():Void
	{
		
	}
	
	
	public function new() 
	{
		clear();
	}
	
	/* INTERFACE dune.compBasic.Component */
	
	public function clear():Void 
	{
		onChange = function():Void {  };
		dirRight = true;
		type = CompAnimation.TYPE_STAND;
	}
	
	
	
	
}