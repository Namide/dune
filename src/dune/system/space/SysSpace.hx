package dune.system.space;

import dune.system.physic.components.PhysBody;
import dune.system.physic.components.PhysBodyType;
import dune.system.physic.shapes.PhysShapeUtils;
import dune.system.System;

/**
 * ...
 * @author Namide
 */
class SysSpace implements System
{

	public var _active(default, null):Array<PhysBody>;
	public var _passive(default, null):Array<PhysBody>;
	
	private var _grid:Array<Array<Array<PhysBody>>>;
	
	public var _limitLeft(default, null):Int;
	public var _limitTop(default, null):Int;
	public var _limitRight(default, null):Int;
	public var _limitBottom(default, null):Int;
	
	public var _cellW(default, null):Int;
	public var _cellH(default, null):Int;
	
	private var _gridTilesW:UInt;
	private var _gridTilesH:UInt;
	
	public function new() 
	{
		
	}
	
	public function setSize( minX:Int, minY:Int, maxX:Int, maxY:Int, cellW:Int, cellH:Int ):Void
	{
		_limitLeft = minX;
		_limitTop = minY;
		_limitRight = maxX;
		_limitBottom = maxY;
		_cellW = cellW;
		_cellH = cellH;
		
		_gridTilesW = Math.floor( (_limitRight - _limitLeft) / _cellW );
		_gridTilesH = Math.floor( (_limitBottom - _limitTop) / _cellH );
	}
	
	
	/* INTERFACE dune.system.System */
	
	/**
	 * Update the grid
	 * 
	 * @param	dt
	 */
	public function refresh(dt:Float):Void 
	{
		clear( _grid );
		
		for ( physBody in _passive )
		{
			addBodyInGrid( physBody );
		}
	}
	
	private inline function addBodyInGrid( physBody:PhysBody ):Void
	{
		var pX:Float = physBody.shape.aabbXMin;
		var pY:Float = physBody.shape.aabbYMin;
		
		if ( 	pX < _limitLeft ||
				pX > _limitRight ||
				pY < _limitTop ||
				pY > _limitBottom	)
		{
			return;
		}

		var entityGridXMin:Int = Math.floor( (pX - _limitLeft) / _cellW );
		var entityGridXMax:Int = Math.floor( (physBody.shape.aabbXMax - _limitRight) / _cellW );
		var entityGridYMin:Int = Math.floor( (pY - _limitTop) / _cellH );
		var entityGridYMax:Int = Math.floor( (physBody.shape.aabbYMax - _limitTop) / _cellH );

		for ( cX in entityGridXMin...entityGridXMax )
		{
			for ( cY in entityGridYMin...entityGridYMax )
			{
				if ( _grid[cX] == null ) { _grid[cX] = []; }
				if ( _grid[cX][cY] == null ) { _grid[cX][cY] = []; }
				
				_grid[cX][cY].push( physBody );
			}
		}
	}
	
	public function hitTest( dispatch:Bool = false ):Array<PhysBody>
	{
		var affected:Array<PhysBody> = [];
		
		/*_gridTilesW = Math.floor( (_limitRight - _limitLeft) / _cellW );
		_gridTilesH = Math.floor( (_limitBottom - _limitTop) / _cellH );*/
		
		for ( physBody in _active )
		{
			var isAffected:Bool = false;
			var pX:Float = physBody.shape.aabbXMin;
			var pY:Float = physBody.shape.aabbYMin;
			
			if ( 	pX < _limitLeft ||
					pX > _limitRight ||
					pY < _limitTop ||
					pY > _limitBottom	)
			{
				continue;
			}

			var entityGridXMin:Int = Math.floor( (pX - _limitLeft) / _cellW );
			var entityGridXMax:Int = Math.floor( (physBody.shape.aabbXMax - _limitRight) / _cellW );
			var entityGridYMin:Int = Math.floor( (pY - _limitTop) / _cellH );
			var entityGridYMax:Int = Math.floor( (physBody.shape.aabbYMax - _limitTop) / _cellH );
	
			clear( physBody.contacts );
			
			for ( cX in entityGridXMin...entityGridXMax )
			{
				for ( cY in entityGridYMin...entityGridYMax )
				{
					for ( physBodyPassive in _grid[cX][cY] )
					{
						if ( 	physBody.contacts.indexOf( physBodyPassive ) < 0 &&
								PhysShapeUtils.hitTest( physBody.shape, physBodyPassive.shape ) )
						{
							physBody.contacts.push( physBodyPassive );
							if ( !isAffected )
							{
								isAffected = true;
								affected.push( physBody );
							}
						}
					}
				}
			}
		}
		
		if ( dispatch )
		{
			for ( physBody in affected )
			{
				for ( physBodyPassive in physBody.contacts )
				{
					for ( fct in physBody.onCollide )
					{
						fct.bind( physBodyPassive );
					}
				}
			}
		}
		
		return affected;
	}
	
	public function addBody( body:PhysBody, addNowInGrid:Bool = true ):Void
	{
		if ( body.typeOfCollision == PhysBodyType.COLLISION_TYPE_PASSIVE )
		{
			_passive.push( body );
			if ( addNowInGrid ) { addBodyInGrid( body ); };
		}
		else
		{
			_active.push( body );
		}
	}
	
	public function removeBody( body:PhysBody, rebuildGrid:Bool = false ):Void
	{
		if ( body.typeOfCollision == PhysBodyType.COLLISION_TYPE_PASSIVE )
		{
			_passive.remove( body );
			if ( rebuildGrid ) { refresh( 0 ); }
		}
		else
		{
			_active.remove( body );
		}
	}
	
	private inline function clear( arr:Array<Dynamic> ):Void
	{
        #if (cpp||php)
           arr.splice(0,arr.length);          
        #else
           untyped arr.length = 0;
        #end
    }
}