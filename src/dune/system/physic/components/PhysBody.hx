package dune.system.physic.components;

import dune.compBasic.Component;
import dune.entities.Entity;
import dune.system.physic.shapes.PhysShape;

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
	public var entity(get, set):Entity;
	inline function get_entity():Entity { return _entity; }
	inline function set_entity(value:Entity):Entity { return _entity = value; }
	
	/**
	 * Delimit the shape of this body
	 */
	public var shape(get, set):PhysShape;
	inline function get_shape():PhysShape { return _shape; }
	inline function set_shape(value:PhysShape):PhysShape { return _shape = value; }
	
	/**
	 * Other body in contact with this one
	 */
	public var contacts(get, set):Array<PhysBody>;
	inline function get_contacts():Array<PhysBody> { return _contacts; }
	inline function set_contacts(value:Array<PhysBody>):Array<PhysBody> { return _contacts = value; }
	
	public var typeOfCollision(get, null):UInt;
	inline function get_typeOfCollision():UInt { return typeOfCollision; }
	inline function set_typeOfCollision(value:UInt):UInt { return typeOfCollision = value; }
	
	public var typeOfSolid(get, set):UInt;
	inline function get_typeOfSolid():UInt { return typeOfSolid; }
	inline function set_typeOfSolid(value:UInt):UInt { return typeOfSolid = value; }
	
	public function new() 
	{
		
	}
	
	/* INTERFACE dune.compBasic.Component */
	
	public override function clear() 
	{
		super.clear();
		typeCollision = PhysBody.COLLISION_TYPE_PASSIVE;
	}
}