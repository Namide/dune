package dune.system.physic.components;
import dune.compBasic.CompTransform;
import dune.helpers.core.ArrayUtils;
import dune.system.core.SysLink;
import dune.system.physic.components.ContactBodies.ContactBodiesData;
import dune.system.physic.shapes.PhysShapePoint;
import dune.system.physic.shapes.PhysShapeType;
import dune.system.physic.shapes.PhysShapeUtils;

class ContactBodiesData
{
	public var dist(default, default):Float;
	public var body(default, default):CompBody;
	public var pos(default, default):Int;
	public var reac(default, default):Int;
	
	public function new( compBody:CompBody ) 
	{
		body = compBody;
	}
}

/**
 * ...
 * @author namide.com
 */
class ContactBodies
{
	inline static var TOP:Int = 1;
	inline static var RIGHT:Int = 2;
	inline static var BOTTOM:Int = 4;
	inline static var LEFT:Int = 8;
	
	public var parent:CompBody;
	public var all(default, default):Array<CompBody>;
	
	public var bottom(default, default):Array<CompBody>;
	public var right(default, default):Array<CompBody>;
	public var left(default, default):Array<CompBody>;
	public var top(default, default):Array<CompBody>;
	//public var over(default, default):Array<CompBody>;
	
	public function new( p:CompBody ) 
	{
		parent = p;
		all = new Array<CompBody>();
		
		bottom = new Array<CompBody>();
		right = new Array<CompBody>();
		left = new Array<CompBody>();
		top = new Array<CompBody>();
	}
	
	// has (_data & value) == value;
	
	public inline function hasType( solidType:Int ):Bool
	{
		return Lambda.exists( all, function(cp:CompBody):Bool
		{
			return cp.typeOfSolid & solidType == solidType;
		});
	}
	
	public inline function getByType( solidType:Int ):Array<CompBody>
	{
		return all.filter( function( cb:CompBody ):Bool
		{
			return cb.typeOfSolid & solidType == solidType;
		});
	}
	
	public inline function push( cb:CompBody ):Void { all.push( cb ); }
	public inline function length():UInt { return all.length; }
	
	public function clear()
	{
		ArrayUtils.clear( all );
		
		ArrayUtils.clear( bottom );
		ArrayUtils.clear( right );
		ArrayUtils.clear( left );
		ArrayUtils.clear( top );
		//clearArray( over );
	}
	
	/**
	 * Pushes the bodies in contact in the arrays :
	 * top, left, right and bottom
	 */
	public function moveAndDispatch( link:SysLink ):Void
	{
		if ( length() < 0 )
		{
			return;
		}
		
		var allDatas:Array<ContactBodiesData> = new Array<ContactBodiesData>();
		var dataActivated:Bool = all.length > 1;
		
		var absVX:Float = parent.entity.transform.vX;
		var absVY:Float = parent.entity.transform.vY;
		
		link.removeChild( parent.entity.transform );
		
		for ( cp in all )
		{
			var dX:Float = cp.entity.transform.vX - absVX;
			var dY:Float = cp.entity.transform.vY - absVY;
			
			if ( dataActivated )
			{
				var data:ContactBodiesData = new ContactBodiesData( cp );
				data.reac = getReactPosA( parent.shape, cp.shape, dX, dY, data );
				allDatas.push( data );
			}
			else
			{
				var reac:Int = getReactPosA( parent.shape, cp.shape, dX, dY );
				
				if 		( reac == BOTTOM ) 	{ bottom.push( cp ); }
				else if ( reac == TOP ) 	{ top.push( cp ); }
				else if ( reac == RIGHT ) 	{ right.push( cp ); }
				else if ( reac == LEFT ) 	{ left.push( cp ); }
				
				return calculateReaction( cp, reac, link );
			}
			
		}
		
		if ( dataActivated )
		{
			allDatas.sort( function( a:ContactBodiesData, b:ContactBodiesData ):Int
			{
				if ( a.dist > b.dist ) { return 1; }
				return -1;
			});
			calculateChainReaction( allDatas, link );
		}
	}	
	
