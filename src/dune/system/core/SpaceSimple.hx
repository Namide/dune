package dune.system.core ;

import dune.helper.core.ArrayUtils;
import dune.system.physic.components.Body;
import dune.system.physic.components.BodyType;
import dune.system.physic.shapes.ShapeUtils;

/**
 * ...
 * @author Namide
 */
class SpaceSimple implements ISpace
{
	public var all(default, null):List<Body>;
	
	var _active(default, null):List<Body>;
	var _passive(default, null):List<Body>;
	
	public function new() 
	{
		_active = new List<Body>();
		_passive = new List<Body>();
		all = new List<Body>();
	}
	
	public inline function testSleeping():Void { }
	
	public function hitTest():List<Body>
	{
		
		var affected:List<Body> = new List<Body>();
		
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
						ShapeUtils.hitTest( physBody.shape, physBodyPassive.shape ) )
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
	public function addBody( body:Body ):Void
	{
		if ( body.typeOfCollision == BodyType.COLLISION_TYPE_PASSIVE )
		{
			_passive.push( body );
		}
		else
		{
			_active.push( body );
		}
		all.push( body );
	}
	
	/**
	 * Remove the body of the system
	 * 
	 * @param	body			Body to add
	 * @param	rebuildGrid		Clear the grid and buid it
	 */
	public function removeBody( body:Body ):Void
	{
		if ( body.typeOfCollision == BodyType.COLLISION_TYPE_PASSIVE )
		{
			_passive.remove( body );
		}
		else
		{
			_active.remove( body );
		}
		all.remove( body );
	}
	
	#if (debugHitbox && (flash || openfl ))
		public inline function draw(scene:flash.display.Sprite):Void { }
	#end
}