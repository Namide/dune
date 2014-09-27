package dune.system;
import dune.entities.Entity;
import dune.helpers.core.ArrayUtils;
import dune.helpers.core.TimeUtils;
import dune.system.graphic.SysGraphic;
import dune.system.controller.SysController;
import dune.system.physic.SysPhysic;


/**
 * ...
 * @author Namide
 */
class SysManager
{
	
	public var _entities:Array<Entity>;
	public var _entitiesVelocity:Array<Entity>;
	public var _entitiesMoved:Array<Entity>;
	
	public var sysController(default, default):SysController;
	public var sysPhysic(default, default):SysPhysic;
	public var sysGraphic(default, default):SysGraphic;
	//public var sysLink(default, default):SysLink;
	
	var _time:UInt;
	
	public function new() 
	{
		_entities = [];
		_entitiesVelocity = [];
		_entitiesMoved = [];
		
		sysController = new SysController();
		sysGraphic = new SysGraphic();
		sysPhysic = new SysPhysic();
		//sysLink = new SysLink();
		
		 //Lib.getTimer();
	}
	
	public function start():Void
	{
		_time = TimeUtils.getMS();
		hxd.System.setLoop( refresh );
	}
	
	public function addEntity( entity:Entity ):Void
	{
		_entities.push( entity );
		if ( entity.transform.vActive ) { _entitiesVelocity.push( entity ); }
		
		for ( i in entity.controllers ) { sysController.addController( i ); }
		for ( b in entity.bodies ) { sysPhysic.space.addBody( b ); }
		sysGraphic.add( entity );
		
		entity.transform.onMoved = function()
		{
			if ( !Lambda.has( _entitiesMoved, entity ) ) _entitiesMoved.push( entity );
		};
	}
	
	public function removeEntity( entity:Entity ):Void
	{
		_entities.remove( entity );
		if ( _entitiesVelocity.indexOf( entity ) > -1 ) { _entitiesVelocity.remove( entity ); }
		
		for ( i in entity.controllers ) { sysController.removeController( i ); }
		for ( b in entity.bodies ) { sysPhysic.space.removeBody( b ); }
		sysGraphic.remove( entity );
		
		entity.transform.onMoved = function() { };
		_entitiesMoved.remove(entity);
	}
	
	function refresh():Void 
	{
		var realTime:UInt = TimeUtils.getMS();
		var rest:UInt = realTime - _time;
		
		if ( rest < Settings.FRAME_DELAY )
		{
			_time = realTime - rest;
			return;
		}
		
		while ( rest >= Settings.FRAME_DELAY )
		{
			sysPhysic.refresh( Settings.FRAME_DELAY/*, sysLink*/ );
			
			if ( rest < Settings.FRAME_DELAY + Settings.FRAME_DELAY )
			{
				sysGraphic.refresh( _entitiesMoved );
				_entitiesMoved = [];
			}
			
			sysController.refresh( Settings.FRAME_DELAY, true );
			sysController.refresh( Settings.FRAME_DELAY, false );
			
			for ( e in _entitiesVelocity )
			{
				e.transform.x += e.transform.vX;
				e.transform.y += e.transform.vY;
			}
			
			sysPhysic.space.testSleeping();
			
			rest -= Settings.FRAME_DELAY;
		}
		
		_time = realTime - rest;
	}
}