	function getPosA( a:PhysShapePoint, b:PhysShapePoint, dX:Float, dY:Float ):Int
	{
		var pos:Int = 0;
		
		if ( a.aabbYMin + dY >= b.aabbYMax ) { pos |= TOP; }
		if ( a.aabbXMax + dX <= b.aabbXMin ) { pos |= RIGHT; }
		if ( a.aabbYMax + dY <= b.aabbYMin ) { pos |= BOTTOM; }
		if ( a.aabbXMin + dX >= b.aabbXMax ) { pos |= LEFT; }
		
		// hack if the entity appear in an other
		if ( pos == 0 ) { pos = getPosA( a, b, dX + dX, dY + dY ); }
		
		return pos;
	}
	
	function getReactPosA( a:PhysShapePoint, b:PhysShapePoint, dX:Float, dY:Float, data:ContactBodiesData = null ):Int
	{
		var pos:Int = getPosA( a, b, dX, dY );
		
		if ( data != null ) { data.pos = pos; }
		
		if ( pos & BOTTOM == BOTTOM && pos ^ BOTTOM == 0 )
		{
			if ( data != null )
			{
				data.dist = a.aabbYMax + dY - b.aabbYMin;
			}
			return BOTTOM;
		}
		else if ( pos & TOP == TOP && pos ^ TOP == 0 )
		{
			if ( data != null )
			{
				data.dist = a.aabbYMin + dY - b.aabbYMax;
			}
			return TOP;
		}
		else if ( pos & RIGHT == RIGHT && pos ^ RIGHT == 0 )
		{
			if ( data != null )
			{
				data.dist = a.aabbXMax + dY - b.aabbXMin;
			}
			return RIGHT;
		}
		else if ( pos & LEFT == LEFT && pos ^ LEFT == 0 )
		{
			if ( data != null )
			{
				data.dist = a.aabbXMin + dY - b.aabbXMax;
			}
			return LEFT;
		}
		else
		{
			var pTop:Float = a.aabbYMin;
			var pBot:Float = a.aabbYMax;
			var pLef:Float = a.aabbXMin;
			var pRig:Float = a.aabbXMax;
			
			var cTop:Float = b.aabbYMin;
			var cBot:Float = b.aabbYMax;
			var cLef:Float = b.aabbXMin;
			var cRig:Float = b.aabbXMax;
			
			if ( pos & BOTTOM == BOTTOM )
			{
				if ( pos & RIGHT == RIGHT )
				{
					if ( dY / ( pBot - cTop ) < dX / (pRig - pLef) )
					{
						if ( data != null )
						{
							data.dist = a.aabbXMax + dY - b.aabbXMin;
						}
						return RIGHT;
					}
					else
					{
						if ( data != null )
						{
							data.dist = a.aabbYMax + dY - b.aabbYMin;
						}
						return BOTTOM;
					}
				}
				else if ( pos & LEFT == LEFT )
				{
					if ( dY / ( pBot - cTop ) < dX / (pLef - pRig) )
					{
						if ( data != null )
						{
							data.dist = a.aabbXMin + dY - b.aabbXMax;
						}
						return LEFT;
					}
					else
					{
						if ( data != null )
						{
							data.dist = a.aabbYMax + dY - b.aabbYMin;
						}
						return BOTTOM;
					}
				}
			}
			else if ( pos & TOP == TOP )
			{
				if ( pos & RIGHT == RIGHT )
				{
					if ( dY / ( pTop - cBot ) > dX / (pRig - pLef) )
					{
						if ( data != null )
						{
							data.dist = a.aabbYMin + dY - b.aabbYMax;
						}
						return TOP;
					}
					else
					{
						if ( data != null )
						{
							data.dist = a.aabbXMax + dY - b.aabbXMin;
						}
						return RIGHT;
					}
				}
				else if ( pos & LEFT == LEFT )
				{
					if ( dY / ( pTop - cBot ) > dX / (pLef - pRig) )
					{
						if ( data != null )
						{
							data.dist = a.aabbYMin + dY - b.aabbYMax;
						}
						return TOP;
					}
					else
					{
						if ( data != null )
						{
							data.dist = a.aabbXMin + dY - b.aabbXMax;
						}
						return LEFT;
					}
				}
			}
		}
		
		return 0;
	}
	
