package dune.system;
import dune.entities.Entity;
import dune.system.graphic.SysGraphic;
import dune.system.input.SysInput;
import dune.system.physic.components.CompBody;
import dune.system.physic.SysPhysic;
import dune.system.System;
import flash.Lib;

/**
 * ...
 * @author Namide
 */
class SysManager implements System
{
	public static inline var FRAME_DELAY:UInt = 20;
	
	public var _entities:Array<Entity>;
	
	public var input(default, default):SysInput;
	public var physic(default, default):SysPhysic;
	public var graphic(default, default):SysGraphic;
	
	private var _time:UInt;
	
	public function new() 
	{
		_entities = [];
		
		input = new SysInput();
		graphic = new SysGraphic();
		physic = new SysPhysic();
		
		_time = Lib.getTimer();
	}
	
	public function addEntity( entity:Entity ):Void
	{
		_entities.push(entity);
		for ( i in entity.inputs ) { input.addInput( i ); }
		for ( b in entity.bodies ) { physic.space.addBody( b ); }
	}
	
	public function removeEntity( entity:Entity ):Void
	{
		_entities.remove(entity);
		for ( i in entity.inputs ) { input.removeInput( i ); }
		for ( b in entity.bodies ) { physic.space.removeBody( b ); }
	}
	
	/* INTERFACE dune.system.System */
	
	
	
	public function refresh(dt:Float):Void 
	{
		var realTime:UInt = Lib.getTimer();
		var rest:UInt = realTime - _time;
		
		if ( rest < FRAME_DELAY ) return;
		while ( rest+1 > FRAME_DELAY )
		{
			input.refresh( FRAME_DELAY );
			physic.refresh( FRAME_DELAY );
			rest -= FRAME_DELAY;
		}
		
		graphic.refresh( FRAME_DELAY );
		_time = realTime - rest;
	}
}