package dune.system.core;
import dune.compBasic.CompTransform;

class Link
{
	public var type(default, default):UInt;
	public var parent(default, default):CompTransform;
	public var child(default, default):CompTransform;
	
	public function new( parent:CompTransform, child:CompTransform, type:UInt ) 
	{
		this.type = type;
		this.parent = parent;
		this.child = child;
	}
	
}

/**
 * ...
 * @author Namide
 */
class SysLink
{
	public static inline var TYPE_TOP:UInt = 0;
	public static inline var TYPE_BOTTOM:UInt = 1;
	public static inline var TYPE_LEFT:UInt = 2;
	public static inline var TYPE_RIGHT:UInt = 3;
	public static inline var TYPE_RELATIVE:UInt = 4;
	public static inline var TYPE_ABSOLUTE:UInt = 5;
	
	var _links
	
	public function new() 
	{
		
	}
	
	public function add( parent:CompTransform, child:CompTransform, type:UInt ):Void
	{
		
	}
	
	public function remove( parent:CompTransform, child:CompTransform ):Void
	{
		
	}
	
	public function removeParent( parent:CompTransform ):Void
	{
		
	}
	
	public function removeChild( child:CompTransform ):Void
	{
		
	}
	
	public function refresh():Void
	{
		
	}
	
}