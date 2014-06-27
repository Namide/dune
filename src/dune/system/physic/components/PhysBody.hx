package dune.system.physic.components;

import dune.compBasic.Component;
import dune.entities.Entity;
import dune.system.physic.shapes.PhysShapePoint;

/**
 * ...
 * @author Namide
 */
class PhysBody implements Component
{
	/**
	 * This body don't test the collision but the actives bodies tests the collision with this one
	 */
	public inline static var COLLISION_TYPE_PASSIVE:UInt = 1;
	
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
	 * Entity attached to the body
	 */
	public var entity(default, default):Entity;
	
	/**
	 * Delimit the shape of this body
	 */
	public var shape(default, default):PhysShapePoint;
	
	/**
	 * Other body in contact with this one
	 */
	public var contacts(default, null):Array<PhysBody>;
	
	public var typeOfCollision(default, null):UInt;
	
	public var typeOfSolid(default, default):UInt;
	
	public function new() 
	{
		
	}
	
	/* INTERFACE dune.compBasic.Component */
	
	public function clear() 
	{
		typeOfCollision = PhysBody.COLLISION_TYPE_PASSIVE;
	}
}