package dune.system.physic.components;
import dune.compBasic.CompTransform;
import dune.helpers.core.ArrayUtils;
import dune.system.core.SysLink;
import dune.system.physic.components.ContactBodies.ContactBodiesData;
import dune.system.physic.shapes.PhysShapePoint;
import dune.system.physic.shapes.PhysShapeType;
import dune.system.physic.shapes.PhysShapeUtils;
import flash.Lib;

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
	public inline static var ON:Int = 0;
	public inline static var TOP:Int = 1;
	public inline static var RIGHT:Int = 2;
	public inline static var BOTTOM:Int = 4;
	public inline static var LEFT:Int = 8;
	
	public var parent:CompBody;
	public var all(default, default):Array<CompBody>;
	
	public var bottom(default, default):Array<CompBody>;
	public var right(default, default):Array<CompBody>;
	public var left(default, default):Array<CompBody>;
	public var top(default, default):Array<CompBody>;
	public var on(default, default):Array<CompBody>;
	
	public function new( p:CompBody ) 
	{
		parent = p;
		all = [];
		
		bottom = [];
		right = [];
		left = [];
		top = [];
		on = [];
	}
	
	// has (_data & value) == value;
	
	/**
	 * 
	 * @param	solidType		CompBodyType.SOLID_TYPE_WALL, SOLID_TYPE_PLATFORM...
	 * @param	direction		ContactBodies.ON, ContactBodies.LEFT...
	 * @return
	 */
	public function hasTypeOfSolid( solidType:UInt, direction:Int = -1 ):Bool
	{
		if 		( direction == -1 )		return hasTypeInArray( solidType, all );
		else if ( direction == ON )		return hasTypeInArray( solidType, on );
		else if ( direction == TOP )	return hasTypeInArray( solidType, top );
		else if ( direction == RIGHT )	return hasTypeInArray( solidType, right );
		else if ( direction == BOTTOM )	return hasTypeInArray( solidType, bottom );
		else if ( direction == LEFT )	return hasTypeInArray( solidType, left );
		return false;
	}
	
	public inline function hasTypeInArray( solidType:Int, a:Array<CompBody> ):Bool
	{
		return Lambda.exists( a, function(cp:CompBody):Bool
		{
			return cp.typeOfSolid & solidType == solidType;
		});
	}
	
	public inline function hasType( solidType:Int ):Bool
	{
		return hasTypeInArray( solidType, all );
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
		ArrayUtils.clear( on );
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
	
	function getPosA( a:PhysShapePoint, b:PhysShapePoint, dX:Float, dY:Float, overAuthorized:Bool = true ):Int
	{
		var pos:Int = 0;
		
		if ( a.aabbYMin + dY >= b.aabbYMax ) { pos |= TOP; }
		if ( a.aabbXMax + dX <= b.aabbXMin ) { pos |= RIGHT; }
		if ( a.aabbYMax + dY <= b.aabbYMin ) { pos |= BOTTOM; }
		if ( a.aabbXMin + dX >= b.aabbXMax ) { pos |= LEFT; }
		
		// hack if the entity appear in an other
		if ( !overAuthorized && pos == 0  )
		{
			if ( dX == 0 && dY == 0 )
			{
				pos = getPosA( a, b, dX, dY - 1, overAuthorized );
			}
			else
			{
				pos = getPosA( a, b, dX + dX, dY + dY, overAuthorized );
			}
		}
		
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
				data.dist = Math.abs( a.aabbYMax + dY - b.aabbYMin );
			}
			return BOTTOM;
		}
		else if ( pos & TOP == TOP && pos ^ TOP == 0 )
		{
			if ( data != null )
			{
				data.dist = Math.abs( a.aabbYMin + dY - b.aabbYMax );
			}
			return TOP;
		}
		else if ( pos & RIGHT == RIGHT && pos ^ RIGHT == 0 )
		{
			if ( data != null )
			{
				data.dist = Math.abs( a.aabbXMax + dY - b.aabbXMin );
			}
			return RIGHT;
		}
		else if ( pos & LEFT == LEFT && pos ^ LEFT == 0 )
		{
			if ( data != null )
			{
				data.dist = Math.abs( a.aabbXMin + dY - b.aabbXMax );
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
							data.dist = Math.abs( a.aabbXMax + dY - b.aabbXMin );
						}
						return RIGHT;
					}
					else
					{
						if ( data != null )
						{
							data.dist = Math.abs( a.aabbYMax + dY - b.aabbYMin );
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
							data.dist = Math.abs( a.aabbXMin + dY - b.aabbXMax );
						}
						return LEFT;
					}
					else
					{
						if ( data != null )
						{
							data.dist = Math.abs( a.aabbYMax + dY - b.aabbYMin );
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
							data.dist = Math.abs( a.aabbYMin + dY - b.aabbYMax );
						}
						return TOP;
					}
					else
					{
						if ( data != null )
						{
							data.dist = Math.abs( a.aabbXMax + dY - b.aabbXMin );
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
							data.dist = Math.abs( a.aabbYMin + dY - b.aabbYMax );
						}
						return TOP;
					}
					else
					{
						if ( data != null )
						{
							data.dist = Math.abs( a.aabbXMin + dY - b.aabbXMax );
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
				// Recalcule le positionnement
				
					parent.shape.updateAABB( parent.entity.transform );
					var dX:Float = data.body.entity.transform.vX - parent.entity.transform.vX;
					var dY:Float = data.body.entity.transform.vY - parent.entity.transform.vY;
					data.reac = getReactPosA( parent.shape, data.body.shape, dX, dY, data );
					
					calculateReaction( data.body, data.reac, link );
				
				// ---
				
				
				
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
					body.typeOfSolid == CompBodyType.SOLID_TYPE_PLATFORM )
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
			else if ( body.typeOfSolid == CompBodyType.SOLID_TYPE_WALL )
			{
				if ( reac == 0 )
				{
					var dX:Float = body.entity.transform.vX - parent.entity.transform.vX;
					var dY:Float = body.entity.transform.vY - parent.entity.transform.vY;
					reac = getPosA( parent.shape, body.shape, dX, dY, false );
				}
				
				if ( reac == BOTTOM )
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
				else if ( reac == TOP )
				{
					parent.entity.transform.y = shape.aabbYMax - PhysShapeUtils.getPosToTop( parent.shape );
					parent.entity.transform.vY = body.entity.transform.vY;
				}
				else if ( reac == RIGHT )
				{
					parent.entity.transform.x = shape.aabbXMin - PhysShapeUtils.getPosToRight( parent.shape );
					if ( parent.entity.transform.vX > body.entity.transform.vX )
					{
						parent.entity.transform.vX = body.entity.transform.vX;
					}
				}
				else if ( reac == LEFT )
				{
					parent.entity.transform.x = shape.aabbXMax - PhysShapeUtils.getPosToLeft( parent.shape );
					if ( parent.entity.transform.vX < body.entity.transform.vX )
					{
						parent.entity.transform.vX = body.entity.transform.vX;
					}
				}
			}
			
		}
		
		if 		( reac == BOTTOM ) 	{ bottom.push( body ); }
		else if ( reac == TOP ) 	{ top.push( body ); }
		else if ( reac == RIGHT ) 	{ right.push( body ); }
		else if ( reac == LEFT ) 	{ left.push( body ); }
		else						{ on.push( body ); }
	}
	
}