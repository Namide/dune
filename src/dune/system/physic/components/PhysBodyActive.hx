package dune.system.physic.components;

/**
 * ...
 * @author Namide
 */
class PhysBodyActive extends PhysBody
{
	/**
	 * This body test the collision with others bodies
	 */
	public inline static var COLLISION_TYPE_ACTIVE:UInt = 2;
	
	public function new() 
	{
		super();
	}
	
	/* INTERFACE dune.compBasic.Component */
	
	public override function clear() 
	{
		super.clear();
		typeOfCollision = PhysBodyActive.COLLISION_TYPE_ACTIVE;
	}
}