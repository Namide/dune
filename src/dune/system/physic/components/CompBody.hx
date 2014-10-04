package dune.system.physic.components;

import dune.compBasic.Component;
import dune.entities.Entity;
import dune.helpers.core.ArrayUtils;
import dune.system.physic.shapes.ShapeCircle;
import dune.system.physic.shapes.ShapePoint;
import dune.system.physic.shapes.ShapeType;

#if (debugHitbox && (flash || openfl))
	import flash.display.Sprite;
#end

/**
 * ...
 * @author Namide
 */
class CompBody implements Component
{
	/**
	 * Entity attached to the body
	 */
	public var entity(default, default):Entity;
	
	public var type(default, null):UInt;
	
	/**
	 * Delimit the shape of this body
	 */
	public var shape(default, default):ShapePoint;
	
	/**
	 * Other body in contact with this one
	 */
	public var contacts(default, null):ContactBodies;
	
	public var typeOfCollision(default, default):UInt;
	
	public var typeOfSolid(default, default):UInt;
	
	public var insomniac(default, default):Bool = false;
	
	/*public var sleep(default, set):Bool = false;
	//Used in the system physic, don't change it
	public dynamic function onSleep( body:CompBody ):Void {  }
	function set_sleep( val:Bool ):Bool
	{
		sleep = val;
		onSleep( this );
		return val;
	}*/
	
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
	
	#if (debugHitbox && (flash || openfl ))
	
		public function draw(scene:Sprite):Void
		{
			scene.graphics.lineStyle( 1, (typeOfSolid == CompBodyType.COLLISION_TYPE_ACTIVE) ? 0xFF0000 : 0x0000FF );
			
			if ( shape.type == ShapeType.POINT )
			{
				scene.graphics.moveTo( shape.aabbXMin - 5, shape.aabbYMin - 5 );
				scene.graphics.lineTo( shape.aabbXMax + 5, shape.aabbYMax + 5 );
				scene.graphics.endFill();
				
				scene.graphics.moveTo( shape.aabbXMax + 5, shape.aabbYMin - 5 );
				scene.graphics.lineTo( shape.aabbXMin + 5, shape.aabbYMax + 5 );
				scene.graphics.endFill();
			}
			else if ( shape.type == ShapeType.RECT )
			{
				scene.graphics.drawRect( 	shape.aabbXMin,
											shape.aabbYMin,
											shape.aabbXMax - shape.aabbXMin,
											shape.aabbYMax - shape.aabbYMin );
			}
			else if ( shape.type == ShapeType.CIRCLE )
			{
				scene.graphics.drawCircle( 	(shape.aabbXMax - shape.aabbXMin) * 0.5 + shape.aabbXMin,
											(shape.aabbYMax - shape.aabbYMin) * 0.5 + shape.aabbYMin,
											cast( shape, ShapeCircle ).r );
			}
			
			
		}
		
	#end
}