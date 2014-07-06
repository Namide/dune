package dune.compBasic;

/**
 * ...
 * @author namide.com
 */
class CompAnimation implements ComponentBasic
{
	
	public static inline var STAND:UInt = 0;
	public static inline var WALK:UInt = 1;
	public static inline var RUN:UInt = 2;
	public static inline var JUMP:UInt = 3;
	public static inline var CLIMB:UInt = 4;
	
	public var type(default, null):UInt;
	
	/**
	 * Direction of the element
	 */
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
	
	/**
	 * Actual animation
	 */
	public var state(default, set):UInt;
	function set_state(value:UInt):UInt 
	{
		if ( value != state ) 
		{
			state = value;
			onChange();
		}
		return state = value;
	}
	
	public function new() 
	{
		type = ComponentType.ANIMATION;
		clear();
	}
	
	/**
	 * called at the animation changed
	 */
	public dynamic function onChange():Void
	{
		
	}
	
	/* INTERFACE dune.compBasic.Component */
	
	public function clear():Void 
	{
		onChange = function():Void {  };
		dirRight = true;
		state = CompAnimation.STAND;
	}
	
	
	
	
}