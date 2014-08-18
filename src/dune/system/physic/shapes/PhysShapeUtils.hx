package dune.system.physic.shapes;

/**
 * @author Namide
 */
class PhysShapeUtils
{

	public function new() 
	{
		throw "This class can't be instancied";
	}
	
	public static function hitTest( a:PhysShapePoint, b:PhysShapePoint ):Bool
	{
		if ( !hitTestAABB( a, b ) )
		{
			return false;
		}
		else if ( 	a.type == PhysShapeType.CIRCLE &&
					b.type == PhysShapeType.CIRCLE )
		{
			return hitTestCircles( cast( a, PhysShapeCircle ), cast( b, PhysShapeCircle ) );
		}
		else if ( a.type == PhysShapeType.CIRCLE &&
				  b.type == PhysShapeType.POINT )
		{
			return hitTestPointCircle( cast( b, PhysShapePoint ), cast( a, PhysShapeCircle ) );
		}
		else if ( a.type == PhysShapeType.POINT &&
				  b.type == PhysShapeType.CIRCLE )
		{
			return hitTestPointCircle( cast( a, PhysShapePoint ), cast( b, PhysShapeCircle ) );
		}
		
		return true;
	}
	
	private inline static function hitTestAABB( a:PhysShapePoint, b:PhysShapePoint ):Bool
	{
		return (	a.aabbXMin <= b.aabbXMax &&
					a.aabbXMax >= b.aabbXMin &&
					a.aabbYMin <= b.aabbYMax &&
					a.aabbYMax >= b.aabbYMin	);
	}
	
	private static function hitTestCircles( a:PhysShapeCircle, b:PhysShapeCircle ):Bool
	{
		var d1:Float = b.anchorX - a.anchorX;
		var d2:Float = b.anchorY - a.anchorY;
		var d3:Float = a.r + b.r;
		
		return ( d1 * d1 - d2 * d2 <= d3 * d3 );
	}
	
	private static function hitTestPointCircle( a:PhysShapePoint, b:PhysShapeCircle ):Bool
	{
		var d1:Float = b.anchorX - a.anchorX;
		var d2:Float = b.anchorY - a.anchorY;
		
		return ( d1 * d1 - d2 * d2 <= b.r * b.r );
	}
	
}