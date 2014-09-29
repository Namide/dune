package dune.system.core ;

import dune.helpers.core.ArrayUtils;
import dune.system.physic.components.CompBody;
import dune.system.physic.components.CompBodyType;
import dune.system.physic.shapes.PhysShapeUtils;

/**
 * ...
 * @author Namide
 */
class SysSpaceSimple implements SysSpace
{

	public var _active(default, null):List<CompBody>;
	public var _passive(default, null):List<CompBody>;
	
	public function new() 
	{
		_active = new List<CompBody>();
		_passive = new List<CompBody>();
	}
	
	public inline function testSleeping():Void { }
	
	public function hitTest():List<CompBody>
	{
		
		var affected:List<CompBody> = new List<CompBody>();
		
		var first:Bool = true;
		for ( physBody in _active )
		{
			var isAffected:Bool = false;
			physBody.contacts.clear();
			physBody.shape.updateAABB( physBody.entity.transform );
			
			for ( physBodyPassive in _passive )
			{
				if ( first ) physBodyPassive.shape.updateAABB( physBodyPassive.entity.transform );
				
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
			
			if ( first ) first = false;
		}
		
		return affected;
	}
	
	/**
	 * Add a body in this system
	 * 
	 * @param	body			Body to add in the system
	 */
	public function addBody( body:CompBody ):Void
	{
		if ( body.typeOfCollision == CompBodyType.COLLISION_TYPE_PASSIVE )
		{
			_passive.push( body );
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
	public function removeBody( body:CompBody ):Void
	{
		if ( body.typeOfCollision == CompBodyType.COLLISION_TYPE_PASSIVE )
		{
			_passive.remove( body );
		}
		else
		{
			_active.remove( body );
		}
	}
}