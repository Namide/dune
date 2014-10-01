package dune.system.physic.components;
import dune.compBasic.Transform;
import dune.helpers.core.ArrayUtils;
import dune.helpers.core.BitUtils;
import dune.system.physic.components.ContactBodies.ContactBodiesData;
import dune.system.physic.components.ContactBodies.RectLimits;
import dune.system.physic.shapes.PhysShapePoint;
import dune.system.physic.shapes.PhysShapeType;
import dune.system.physic.shapes.PhysShapeUtils;
//import flash.Lib;

class ContactBodiesData
{
	//public var dist(default, default):Float;
	public var body(default, default):CompBody;
	//public var reac(default, default):Int;
	
	public var pos(default, default):Int;
	//public var limit(default, default):Float;
	//public var priority(default, default):Bool;
	
	public function new( compBody:CompBody ) 
	{
		body = compBody;
		//limit = Math.NaN;
		pos = -1;
		//reac = -1;
		//priority = false;
	}
}

class RectLimits
{
	public var topLimit(default, null):Float;
	public var botLimit(default, null):Float;
	public var lefLimit(default, null):Float;
	public var rigLimit(default, null):Float;
	
	public function new( compBody:CompBody ) 
	{
		clear();
	}
	
	public function clear():Void
	{
		topLimit = Math.NaN;
		botLimit = Math.NaN;
		lefLimit = Math.NaN;
		rigLimit = Math.NaN;
	}
	
	public function hasLimit( dir:Int ):Bool
	{
		if ( dir == ContactBodies.TOP ) 	return !Math.isNaN(topLimit);
		if ( dir == ContactBodies.BOTTOM ) 	return !Math.isNaN(botLimit);
		if ( dir == ContactBodies.LEFT ) 	return !Math.isNaN(lefLimit);
		if ( dir == ContactBodies.RIGHT ) 	return !Math.isNaN(rigLimit);
		return false;
	}
	
	public function addMultiLimit( dir:Int, cbd:ContactBodiesData ):Bool
	{
		var solidType:UInt = cbd.body.typeOfSolid;
		var shape:PhysShapePoint = cbd.body.shape;
		
		if ( BitUtils.has( solidType, CompBodyType.SOLID_TYPE_PLATFORM ) ||
			BitUtils.has( solidType, CompBodyType.SOLID_TYPE_WALL ))
		{
			if ( BitUtils.has( cbd.pos, ContactBodies.BOTTOM ) )
			{
				if ( Math.isNaN(botLimit) || shape.aabbYMin > botLimit )
				{
					cbd.pos = ContactBodies.BOTTOM;
					return true;
				}
			}	
		}
		else if ( BitUtils.has( solidType, CompBodyType.SOLID_TYPE_WALL ) )
		{
			if ( BitUtils.has( cbd.pos, ContactBodies.TOP ) )
			{
				if ( Math.isNaN(topLimit) || shape.aabbYMax == topLimit )
				{
					cbd.pos = ContactBodies.TOP;
					return true;
				}
			}
			
			if ( BitUtils.has( cbd.pos, ContactBodies.LEFT ) )
			{
				if ( Math.isNaN(lefLimit) || shape.aabbXMax < lefLimit )
				{
					cbd.pos = ContactBodies.LEFT;
					return true;
				}
			}	
			
			if ( BitUtils.has( cbd.pos, ContactBodies.RIGHT ) )
			{
				if ( Math.isNaN(rigLimit) || shape.aabbXMin < rigLimit )
				{
					cbd.pos = ContactBodies.RIGHT;
					return true;
				}
			}
		}
		
		return false;
	}
	
