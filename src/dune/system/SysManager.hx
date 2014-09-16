package dune.system;
import dune.entities.Entity;
import dune.helpers.core.ArrayUtils;
import dune.system.core.SysLink;
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
	public var _entitiesVelocity:Array<Entity>;
	public var _entitiesMoved:Array<Entity>;
	
	public var sysInput(default, default):SysInput;
	public var sysPhysic(default, default):SysPhysic;
	public var sysGraphic(default, default):SysGraphic;
	public var sysLink(default, default):SysLink;
	
	var _time:UInt;
	
	public function new() 
	{
		_entities = [];
		_entitiesVelocity = [];
		_entitiesMoved = [];
		
		sysInput = new SysInput();
		sysGraphic = new SysGraphic();
		sysPhysic = new SysPhysic();
		sysLink = new SysLink();
		
		_time = Lib.getTimer();
	}
	
	public function addEntity( entity:Entity ):Void
	{
		_entities.push( entity );
		if ( entity.transform.vActive ) { _entitiesVelocity.push( entity ); }
		
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
		_entities.remove( entity );
		if ( _entitiesVelocity.indexOf( entity ) > -1 ) { _entitiesVelocity.remove( entity ); }
		
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
		
		while ( rest >= FRAME_DELAY )
		{
			sysInput.refresh( FRAME_DELAY, true );
			sysPhysic.refresh( FRAME_DELAY, sysLink );
			
			if ( rest < FRAME_DELAY + FRAME_DELAY )
			{
				sysGraphic.refresh( _entitiesMoved );
				_entitiesMoved = [];
			}
			
			sysInput.refresh( FRAME_DELAY, false );
			sysLink.executeAndClean();
			
			for ( e in _entitiesVelocity )
			{
				e.transform.x += e.transform.vX;
				e.transform.y += e.transform.vY;
			}
			
			rest -= FRAME_DELAY;
		}
		
		_time = realTime - rest;
	}
}