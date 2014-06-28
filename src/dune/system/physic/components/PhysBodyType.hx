package dune.system.physic.components;

/**
 * ...
 * @author namide.com
 */
class PhysBodyType
{
	/**
	 * This body don't test the collision but the actives bodies tests the collision with this one
	 */
	public inline static var COLLISION_TYPE_PASSIVE:UInt = 1;
	
	/**
	 * This body test the collision with others bodies
	 */
	public inline static var COLLISION_TYPE_ACTIVE:UInt = 2;
	
	/**
	 * You can jump from bottom over a platform
	 */
	public inline static var SOLID_TYPE_PLATFORM:UInt = 1;
	
	/**
	 * You can't cross it
	 */
	public inline static var SOLID_TYPE_WALL:UInt = 2;
	
	/**
	 * You can climb it
	 */
	public inline static var SOLID_TYPE_LADDER:UInt = 4;
	
	/**
	 * Collision is activated, but not physic.
	 * It's usable for life, ennemy, ammo...
	 */
	public inline static var SOLID_TYPE_ITEM: UInt = 8;
	
	public function new() 
	{
		throw "You can't instancied a static class"
	}
	
}