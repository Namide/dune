package dune.system.physic.component ;
import dune.component.Transform;
import dune.helper.core.ArrayUtils;
import dune.helper.core.BitUtils;
import dune.system.physic.component.ContactBodies.ContactBodiesData;
import dune.system.physic.component.ContactBodies.RectLimits;
import dune.system.physic.shapes.ShapePoint;
import dune.system.physic.shapes.ShapeType;
import dune.system.physic.shapes.ShapeUtils;
//import flash.Lib;

class ContactBodiesData
{
	//public var dist(default, default):Float;
	public var body(default, default):Body;
	//public var reac(default, default):Int;
	
	public var pos(default, default):Int;
	//public var limit(default, default):Float;
	//public var priority(default, default):Bool;
	
	public function new( compBody:Body ) 
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
	
	public function new( compBody:Body ) 
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
		var shape:ShapePoint = cbd.body.shape;
		
		if ( BitUtils.has( solidType, BodyType.SOLID_TYPE_PLATFORM ) ||
			BitUtils.has( solidType, BodyType.SOLID_TYPE_WALL ))
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
		else if ( BitUtils.has( solidType, BodyType.SOLID_TYPE_WALL ) )
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
	
	public function addLimit( dir:Int, shape:ShapePoint, solidType:UInt ):Bool
	{
		if ( dir == 0 )
		{
			return true;
		}
		if ( dir == ContactBodies.BOTTOM &&
			( BitUtils.has( solidType, BodyType.SOLID_TYPE_PLATFORM ) ||
			BitUtils.has( solidType, BodyType.SOLID_TYPE_WALL ) ) )
		{
			if ( Math.isNaN(botLimit) || shape.aabbYMin > botLimit )
			{
				botLimit = shape.aabbYMin;
			}
			return true;
		}
		else if ( BitUtils.has( solidType, BodyType.SOLID_TYPE_WALL ) )
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
	
	public var parent:Body;
	public var all(default, default):Array<Body>;
	
	public var bottom(default, default):Array<Body>;
	public var right(default, default):Array<Body>;
	public var left(default, default):Array<Body>;
	public var top(default, default):Array<Body>;
	public var on(default, default):Array<Body>;
	
	var _vX:Float;
	var _vY:Float;
	
	var _rectLimits:RectLimits;
	
	//var _toDeleteTemp:Dynamic;
	
	public function new( p:Body ) 
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
	
	public inline function hasTypeInArray( solidType:Int, a:Array<Body> ):Bool
	{
		return Lambda.exists( a, function(cp:Body):Bool
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
	
	public function getByType( solidType:Int, direction:Int = -1 ):Array<Body>
	{
		if 		( direction == -1 )		return all.filter( function( cb:Body ):Bool { return cb.typeOfSolid & solidType == solidType; });
		else if ( direction == ON )		return on.filter( function( cb:Body ):Bool { return cb.typeOfSolid & solidType == solidType; });
		else if ( direction == TOP )	return top.filter( function( cb:Body ):Bool { return cb.typeOfSolid & solidType == solidType; });
		else if ( direction == RIGHT )	return right.filter( function( cb:Body ):Bool { return cb.typeOfSolid & solidType == solidType; });
		else if ( direction == BOTTOM )	return bottom.filter( function( cb:Body ):Bool { return cb.typeOfSolid & solidType == solidType; });
		else if ( direction == LEFT )	return left.filter( function( cb:Body ):Bool { return cb.typeOfSolid & solidType == solidType; });
		return new Array<Body>();
	}
	
	public inline function push( cb:Body ):Void { all.push( cb ); }
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
			var overAutorized:Bool = !BitUtils.has( cp.typeOfSolid, BodyType.SOLID_TYPE_WALL );
			
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
			var overAutorized:Bool = !BitUtils.has( cbd.body.typeOfSolid, BodyType.SOLID_TYPE_WALL );
			
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
				var y:Float = _rectLimits.botLimit - ShapeUtils.getPosToBottom( parent.shape );
				y += _rectLimits.topLimit - ShapeUtils.getPosToTop( parent.shape );
				y *= 0.5;
				parent.entity.transform.y = y;
			}
			else
			{
				parent.entity.transform.y = _rectLimits.botLimit - ShapeUtils.getPosToBottom( parent.shape );
			}
			
			for ( fct in parent.onCollideWall )
			{
				fct( parent );
			}
		}
		else if( _rectLimits.hasLimit(TOP) )
		{
			parent.entity.transform.y = _rectLimits.topLimit - ShapeUtils.getPosToTop( parent.shape );
			
			for ( fct in parent.onCollideWall )
			{
				fct( parent );
			}
		}
		
		if ( _rectLimits.hasLimit(LEFT) )
		{
			if ( _rectLimits.hasLimit(RIGHT) )
			{
				var x:Float = _rectLimits.lefLimit - ShapeUtils.getPosToLeft( parent.shape );
				x += _rectLimits.rigLimit - ShapeUtils.getPosToRight( parent.shape );
				x *= 0.5;
				parent.entity.transform.x = x;
			}
			else
			{
				parent.entity.transform.x = _rectLimits.lefLimit - ShapeUtils.getPosToLeft( parent.shape );
			}
			
			for ( fct in parent.onCollideWall )
			{
				fct( parent );
			}
		}
		else if ( _rectLimits.hasLimit(RIGHT) )
		{
			parent.entity.transform.x = _rectLimits.rigLimit - ShapeUtils.getPosToRight( parent.shape );
			
			for ( fct in parent.onCollideWall )
			{
				fct( parent );
			}
		}
	}
	
	
	function getPosA( a:ShapePoint, b:ShapePoint, dX:Float, dY:Float, overAuthorized:Bool = true ):Int
	{
		var pos:Int = 0;
		
		// to avoid float errors => 86.9999999999999 < 87
		//dX *= 1.1;
		//dY *= 1.1;
		
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
	
	function getReactPosA( a:ShapePoint, b:ShapePoint, dX:Float, dY:Float, overAuthorized:Bool = true ):Int
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
	
	function calculateItem( body:Body ):Void
	{
		if ( BitUtils.has( parent.typeOfSolid, BodyType.SOLID_TYPE_EATER ) &&
			 BitUtils.has( body.typeOfSolid, BodyType.SOLID_TYPE_ITEM ) )
		{
			for ( fct in parent.onCollideItem )
			{
				fct( parent, body );
			}
		}
	}
	
	function calculateReaction( body:Body, reac:Int/*, link:SysLink*/ ):Void
	{
		if ( BitUtils.has( parent.typeOfSolid, BodyType.SOLID_TYPE_MOVER ) )
		{
			var shape:ShapePoint = body.shape;
			if ( 	//(reac == BOTTOM /*|| reac == ON*/) &&
					BitUtils.has( body.typeOfSolid, BodyType.SOLID_TYPE_PLATFORM ) )
			{
				/*parent.entity.transform.y = shape.aabbYMin - ShapeUtils.getPosToBottom( parent.shape );
				if ( _vY > body.entity.transform.vY )
				{
					_vY = body.entity.transform.vY;
				}*/
				if ( 	reac == BOTTOM &&
						BitUtils.has( body.typeOfPlatform, BodyType.PLATFORM_DIR_DOWN ) )
				{
					//if ( BitUtils.has(reac, TOP) ) { isCrush = true; return; }
					parent.entity.transform.y = shape.aabbYMin - ShapeUtils.getPosToBottom( parent.shape );
					if ( _vY > body.entity.transform.vY )
					{
						_vY = body.entity.transform.vY;
						/*for ( fct in parent.onCollideWall )
						{
							fct( body );
						}*/
					}
					//moveInDirection |= BOTTOM;
				}
				else if ( 	reac == TOP &&
							BitUtils.has( body.typeOfPlatform, BodyType.PLATFORM_DIR_UP ) )
				{
					//if ( BitUtils.has(reac, BOTTOM) ) { isCrush = true; return; }
					parent.entity.transform.y = shape.aabbYMax - ShapeUtils.getPosToTop( parent.shape );
					if ( _vY < body.entity.transform.vY )
					{
						_vY = body.entity.transform.vY;
						/*for ( fct in parent.onCollideWall )
						{
							fct( body );
						}*/
					}
					//moveInDirection |= TOP;
				}
				else if (	reac == RIGHT &&
							BitUtils.has( body.typeOfPlatform, BodyType.PLATFORM_DIR_LEFT ) )
				{
					//if ( BitUtils.has(reac, LEFT) ) { isCrush = true; return; }
					parent.entity.transform.x = shape.aabbXMin - ShapeUtils.getPosToRight( parent.shape );
					if ( _vX > body.entity.transform.vX )
					{
						_vX = body.entity.transform.vX;
						/*for ( fct in parent.onCollideWall )
						{
							fct( body );
						}*/
					}
					//moveInDirection |= RIGHT;
				}
				else if ( 	reac == LEFT &&
							BitUtils.has( body.typeOfPlatform, BodyType.PLATFORM_DIR_RIGHT ) )
				{
					//if ( BitUtils.has(reac, RIGHT) ) { isCrush = true; return; }
					parent.entity.transform.x = shape.aabbXMax - ShapeUtils.getPosToLeft( parent.shape );
					//moveInDirection |= LEFT;
					if ( _vX < body.entity.transform.vX )
					{
						_vX = body.entity.transform.vX;
						/*for ( fct in parent.onCollideWall )
						{
							fct( body );
						}*/
					}
				}
			}
			else if ( BitUtils.has( body.typeOfSolid, BodyType.SOLID_TYPE_WALL ) )
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
					parent.entity.transform.y = shape.aabbYMin - ShapeUtils.getPosToBottom( parent.shape );
					if ( _vY > body.entity.transform.vY )
					{
						_vY = body.entity.transform.vY;
						/*for ( fct in parent.onCollideWall )
						{
							fct( body );
						}*/
					}
					//moveInDirection |= BOTTOM;
				}
				else if ( reac == TOP )
				{
					//if ( BitUtils.has(reac, BOTTOM) ) { isCrush = true; return; }
					parent.entity.transform.y = shape.aabbYMax - ShapeUtils.getPosToTop( parent.shape );
					if ( _vY < body.entity.transform.vY )
					{
						_vY = body.entity.transform.vY;
						/*for ( fct in parent.onCollideWall )
						{
							fct( body );
						}*/
					}
					//moveInDirection |= TOP;
				}
				else if ( reac == RIGHT )
				{
					//if ( BitUtils.has(reac, LEFT) ) { isCrush = true; return; }
					parent.entity.transform.x = shape.aabbXMin - ShapeUtils.getPosToRight( parent.shape );
					if ( _vX > body.entity.transform.vX )
					{
						_vX = body.entity.transform.vX;
						/*for ( fct in parent.onCollideWall )
						{
							fct( body );
						}*/
					}
					//moveInDirection |= RIGHT;
				}
				else if ( reac == LEFT )
				{
					//if ( BitUtils.has(reac, RIGHT) ) { isCrush = true; return; }
					parent.entity.transform.x = shape.aabbXMax - ShapeUtils.getPosToLeft( parent.shape );
					//moveInDirection |= LEFT;
					if ( _vX < body.entity.transform.vX )
					{
						_vX = body.entity.transform.vX;
						/*for ( fct in parent.onCollideWall )
						{
							fct( body );
						}*/
					}
				}
			}
			
		}
	}
	
	private function save( body:Body, reac:UInt ):Void
	{
		//trace( "save:"+reac );
		
		if 		( reac == BOTTOM ) 	{ bottom.push( body ); }
		else if ( reac == TOP ) 	{ top.push( body ); }
		else if ( reac == RIGHT ) 	{ right.push( body ); }
		else if ( reac == LEFT ) 	{ left.push( body ); }
		else						{ on.push( body ); }
	}
	
}