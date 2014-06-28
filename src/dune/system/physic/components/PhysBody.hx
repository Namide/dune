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
	
	public var typeOfCollision(default, default):UInt;
	
	public var typeOfSolid(default, default):UInt;
	
	/**
	 * Like a signal, add to this array the functions called at a collision
	 */
	public var onCollide(default, default):Array < PhysBody -> Void >;
	
	
	
	public function new() 
	{
		clear();
	}
	
	/* INTERFACE dune.compBasic.Component */
	
	public function clear() 
	{
		typeOfCollision = PhysBodyType.COLLISION_TYPE_PASSIVE;
		onCollide = [];
	}
}