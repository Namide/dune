package dune.system.physic.components;

import dune.compBasic.ComponentBasic;
import dune.entities.Entity;
import dune.system.physic.shapes.PhysShapePoint;

/**
 * ...
 * @author Namide
 */
class CompBody implements ComponentBasic
{
	/**
	 * Entity attached to the body
	 */
	public var entity(default, default):Entity;
	
	public var type(default, null):UInt;
	
	/**
	 * Delimit the shape of this body
	 */
	public var shape(default, default):PhysShapePoint;
	
	/**
	 * Other body in contact with this one
	 */
	public var contacts(default, null):Array<CompBody>;
	
	public var typeOfCollision(default, default):UInt;
	
	public var typeOfSolid(default, default):UInt;
	
	/**
	 * Like a signal, add to this array the functions called at a collision
	 */
	public var onCollide(default, default):Array < CompBody -> Void >;
	
	
	
	public function new() 
	{
		clear();
	}
	
	/* INTERFACE dune.compBasic.Component */
	
	public function clear() 
	{
		typeOfCollision = CompBodyType.COLLISION_TYPE_PASSIVE;
		typeOfSolid = 0;
		
		contacts = [];
		onCollide = [];
		entity = null;
		shape = null;
	}
}