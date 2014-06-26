package dune.system.space;

import dune.system.physic.components.PhysBody;
import dune.system.physic.components.PhysBodyActive;
import dune.system.physic.shapes.PhysShapeUtils;
import dune.system.System;

/**
 * ...
 * @author Namide
 */
class SysSpace implements System
{

	public var _active(default, null):Array<PhysBodyActive>;
	public var _passive(default, null):Array<PhysBody>;
	
	private var _grid:Array<Array<Array<PhysBody>>>;
	
	public var _limitLeft(default, default):Int;
	public var _limitTop(default, default):Int;
	public var _limitRight(default, default):Int;
	public var _limitBottom(default, default):Int;
	
	public var _cellW(default, default):Int;
	public var _cellH(default, default):Int;
	
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
	}
	
	
	/* INTERFACE dune.system.System */
	
	/**
	 * Update the grid
	 * 
	 * @param	dt
	 */
	public function refresh(dt:Float):Void 
	{
		var cGridWidth:Int = Math.floor( (_limitRight - _limitLeft) / _cellW );
		var cGridHeight:Int = Math.floor( (_limitBottom - _limitTop) / _cellH );
		
		_grid = [ 
					for (i in 0...cGridWidth)
					[
						for (j in 0...cGridHeight)
							[]
					]
				];
		
		for ( physBody in _passive )
		{
			var pX:Float = physBody.shape.aabbXMin;
			var pY:Float = physBody.shape.aabbYMin;
			
			if ( 	pX < _limitLeft ||
					pX > _limitRight ||
					pY < _limitTop ||
					pY > _limitBottom	)
			{
				continue;
			}

			cXEntityMin = Math.floor( (pX - _limitLeft) / _cellW );
			cXEntityMax = Math.floor( (physBody.shape.aabbXMax - _limitRight) / _cellW );
			cYEntityMin = Math.floor( (pY - _limitTop) / _cellH );
			cYEntityMax = Math.floor( (physBody.shape.aabbYMax - _limitTop) / _cellH );

			for ( cX in cXEntityMin...cXEntityMax )
			{
				for ( cY in cYEntityMin...cYEntityMax )
				{
					_grid[cX][cY].push( physBody );
				}
			}
		}
	}
	//public function update()
	
	public function hitTest( dispatch:Bool = false ):Array<PhysBody>
	{
		var affected:Array<PhysBody> = [];
		
		var cGridWidth:Int = Math.floor( (_limitRight - _limitLeft) / _cellW );
		var cGridHeight:Int = Math.floor( (_limitBottom - _limitTop) / _cellH );
		
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

			cXEntityMin = Math.floor( (pX - _limitLeft) / _cellW );
			cXEntityMax = Math.floor( (physBody.shape.aabbXMax - _limitRight) / _cellW );
			cYEntityMin = Math.floor( (pY - _limitTop) / _cellH );
			cYEntityMax = Math.floor( (physBody.shape.aabbYMax - _limitTop) / _cellH );

			physBody.contacts = [];
			
			for ( cX in cXEntityMin...cXEntityMax )
			{
				for ( cY in cYEntityMin...cYEntityMax )
				{
					for ( physBodyPassive in _grid[cX][cY] )
					{
						//var bodyTemp:PhysBody = _grid[cX][cY];
						if ( physBody.contacts.indexOf( physBodyPassive ) < 0 )
						{
							if ( PhysShapeUtils.hitTest( physBody.shape, physBodyPassive.shape ) )
							{
								physBody.contacts.push( physBodyPassive );
								if ( !isAffected )
								{
									isAffected = true;
									affected.push(physBody);
								}
							}
						}
					}
					//_grid[cX][cY].push( physBody );
				}
			}
		}
		
		if ( dispatch )
		{
			for ( physBody in affected )
			{
				for ( physBodyPassive in physBody.contacts )
				{
					for ( callback in physicBody.onCollide )
					{
						callback( physBodyPassive );
					}
				}
			}
		}
		
		return affected;
	}
	
	public function addBody( body:PhysBody ):Void
	{
		
	}
	public function addBodies( body:Array<PhysBody> ):Void
	{
		
	}
	public function removeBody( body:PhysBody ):Void
	{
		
	}
	public function removeBodies( bodies:Array<PhysBody> ):Void
	{
		
	}
	
	
}