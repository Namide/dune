package dune.system.physic.component;

/**
 * ...
 * @author namide.com
 */
class BodyType
{
	/**
	 * This body don't test the collision but the actives bodies tests the collision with this one
	 */
	public inline static var COLLISION_TYPE_PASSIVE:UInt = 1;
	
	/**
	 * This body test the collision with the passives bodies
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
	
	/**
	 * Your solid reacts with passives bodies (platform, wall, ladder)
	 */
	public inline static var SOLID_TYPE_MOVER:UInt = 16;
	
	/**
	 * Your solid reacts with passives bodies (item)
	 */
	public inline static var SOLID_TYPE_EATER:UInt = 32;
	
	/**
	 * Direction of the platform
	 */
	public inline static var PLATFORM_DIR_UP:UInt = 0;
	
	/**
	 * Direction of the platform
	 */
	public inline static var PLATFORM_DIR_DOWN:UInt = 1;
	
	/**
	 * Direction of the platform
	 */
	public inline static var PLATFORM_DIR_LEFT:UInt = 2;
	
	/**
	 * Direction of the platform
	 */
	public inline static var PLATFORM_DIR_RIGHT:UInt = 4;
	
	public function new() 
	{
		throw "You can't instancied a static class";
	}
	
}