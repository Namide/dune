package dune.system.physic.components;
import dune.compBasic.Transform;
import dune.helpers.core.ArrayUtils;
import dune.helpers.core.BitUtils;
import dune.system.physic.components.ContactBodies.ContactBodiesData;
import dune.system.physic.shapes.PhysShapePoint;
import dune.system.physic.shapes.PhysShapeType;
import dune.system.physic.shapes.PhysShapeUtils;
//import flash.Lib;

class ContactBodiesData
{
	public var dist(default, default):Float;
	public var body(default, default):CompBody;
	public var pos(default, default):Int;
	public var reac(default, default):Int;
	//public var priority(default, default):Bool;
	
	public function new( compBody:CompBody ) 
	{
		body = compBody;
		//priority = false;
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
	
	var _vX:Float;
	var _vY:Float;
	
	//public var moveInDirection:UInt = 0;
	//public var isCrush:Bool = false;
	
	//var _toDeleteTemp:Dynamic;
	
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
	
	/*public inline function getByType( solidType:Int ):Array<CompBody>
	{
		return all.filter( function( cb:CompBody ):Bool
		{
			return cb.typeOfSolid & solidType == solidType;
		});
	}*/
	
	public function getByType( solidType:Int, direction:Int = -1 ):Array<CompBody>
	{
		if 		( direction == -1 )		return all.filter( function( cb:CompBody ):Bool { return cb.typeOfSolid & solidType == solidType; });
		else if ( direction == ON )		return on.filter( function( cb:CompBody ):Bool { return cb.typeOfSolid & solidType == solidType; });
		else if ( direction == TOP )	return top.filter( function( cb:CompBody ):Bool { return cb.typeOfSolid & solidType == solidType; });
		else if ( direction == RIGHT )	return right.filter( function( cb:CompBody ):Bool { return cb.typeOfSolid & solidType == solidType; });
		else if ( direction == BOTTOM )	return bottom.filter( function( cb:CompBody ):Bool { return cb.typeOfSolid & solidType == solidType; });
		else if ( direction == LEFT )	return left.filter( function( cb:CompBody ):Bool { return cb.typeOfSolid & solidType == solidType; });
		return new Array<CompBody>();
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
	public function moveAndDispatch( /*link:SysLink*/ ):Void
	{
		if ( length() < 0 )
		{
			return;
		}
		
		var allDatas:Array<ContactBodiesData> = [];
		var dataActivated:Bool = all.length > 1;
		//moveInDirection = 0;
		//isCrush = false;
		
		_vX = parent.entity.transform.vX;
		_vY = parent.entity.transform.vY;
		
		//link.removeChild( parent.entity.transform );
		
		//trace( "===" );
		
		//_toDeleteTemp = { output:"", write:false };
		
		for ( cp in all )
		{
			var dX:Float = cp.entity.transform.vX - _vX;
			var dY:Float = cp.entity.transform.vY - _vY;
			var overAutorized:Bool = !BitUtils.has( cp.typeOfSolid, CompBodyType.SOLID_TYPE_WALL );
			
			if ( dataActivated )
			{
				var data:ContactBodiesData = new ContactBodiesData( cp );
				data.reac = getReactPosA( parent.shape, cp.shape, dX, dY, data, overAutorized );
				allDatas.push( data );
				
				trace( "{" + data.body.entity.transform.x + "," + data.body.entity.transform.y + "} pos:" + data.pos + " reac:" + data.reac + " dist:" + data.dist );
			}
			else
			{
				var reac:Int = getReactPosA( parent.shape, cp.shape, dX, dY, overAutorized );
				calculateReaction( cp, reac/*, link*/ );
				save( cp, reac );
				return;
			}
			
		}
		
		if ( dataActivated )
		{
			allDatas.sort( function( a:ContactBodiesData, b:ContactBodiesData ):Int
			{
				if ( a.dist > b.dist ) { return 1; }
				/*else if ( a.dist == b.dist )
				{
					if ( a.priority ) { return -1; }
					else if ( b.priority ) { return 1; }
					return -1;
				}*/
				return -1;
			});
			
			//_toDeleteTemp.output += " NUM:" + allDatas.length + "\n";
			
			//trace("---");
			for ( temp in allDatas )
			{
				if ( allDatas.length > 2 ) 
					trace( "pos:" + temp.pos + " reac:" + temp.reac + " dist:" + temp.dist );
					
				//trace( "->", temp.pos, temp.reac, parent.shape.aabbXMin, parent.shape.aabbYMax );
				//trace( temp.pos, temp.dist );
			}
			
			calculateChainReaction( allDatas/*, link*/ );
		}
		
		//if (  _toDeleteTemp.write && allDatas.length > 2 ) trace( _toDeleteTemp.output );
	}	
	
	function getPosA( a:PhysShapePoint, b:PhysShapePoint, dX:Float, dY:Float, overAuthorized:Bool = true ):Int
	{
		var pos:Int = 0;
		
		
		if ( a.aabbXMin + dX >= b.aabbXMax ) { pos |= LEFT; }
		if ( a.aabbXMax + dX <= b.aabbXMin ) { pos |= RIGHT; }
		if ( a.aabbYMin + dY >= b.aabbYMax ) { pos |= TOP; }
		if ( a.aabbYMax + dY <= b.aabbYMin ) { pos |= BOTTOM; }
		
		// hack if the entity appear in an other
		if ( pos == 0 && !overAuthorized )
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
	
	function getReactPosA( a:PhysShapePoint, b:PhysShapePoint, dX:Float, dY:Float, data:ContactBodiesData = null, overAuthorized:Bool = true ):Int
	{
		var pos:Int = getPosA( a, b, dX, dY, overAuthorized );
		if ( data != null ) { data.pos = pos; }
		
		var pTop:Float = a.aabbYMin;
		var pBot:Float = a.aabbYMax;
		var pLef:Float = a.aabbXMin;
		var pRig:Float = a.aabbXMax;
		
		var cTop:Float = b.aabbYMin;
		var cBot:Float = b.aabbYMax;
		var cLef:Float = b.aabbXMin;
		var cRig:Float = b.aabbXMax;
		
		
		if ( BitUtils.hasOnly( pos, BOTTOM ) )
		{
			if ( data != null )
			{
				data.dist = pBot + dY - cTop;
				//data.priority = true;
				//data.dist = Math.abs( a.aabbYMax + dY - b.aabbYMin );
			}
			return BOTTOM;
		}
		else if ( BitUtils.hasOnly( pos, TOP ) )
		{
			if ( data != null )
			{
				data.dist = pTop + dY - cBot;
				//data.priority = true;
				//data.dist = Math.abs( a.aabbYMin + dY - b.aabbYMax );
			}
			return TOP;
		}
		else if ( BitUtils.hasOnly( pos, RIGHT ) )
		{
			if ( data != null )
			{
				data.dist = pRig + dX - cLef;
				//data.priority = true;
				//data.dist = Math.abs( a.aabbXMax + dX - b.aabbXMin );
			}
			return RIGHT;
		}
		else if ( BitUtils.hasOnly( pos, LEFT ) )
		{
			if ( data != null )
			{
				data.dist = pLef + dX - cRig;
				//data.priority = true;
				//data.dist = Math.abs( a.aabbXMin + dX - b.aabbXMax );
			}
			return LEFT;
		}
		else if ( pos != 0 )
		{
			
			//if ( pos == 0 ) pos = getPosA( a, b, dX, dY, false );
			
			//_toDeleteTemp.write = true;
			//_toDeleteTemp.output += "dx: " + dX + " dy:" + dY + "\n";
			
			if ( BitUtils.has( pos, BOTTOM ) )
			{
				if ( BitUtils.has( pos, RIGHT ) )
				{
					if ( pBot + dY - cTop > pRig + dX - cLef )
					{
						if ( data != null )
						{
							data.dist = pBot + dY - cTop;
						}
						return BOTTOM;
					}
					else
					{
						if ( data != null )
						{
							data.dist = pRig + dX - cLef;
							
						}
						return RIGHT;
					}
				}
				else if ( BitUtils.has( pos, LEFT ) )
				{
					if ( pBot + dY - cTop < pLef + dX - cRig )
					{
						if ( data != null )
						{
							data.dist = pBot + dY - cTop;
						}
						return BOTTOM;
					}
					else
					{
						if ( data != null )
						{
							data.dist = pLef + dX - cRig;
						}
						return LEFT;
					}
				}
			}
			else if ( BitUtils.has( pos, TOP ) )
			{
				if ( BitUtils.has( pos, RIGHT ) )
				{
					if ( pTop + dY - cBot < pRig + dX - cLef )
					{
						if ( data != null )
						{
							data.dist = pTop + dY - cBot;
						}
						return TOP;
					}
					else
					{
						if ( data != null )
						{
							data.dist = pRig + dX - cLef;
						}
						return RIGHT;
					}
				}
				else if ( BitUtils.has( pos, LEFT ) )
				{
					if ( pTop + dY - cBot < pLef + dX - cRig )
					{
						if ( data != null )
						{
							data.dist = pTop + dY - cBot;
						}
						return TOP;
					}
					else
					{
						if ( data != null )
						{
							data.dist = pLef + dX - cRig;
						}
						return LEFT;
					}
				}
			}
			
			/*if ( BitUtils.has( pos, BOTTOM ) )
			{
				if ( BitUtils.has( pos, RIGHT ) )
				{					
					if ( dY + ( pBot - cTop ) <= dX + (pRig - cLef) )
					{
						if ( data != null )
						{
							data.dist = pRig + dX - cLef;
						}
						return RIGHT;
					}
					else
					{
						if ( data != null )
						{
							data.dist = pBot + dY - cTop;
						}
						return BOTTOM;
					}
				}
				else if ( BitUtils.has( pos, LEFT ) )
				{
					
					trace("-?-", dY, pBot, cTop, dX, pLef, cRig );
					
					if ( dY + ( pBot - cTop ) <= dX + (pLef - cRig) )
					{
						if ( data != null )
						{
							data.dist = pLef + dX - cRig;
						}
						return LEFT;
					}
					else
					{
						if ( data != null )
						{
							data.dist = pBot + dY - cTop;
						}
						return BOTTOM;
					}
				}
			}
			else if ( BitUtils.has( pos, TOP ) )
			{
				if ( BitUtils.has( pos, RIGHT ) )
				{
					if ( dY + ( pTop - cBot ) > dX + (pRig - cLef) )
					{
						if ( data != null )
						{
							data.dist = pTop + dY - cBot;
						}
						return TOP;
					}
					else
					{
						if ( data != null )
						{
							data.dist = pRig + dX - cLef;
						}
						return RIGHT;
					}
				}
				else if ( BitUtils.has( pos, LEFT ) )
				{
					if ( dY + ( pTop - cBot ) > dX + (pLef - cRig) )
					{
						if ( data != null )
						{
							data.dist = pTop + dY - cBot;
						}
						return TOP;
					}
					else
					{
						if ( data != null )
						{
							data.dist = pLef + dX - cRig;
						}
						return LEFT;
					}
				}
			}*/
		}
		
		if ( data != null )
		{
			data.dist = Math.POSITIVE_INFINITY;
		}
		
		return 0;
	}
	
	/**
	 * Move the body if it has contact with other bodies (wall, platform...).
	 * You must calculatePositions() before call this function.
	 * 
	 * @param	dataList
	 */
	function calculateChainReaction( dataList:Array<ContactBodiesData>/*, link:SysLink*/ ):Void
	{
		var first:Bool = true;
		_vX = parent.entity.transform.vX;
		_vY = parent.entity.transform.vY;
		
		ArrayUtils.clear( all );
		for ( data in dataList )
		{
			if ( PhysShapeUtils.hitTest( parent.shape, data.body.shape ) )
			{
				// Recalcule le positionnement
				
					/*if (!first)
					{
						parent.shape.updateAABB( parent.entity.transform );
						var dX:Float = data.body.entity.transform.vX - _vX;
						var dY:Float = data.body.entity.transform.vY - _vY;
						data.reac = getReactPosA( parent.shape, data.body.shape, dX, dY, data );
					}
					else
					{
						first = false;
					}*/
					
					calculateReaction( data.body, data.reac/*, link*/ );
					save( data.body, data.reac );
				
				// ---
				
				all.push( data.body );
			}
		}
		
		//var dX:Float = body.entity.transform.vX - parent.entity.transform.vX;
		//var dY:Float = body.entity.transform.vY - parent.entity.transform.vY;
		//reac = getPosA( parent.shape, body.shape, dX, dY, false );
	}
	
	function calculateReaction( body:CompBody, reac:Int/*, link:SysLink*/ ):Void
	{
		if ( BitUtils.has( parent.typeOfSolid, CompBodyType.SOLID_TYPE_EATER ) &&
			 BitUtils.has( body.typeOfSolid, CompBodyType.SOLID_TYPE_ITEM ) )
		{
			for ( fct in parent.onCollide )
			{
				fct( body );
			}
		}
		
		if ( BitUtils.has( parent.typeOfSolid, CompBodyType.SOLID_TYPE_MOVER ) )
		{
			var shape:PhysShapePoint = body.shape;
			if ( reac == BOTTOM && BitUtils.has( body.typeOfSolid, CompBodyType.SOLID_TYPE_PLATFORM ) )
			{
				//if ( BitUtils.has(reac, TOP) ) { isCrush = true; return; }
				parent.entity.transform.y = shape.aabbYMin - PhysShapeUtils.getPosToBottom( parent.shape );
				//moveInDirection |= BOTTOM;
				if ( _vY > body.entity.transform.vY ) _vY = body.entity.transform.vY;
			}
			else if ( BitUtils.has( body.typeOfSolid, CompBodyType.SOLID_TYPE_WALL ) )
			{
				
				if ( reac == 0 )
				{
					var dX:Float = body.entity.transform.vX - _vX;
					var dY:Float = body.entity.transform.vY - _vY;
					//trace( "->" + reac, dX, dY );
					reac = getPosA( parent.shape, body.shape, dX, dY, false );
					//trace( "=>" + reac );
				}
				
				
				if ( reac == BOTTOM )
				{
					//if ( BitUtils.has(reac, TOP) ) { isCrush = true; return; }
					parent.entity.transform.y = shape.aabbYMin - PhysShapeUtils.getPosToBottom( parent.shape );
					if ( _vY > body.entity.transform.vY ) _vY = body.entity.transform.vY;
					//moveInDirection |= BOTTOM;
				}
				else if ( reac == TOP )
				{
					//if ( BitUtils.has(reac, BOTTOM) ) { isCrush = true; return; }
					parent.entity.transform.y = shape.aabbYMax - PhysShapeUtils.getPosToTop( parent.shape );
					if ( _vY < body.entity.transform.vY ) _vY = body.entity.transform.vY;
					//moveInDirection |= TOP;
				}
				else if ( reac == RIGHT )
				{
					//if ( BitUtils.has(reac, LEFT) ) { isCrush = true; return; }
					parent.entity.transform.x = shape.aabbXMin - PhysShapeUtils.getPosToRight( parent.shape );
					if ( _vX > body.entity.transform.vX ) _vX = body.entity.transform.vX;
					//moveInDirection |= RIGHT;
				}
				else if ( reac == LEFT )
				{
					//if ( BitUtils.has(reac, RIGHT) ) { isCrush = true; return; }
					parent.entity.transform.x = shape.aabbXMax - PhysShapeUtils.getPosToLeft( parent.shape );
					//moveInDirection |= LEFT;
					if ( _vX < body.entity.transform.vX ) _vX = body.entity.transform.vX;
				}
			}
			
		}
	}
	
	private function save( body:CompBody, reac:UInt ):Void
	{
		trace( "save:"+reac );
		
		if 		( reac == BOTTOM ) 	{ bottom.push( body ); }
		else if ( reac == TOP ) 	{ top.push( body ); }
		else if ( reac == RIGHT ) 	{ right.push( body ); }
		else if ( reac == LEFT ) 	{ left.push( body ); }
		else						{ on.push( body ); }
	}
	
}