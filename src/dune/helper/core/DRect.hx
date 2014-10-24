package dune.helper.core;
import flash.geom.Rectangle;

/**
 * ...
 * @author Namide
 */
class DRect
{

	public var x:Int;
	public var y:Int;
	public var w:Int;
	public var h:Int;
	
	public function new( x:Int = 0, y:Int = 0, w:Int = 0, h:Int = 0 ) 
	{
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
	}
	
	#if ( flash )
	
		public inline static function fromFlashRect( rect:flash.geom.Rectangle ):DRect
		{
			return new DRect( Math.ceil( rect.x ), Math.ceil( rect.y ), Math.floor( rect.width + 1 ), Math.floor( rect.height + 1 ) );
		}
	
	#end
	
}