	/**
	 * Move the body if it has contact with other bodies (wall, platform...).
	 * You must calculatePositions() before call this function.
	 * 
	 * @param	dataList
	 */
	function calculateChainReaction( dataList:Array<ContactBodiesData>, link:SysLink ):Void
	{
		ArrayUtils.clear( all );
		for ( data in dataList )
		{
			if ( PhysShapeUtils.hitTest( parent.shape, data.body.shape ) )
			{
				calculateReaction( data.body, data.reac, link );
				
				if 		( data.reac == BOTTOM ) { bottom.push( data.body ); }
				else if ( data.reac == TOP ) 	{ top.push( data.body ); }
				else if ( data.reac == RIGHT ) 	{ right.push( data.body ); }
				else if ( data.reac == LEFT ) 	{ left.push( data.body ); }
				
				all.push( data.body );
			}
		}
	}
	
	function calculateReaction( body:CompBody, reac:Int, link:SysLink ):Void
	{
		
		if ( parent.typeOfSolid == CompBodyType.SOLID_TYPE_EATER &&
			 body.typeOfSolid == CompBodyType.SOLID_TYPE_ITEM )
		{
			for ( fct in parent.onCollide )
			{
				fct( body );
			}
		}
		
		if ( parent.typeOfSolid == CompBodyType.SOLID_TYPE_MOVER )
		{
			var shape:PhysShapePoint = body.shape;
			if ( 	reac == BOTTOM &&
					( body.typeOfSolid == CompBodyType.SOLID_TYPE_PLATFORM ||
					  body.typeOfSolid == CompBodyType.SOLID_TYPE_WALL ) )
			{
				parent.entity.transform.y = shape.aabbYMin - PhysShapeUtils.getPosToBottom( parent.shape );
				if ( !link.has( body.entity.transform, parent.entity.transform ) )
				{
					link.add( body.entity.transform, parent.entity.transform, SysLink.TYPE_TOP, false );
				}
				
				if ( parent.entity.transform.vY > body.entity.transform.vY )
				{
					parent.entity.transform.vY = body.entity.transform.vY;
				}
			}
			else if (	reac == TOP &&
						body.typeOfSolid == CompBodyType.SOLID_TYPE_WALL )
			{
				parent.entity.transform.y = shape.aabbYMax - PhysShapeUtils.getPosToTop( parent.shape );
				parent.entity.transform.vY = body.entity.transform.vY;
			}
			else if ( 	reac == RIGHT &&
						body.typeOfSolid == CompBodyType.SOLID_TYPE_WALL )
			{
				parent.entity.transform.x = shape.aabbXMin - PhysShapeUtils.getPosToRight( parent.shape );
				if ( parent.entity.transform.vX > body.entity.transform.vX )
				{
					parent.entity.transform.vX = body.entity.transform.vX;
				}
			}
			else if ( 	reac == LEFT &&
						body.typeOfSolid == CompBodyType.SOLID_TYPE_WALL )
			{
				parent.entity.transform.x = shape.aabbXMax - PhysShapeUtils.getPosToLeft( parent.shape );
				if ( parent.entity.transform.vX < body.entity.transform.vX )
				{
					parent.entity.transform.vX = body.entity.transform.vX;
				}
			}
		}
		
		
	}
	
	/*private inline function clearArray( arr:Array<Dynamic> ):Void
	{
        #if (cpp||php)
           arr.splice(0,arr.length);          
        #else
           untyped arr.length = 0;
        #end
    }*/
	
}