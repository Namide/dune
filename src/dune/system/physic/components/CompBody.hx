package dune.system.physic.components;

import dune.compBasic.ComponentBasic;
import dune.entities.Entity;
import dune.helpers.core.ArrayUtils;
import dune.system.physic.shapes.PhysShapeCircle;
import dune.system.physic.shapes.PhysShapePoint;
import dune.system.physic.shapes.PhysShapeType;

#if (debugHitbox && flash)
	import flash.display.Sprite;
#end

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
	public var contacts(default, null):ContactBodies;
	
	public var typeOfCollision(default, default):UInt;
	
	public var typeOfSolid(default, default):UInt;
	
	/**
	 * Like a signal, add to this array the functions called at a collision
	 */
	public var onCollide(default, default):Array < CompBody -> Void >;
	
	
	
	public function new() 
	{
		contacts = new ContactBodies( this );
		onCollide = [];
		clear();
	}
	
	public function clear() 
	{
		typeOfCollision = CompBodyType.COLLISION_TYPE_PASSIVE;
		typeOfSolid = 0;
		
		contacts.clear();
		ArrayUtils.clear( onCollide );
		entity = null;
		shape = null;
	}
	
	#if debugHitbox
	
		public function draw(scene:Sprite):Void
		{
			scene.graphics.lineStyle( 1, (typeOfSolid == CompBodyType.COLLISION_TYPE_ACTIVE) ? 0xFF0000 : 0x0000FF );
			
			if ( shape.type == PhysShapeType.POINT )
			{
				scene.graphics.moveTo( shape.aabbXMin - 5, shape.aabbYMin - 5 );
				scene.graphics.lineTo( shape.aabbXMax + 5, shape.aabbYMax + 5 );
				scene.graphics.endFill();
				
				scene.graphics.moveTo( shape.aabbXMax + 5, shape.aabbYMin - 5 );
				scene.graphics.lineTo( shape.aabbXMin + 5, shape.aabbYMax + 5 );
				scene.graphics.endFill();
			}
			else if ( shape.type == PhysShapeType.RECT )
			{
				scene.graphics.drawRect( 	shape.aabbXMin,
											shape.aabbYMin,
											shape.aabbXMax - shape.aabbXMin,
											shape.aabbYMax - shape.aabbYMin );
			}
			else if ( shape.type == PhysShapeType.CIRCLE )
			{
				scene.graphics.drawCircle( 	(shape.aabbXMax - shape.aabbXMin) * 0.5 + shape.aabbXMin,
											(shape.aabbYMax - shape.aabbYMin) * 0.5 + shape.aabbYMin,
											cast( shape, PhysShapeCircle ).r );
			}
			
			
		}
		
	#end
}