	public function addLimit( dir:Int, shape:PhysShapePoint, solidType:UInt ):Bool
	{
		if ( dir == 0 )
		{
			return true;
		}
		if ( dir == ContactBodies.BOTTOM &&
			( BitUtils.has( solidType, CompBodyType.SOLID_TYPE_PLATFORM ) ||
			BitUtils.has( solidType, CompBodyType.SOLID_TYPE_WALL ) ) )
		{
			if ( Math.isNaN(botLimit) || shape.aabbYMin > botLimit )
			{
				botLimit = shape.aabbYMin;
			}
			return true;
		}
		else if ( BitUtils.has( solidType, CompBodyType.SOLID_TYPE_WALL ) )
		{
			if ( dir == ContactBodies.TOP )
			{
				if ( Math.isNaN(topLimit) || shape.aabbYMax < topLimit )
				{
					topLimit = shape.aabbYMax;
				}
				return true;
			}
			else if ( dir == ContactBodies.LEFT )
			{
				if ( Math.isNaN(lefLimit) || shape.aabbXMax < lefLimit )
				{
					lefLimit = shape.aabbXMax;
				}
				return true;
			}	
			else if ( dir == ContactBodies.RIGHT )
			{
				if ( Math.isNaN(rigLimit) || shape.aabbXMin < rigLimit )
				{
					rigLimit = shape.aabbXMin;
				}
				return true;
			}
		}
		
		
		return false;
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
	
	var _rectLimits:RectLimits;
	
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
		
		_rectLimits = new RectLimits( p );
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
		
		_rectLimits.clear();
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
		var rest:Array<ContactBodiesData> = [];
		
		_vX = parent.entity.transform.vX;
		_vY = parent.entity.transform.vY;
		
		
		for ( cp in all )
		{
			var dX:Float = cp.entity.transform.vX - _vX;
			var dY:Float = cp.entity.transform.vY - _vY;
			var overAutorized:Bool = !BitUtils.has( cp.typeOfSolid, CompBodyType.SOLID_TYPE_WALL );
			
			/*if ( dataActivated )
			{*/
				var data:ContactBodiesData = new ContactBodiesData( cp );
				data.pos = getPosA( parent.shape, cp.shape, dX, dY, overAutorized );
				//data.reac = getReactPosA( parent.shape, cp.shape, dX, dY, data, overAutorized );
				
				if ( _rectLimits.addLimit( data.pos, cp.shape, cp.typeOfSolid ) ) 
				{
					allDatas.push( data );
				}
				else
				{
					rest.push( data );
				}
				
				//trace( "{" + data.body.entity.transform.x + "," + data.body.entity.transform.y + "} pos:" + data.pos + " reac:" + data.reac + " dist:" + data.dist );
			/*}
			else
			{
				var reac:Int = getReactPosA( parent.shape, cp.shape, dX, dY, overAutorized );
				calculateItem( cp );
				calculateReaction( cp, reac );
				save( cp, reac );
				return;
			}*/
			
		}
		
		//trace( "multi body:" + rest.length );
		for ( cbd in rest )
		{
			if ( _rectLimits.addMultiLimit( cbd.pos, cbd ) )
			{
				rest.remove( cbd );
				allDatas.push( cbd );
			}
		}
		
		//trace( "last body:" + rest.length );
		for ( cbd in rest )
		{
			var dX:Float = cbd.body.entity.transform.vX - _vX;
			var dY:Float = cbd.body.entity.transform.vY - _vY;
			var overAutorized:Bool = !BitUtils.has( cbd.body.typeOfSolid, CompBodyType.SOLID_TYPE_WALL );
			
			cbd.pos = getReactPosA( parent.shape, cbd.body.shape, dX, dY, overAutorized );
			_rectLimits.addLimit( cbd.pos, cbd.body.shape, cbd.body.typeOfSolid );
			allDatas.push( cbd );
		}
		
		
		//calculateChainReaction( allDatas/*, link*/ );
		
		for ( cbd in allDatas )
		{
			calculateItem( cbd.body );
			//calculateReaction( data.body, data.reac );
			save( cbd.body, cbd.pos );
		}
		
		
		applyLimits();
		
	}
	
	
	function applyLimits():Void
	{
		if ( _rectLimits.hasLimit(BOTTOM) )
		{
			if ( _rectLimits.hasLimit(TOP) )
			{
				var y:Float = _rectLimits.botLimit - PhysShapeUtils.getPosToBottom( parent.shape );
				y += _rectLimits.topLimit - PhysShapeUtils.getPosToTop( parent.shape );
				y *= 0.5;
				parent.entity.transform.y = y;
			}
			else
			{
				parent.entity.transform.y = _rectLimits.botLimit - PhysShapeUtils.getPosToBottom( parent.shape );
			}
		}
		else if( _rectLimits.hasLimit(TOP) )
		{
			parent.entity.transform.y = _rectLimits.topLimit - PhysShapeUtils.getPosToTop( parent.shape );
		}
		
		if ( _rectLimits.hasLimit(LEFT) )
		{
			if ( _rectLimits.hasLimit(RIGHT) )
			{
				var x:Float = _rectLimits.lefLimit - PhysShapeUtils.getPosToLeft( parent.shape );
				x += _rectLimits.rigLimit - PhysShapeUtils.getPosToRight( parent.shape );
				x *= 0.5;
				parent.entity.transform.x = x;
			}
			else
			{
				parent.entity.transform.x = _rectLimits.lefLimit - PhysShapeUtils.getPosToLeft( parent.shape );
			}
		}
		else if ( _rectLimits.hasLimit(RIGHT) )
		{
			parent.entity.transform.x = _rectLimits.rigLimit - PhysShapeUtils.getPosToRight( parent.shape );
		}
	}
	
	
	function getPosA( a:PhysShapePoint, b:PhysShapePoint, dX:Float, dY:Float, overAuthorized:Bool = true ):Int
	{
		var pos:Int = 0;
		
		// to avoid float errors => 86.9999999999999 < 87
		dX *= 1.1;
		dY *= 1.1;
		
		if ( a.aabbXMin + dX >= b.aabbXMax ) { pos |= LEFT; }
		if ( a.aabbXMax + dX <= b.aabbXMin ) { pos |= RIGHT; }
		if ( a.aabbYMin + dY >= b.aabbYMax ) { pos |= TOP; }
		if ( a.aabbYMax + dY <= b.aabbYMin ) { pos |= BOTTOM; }
		
		
		// hack if the entity appear in an other
		if ( pos == 0 && !overAuthorized )
		{
			trace("!!");
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
	
	function getReactPosA( a:PhysShapePoint, b:PhysShapePoint, dX:Float, dY:Float, overAuthorized:Bool = true ):Int
	{
		var pos:Int = getPosA( a, b, dX, dY, overAuthorized );
		
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
			return BOTTOM;
		}
		else if ( BitUtils.hasOnly( pos, TOP ) )
		{
			return TOP;
		}
		else if ( BitUtils.hasOnly( pos, RIGHT ) )
		{
			return RIGHT;
		}
		else if ( BitUtils.hasOnly( pos, LEFT ) )
		{
			return LEFT;
		}
		else if ( pos != 0 )
		{
			if ( BitUtils.has( pos, BOTTOM ) )
			{
				if ( BitUtils.has( pos, RIGHT ) )
				{
					if ( pBot + dY - cTop > pRig + dX - cLef )
					{
						return BOTTOM;
					}
					else
					{
						return RIGHT;
					}
				}
				else if ( BitUtils.has( pos, LEFT ) )
				{
					if ( pBot + dY - cTop < pLef + dX - cRig )
					{
						return BOTTOM;
					}
					else
					{
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
						return TOP;
					}
					else
					{
						return RIGHT;
					}
				}
				else if ( BitUtils.has( pos, LEFT ) )
				{
					if ( pTop + dY - cBot < pLef + dX - cRig )
					{
						return TOP;
					}
					else
					{
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
	/*function calculateChainReaction( dataList:Array<ContactBodiesData> ):Void
	{
		var first:Bool = true;
		_vX = parent.entity.transform.vX;
		_vY = parent.entity.transform.vY;
		
		ArrayUtils.clear( all );
		for ( data in dataList )
		{
			if ( PhysShapeUtils.hitTest( parent.shape, data.body.shape ) )
			{
				if ( !first && data.dist >= 0 )
				{
					re
					trace('exclude :', data.reac );
					continue;
				}
				
				calculateItem( data.body );
				calculateReaction( data.body, data.reac );
				save( data.body, data.reac );
				first = false;
					
				all.push( data.body );
			}
		}
		
		//var dX:Float = body.entity.transform.vX - parent.entity.transform.vX;
		//var dY:Float = body.entity.transform.vY - parent.entity.transform.vY;
		//reac = getPosA( parent.shape, body.shape, dX, dY, false );
	}*/
	
	/**
	 * Change reac if first contact has same limits (like a wall with few tiles)
	 * @param	data
	 */
	/*function calculateFirstContact( data:ContactBodiesData ):Void
	{
		var shape:PhysShapePoint = data.body.shape;
		
		if ( _firstContact == null &&
			 ( BitUtils.has( data.body.typeOfSolid, CompBodyType.SOLID_TYPE_WALL ) ||
			 BitUtils.has( data.body.typeOfSolid, CompBodyType.SOLID_TYPE_PLATFORM  ) ) )
		{
			if ( data.reac == BOTTOM ) 		{ data.limit = shape.aabbYMin; }
			else if ( data.reac == TOP ) 	{ data.limit = shape.aabbYMax; }
			else if ( data.reac == RIGHT ) 	{ data.limit = shape.aabbXMin; }
			else if ( data.reac == LEFT ) 	{ data.limit = shape.aabbXMax; }
			
			//trace( "---" );
			//trace( ">>>", data.reac, data.limit, data.limit );
			if ( !Math.isNaN(data.limit) ) _firstContact = data;
		}
		else
		{
			//trace( "  ", data.pos, data.reac, _firstContact.reac == BOTTOM );
			
			if ( BitUtils.has( data.pos, _firstContact.reac ) )
			{
				if ( _firstContact.reac == BOTTOM )
				{
					if ( _firstContact.limit == shape.aabbYMin ) 
					{
						data.reac = _firstContact.reac; //data.limit = _firstContact.limit;
					}
				}
				else if ( _firstContact.reac == TOP )
				{
					if ( _firstContact.limit == shape.aabbYMax )
					{
						data.reac = _firstContact.reac; //data.limit = _firstContact.limit;
					}
				}
				else if ( _firstContact.reac == RIGHT )
				{
					if ( _firstContact.limit == shape.aabbXMin )
					{
						data.reac = _firstContact.reac; //data.limit = _firstContact.limit;
					}
				}
				else if ( _firstContact.reac == LEFT )
				{
					if ( _firstContact.limit == shape.aabbXMax )
					{
						data.reac = _firstContact.reac; //data.limit = _firstContact.limit;
					}
				}
			}
			
			//trace( "->", data.reac, data.limit );
			
		}
	}*/
	
	function calculateItem( body:CompBody ):Void
	{
		if ( BitUtils.has( parent.typeOfSolid, CompBodyType.SOLID_TYPE_EATER ) &&
			 BitUtils.has( body.typeOfSolid, CompBodyType.SOLID_TYPE_ITEM ) )
		{
			for ( fct in parent.onCollide )
			{
				fct( body );
			}
		}
	}
	
	/*function calculateReactionByFirstContact( data:ContactBodiesData ):Bool
	{
		if ( Math.isNaN( data.limit ) ) return false;
		
		
		if ( BitUtils.has( parent.typeOfSolid, CompBodyType.SOLID_TYPE_MOVER ) )
		{
			var body:CompBody = data.body;
			var shape:PhysShapePoint = body.shape;
			var reac:UInt = data.reac;
			if ( reac == BOTTOM && BitUtils.has( body.typeOfSolid, CompBodyType.SOLID_TYPE_PLATFORM ) )
			{
				parent.entity.transform.y = shape.aabbYMin - PhysShapeUtils.getPosToBottom( parent.shape );
				if ( _vY > body.entity.transform.vY ) _vY = body.entity.transform.vY;
			}
			else if ( BitUtils.has( body.typeOfSolid, CompBodyType.SOLID_TYPE_WALL ) )
			{
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
		return false;
	}*/
	
	function calculateReaction( body:CompBody, reac:Int/*, link:SysLink*/ ):Void
	{
		if ( BitUtils.has( parent.typeOfSolid, CompBodyType.SOLID_TYPE_MOVER ) )
		{
			var shape:PhysShapePoint = body.shape;
			if ( reac == BOTTOM && BitUtils.has( body.typeOfSolid, CompBodyType.SOLID_TYPE_PLATFORM ) )
			{
				parent.entity.transform.y = shape.aabbYMin - PhysShapeUtils.getPosToBottom( parent.shape );
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
		//trace( "save:"+reac );
		
		if 		( reac == BOTTOM ) 	{ bottom.push( body ); }
		else if ( reac == TOP ) 	{ top.push( body ); }
		else if ( reac == RIGHT ) 	{ right.push( body ); }
		else if ( reac == LEFT ) 	{ left.push( body ); }
		else						{ on.push( body ); }
	}
	
}