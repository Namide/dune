package dune.system.physic.shapes;

/**
 * @author Namide
 */
class ShapeUtils
{

	public function new() 
	{
		throw "This class can't be instancied";
	}
	
	public static function getPosToTop( a:ShapePoint ):Float
	{
		if ( a.type == ShapeType.CIRCLE )
		{
			return -( cast( a, ShapeCircle ).r + a.anchorY );
		}
		return - a.anchorY;
	}
	public static function getPosToLeft( a:ShapePoint ):Float
	{
		if ( a.type == ShapeType.CIRCLE )
		{
			return -( cast( a, ShapeCircle ).r + a.anchorX );
		}
		return - a.anchorX;
	}
	public static function getPosToBottom( a:ShapePoint ):Float
	{
		if ( a.type == ShapeType.CIRCLE )
		{
			return cast( a, ShapeCircle ).r - a.anchorY;
		}
		else if ( a.type == ShapeType.RECT )
		{
			return cast( a, ShapeRect ).h - a.anchorY;
		}
		return 0;
	}
	public static function getPosToRight( a:ShapePoint ):Float
	{
		if ( a.type == ShapeType.CIRCLE )
		{
			return cast( a, ShapeCircle ).r - a.anchorX;
		}
		else if ( a.type == ShapeType.RECT )
		{
			return cast( a, ShapeRect ).w - a.anchorX;
		}
		return 0;
	}
	
	public static function getW( a:ShapePoint ):Float
	{
		if ( a.type == ShapeType.CIRCLE )
		{
			return cast( a, ShapeCircle ).r * 2;
		}
		else if ( a.type == ShapeType.RECT )
		{
			return cast( a, ShapeRect ).w;
		}
		return 0;
	}
	
	public static function getH( a:ShapePoint ):Float
	{
		if ( a.type == ShapeType.CIRCLE )
		{
			return cast( a, ShapeCircle ).r * 2;
		}
		else if ( a.type == ShapeType.RECT )
		{
			return cast( a, ShapeRect ).h;
		}
		return 0;
	}
	
	public static function hitTest( a:ShapePoint, b:ShapePoint ):Bool
	{
		if ( !hitTestAABB( a, b ) )
		{
			return false;
		}
		else if ( 	a.type == ShapeType.CIRCLE &&
					b.type == ShapeType.CIRCLE )
		{
			return hitTestCircles( cast( a, ShapeCircle ), cast( b, ShapeCircle ) );
		}
		else if ( a.type == ShapeType.CIRCLE &&
				  b.type == ShapeType.POINT )
		{
			return hitTestPointCircle( cast( b, ShapePoint ), cast( a, ShapeCircle ) );
		}
		else if ( a.type == ShapeType.POINT &&
				  b.type == ShapeType.CIRCLE )
		{
			return hitTestPointCircle( cast( a, ShapePoint ), cast( b, ShapeCircle ) );
		}
		
		return true;
	}
	
	private inline static function hitTestAABB( a:ShapePoint, b:ShapePoint ):Bool
	{
		return (	a.aabbXMin <= b.aabbXMax &&
					a.aabbXMax >= b.aabbXMin &&
					a.aabbYMin <= b.aabbYMax &&
					a.aabbYMax >= b.aabbYMin	);
	}
	
	private static function hitTestCircles( a:ShapeCircle, b:ShapeCircle ):Bool
	{
		var d1:Float = b.anchorX - a.anchorX;
		var d2:Float = b.anchorY - a.anchorY;
		var d3:Float = a.r + b.r;
		
		return ( d1 * d1 - d2 * d2 <= d3 * d3 );
	}
	
	private static function hitTestPointCircle( a:ShapePoint, b:ShapeCircle ):Bool
	{
		var d1:Float = b.anchorX - a.anchorX;
		var d2:Float = b.anchorY - a.anchorY;
		
		return ( d1 * d1 - d2 * d2 <= b.r * b.r );
	}
	
}