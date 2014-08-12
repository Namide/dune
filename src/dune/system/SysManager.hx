package dune.system;
import dune.entities.Entity;
import dune.system.graphic.SysGraphic;
import dune.system.input.SysInput;
import dune.system.physic.SysPhysic;
import flash.Lib;

/**
 * ...
 * @author Namide
 */
class SysManager
{
	public static inline var FRAME_DELAY:UInt = 20;
	
	public var _entities:Array<Entity>;
	public var _entitiesMoved:Array<Entity>;
	
	public var sysInput(default, default):SysInput;
	public var sysPhysic(default, default):SysPhysic;
	public var sysGraphic(default, default):SysGraphic;
	
	var _time:UInt;
	
	public function new() 
	{
		_entities = [];
		_entitiesMoved = [];
		
		sysInput = new SysInput();
		sysGraphic = new SysGraphic();
		sysPhysic = new SysPhysic();
		
		_time = Lib.getTimer();
	}
	
	public function addEntity( entity:Entity ):Void
	{
		_entities.push(entity);
		for ( i in entity.inputs ) { sysInput.addInput( i ); }
		for ( b in entity.bodies ) { sysPhysic.space.addBody( b ); }
		sysGraphic.add( entity );
		
		entity.transform.onMoved = function()
		{
			_entitiesMoved.push( entity );
		};
	}
	
	public function removeEntity( entity:Entity ):Void
	{
		_entities.remove(entity);
		for ( i in entity.inputs ) { sysInput.removeInput( i ); }
		for ( b in entity.bodies ) { sysPhysic.space.removeBody( b ); }
		sysGraphic.remove( entity );
		
		entity.transform.onMoved = function() { };
		_entitiesMoved.remove(entity);
	}
	
	public function refresh(dt:Float):Void 
	{
		var realTime:UInt = Lib.getTimer();
		var rest:UInt = realTime - _time;
		
		if ( rest < FRAME_DELAY )
		{
			_time = realTime - rest;
			return;
		}
		
		while ( rest+1 > FRAME_DELAY )
		{
			sysInput.refresh( FRAME_DELAY );
			sysPhysic.refresh( FRAME_DELAY );
			rest -= FRAME_DELAY;
		}
		
		sysGraphic.refresh( _entitiesMoved );
		_entitiesMoved = [];
		_time = realTime - rest;
	}
}