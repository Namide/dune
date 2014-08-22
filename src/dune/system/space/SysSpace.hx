package dune.system.space;

import dune.helpers.core.ArrayUtils;
import dune.system.physic.components.CompBody;
import dune.system.physic.components.CompBodyType;
import dune.system.physic.shapes.PhysShapeUtils;

/**
 * ...
 * @author Namide
 */
class SysSpace
{

	public var _active(default, null):Array<CompBody>;
	public var _passive(default, null):Array<CompBody>;
	
	private var _grid:Array<Array<Array<CompBody>>>;
	
	public var _limitLeft(default, null):Int = 0;
	public var _limitTop(default, null):Int = 0;
	public var _limitRight(default, null):Int = 1024;
	public var _limitBottom(default, null):Int = 1024;
	
	public var _cellW(default, null):Int = 64;
	public var _cellH(default, null):Int = 64;
	
	private var _gridTilesW:UInt;
	private var _gridTilesH:UInt;
	
	public function new() 
	{
		_active = [];
		_passive = [];
		_grid = [];
	}
	
	/**
	 * Change the size of the grid.
	 * The better tile size is the same that all the objects sizes.
	 * 
	 * @param	minX		Left position of the scene
	 * @param	minY		Top position of the scene
	 * @param	maxX		Right position of the scene
	 * @param	maxY		Bottom position of the scene
	 * @param	cellW		With of the tile
	 * @param	cellH		Height of the tile
	 */
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
	
	/**
	 * Refresh the grid and add all the passives bodies in it.
	 */
	public function refreshGrid():Void 
	{
		ArrayUtils.clear( _grid );
		
		for ( physBody in _passive )
		{
			addBodyInGrid( physBody );
		}
	}
	
	private function addBodyInGrid( physBody:CompBody ):Void
	{
		physBody.shape.updateAABB( physBody.entity.transform );
		
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
		var entityGridXMax:Int = Math.floor( (physBody.shape.aabbXMax - _limitLeft) / _cellW );
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
	
	/**
	 * Hit test for all entities and fill contacts in physic body
	 * 
	 * @return					Entities collides
	 */
	public function hitTest( /*dispatch:Bool = false*/ ):Array<CompBody>
	{
		var affected:Array<CompBody> = [];
		
		for ( physBody in _active )
		{
			physBody.shape.updateAABB( physBody.entity.transform );
		}
		
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
			var entityGridXMax:Int = Math.ceil( (physBody.shape.aabbXMax - _limitLeft) / _cellW );
			var entityGridYMin:Int = Math.floor( (pY - _limitTop) / _cellH );
			var entityGridYMax:Int = Math.ceil( (physBody.shape.aabbYMax - _limitTop) / _cellH );
			
			physBody.contacts.clear();
			for ( cX in entityGridXMin...entityGridXMax )
			{
				for ( cY in entityGridYMin...entityGridYMax )
				{
					if ( 	cX < _grid.length &&
							_grid[cX] != null &&
							cY < _grid[cX].length &&
							_grid[cX][cY] != null )
					{
						for ( physBodyPassive in _grid[cX][cY] )
						{
							if ( 	physBody.contacts.all.indexOf( physBodyPassive ) < 0 &&
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
		}
		
		/*if ( dispatch )
		{
			for ( physBody in affected )
			{
				for ( fct in physBody.onCollide )
				{
					fct( physBody.contacts );
				}
			}
		}*/
		
		return affected;
	}
	
	/**
	 * Add a body in this system
	 * 
	 * @param	body			Body to add in the system
	 * @param	addNowInGrid	Add the body in the grid (you must add only for the first adding)
	 */
	public function addBody( body:CompBody, addNowInGrid:Bool = true ):Void
	{
		if ( body.typeOfCollision == CompBodyType.COLLISION_TYPE_PASSIVE )
		{
			_passive.push( body );
			if ( addNowInGrid ) { addBodyInGrid( body ); };
		}
		else
		{
			_active.push( body );
		}
	}
	
	/**
	 * Remove the body of the system
	 * 
	 * @param	body			Body to add
	 * @param	rebuildGrid		Clear the grid and buid it
	 */
	public function removeBody( body:CompBody, rebuildGrid:Bool = false ):Void
	{
		if ( body.typeOfCollision == CompBodyType.COLLISION_TYPE_PASSIVE )
		{
			_passive.remove( body );
			if ( rebuildGrid ) { refreshGrid(); }
		}
		else
		{
			_active.remove( body );
		}
	}
	
	/*private inline function clear( arr:Array<Dynamic> ):Void
	{
        #if (cpp||php)
           arr.splice(0,arr.length);          
        #else
           untyped arr.length = 0;
        #end
    }*/
}