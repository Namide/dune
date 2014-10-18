package dune.system;
import dune.entity.Entity;
import dune.helper.core.ArrayUtils;
import dune.helper.core.DTime;
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
	
	public var time:DTime;
	
	#if (debugHitbox && (flash || openfl ))
		var _sceneHitBox:flash.display.Sprite;
	#end
	
	public function new( onInitCallback:Void->Void ) 
	{
		_entities = [];
		_entitiesVelocity = [];
		_entitiesMoved = [];
		
		sysController = new SysController();
		sysGraphic = new SysGraphic( onInitCallback );
		sysPhysic = new SysPhysic();
		//sysGraphic.onInit = onInitCallback;
		//sysLink = new SysLink();
		
		//Lib.getTimer();
		
		#if (debugHitbox && (flash || openfl ))
			_sceneHitBox = new flash.display.Sprite();
			flash.Lib.current.stage.addChild( _sceneHitBox );
		#end
		
	}
	
	public function start():Void
	{
		time = new DTime();
		//_time = DTime.getRealMS();
		hxd.System.setLoop( refresh );
	}
	
	public inline function draw()
	{
		//trace( _entities.length );
		//sysGraphic.refresh( _entities );
		if ( time == null )
		{
			start();
			time.pause = true;
		}
		time.frameRest += 2;
		refresh();
	}
	
	public function addEntity( entity:Entity ):Void
	{
		removeEntity( entity );
		
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
		if ( !Lambda.has( _entities, entity ) ) return;
		
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
		time.update();
		
		//var realTime:UInt = time.tMs;
		//var rest:UInt = realTime - _time;
		
		if ( time.frameRest < 1/*rest < Settings.FRAME_DELAY*/ )
		{
			return;
			//_time = realTime - rest;
			
		}
		
		while ( time.frameRest >= 1 /*rest >= Settings.FRAME_DELAY*/ )
		{
			sysPhysic.refresh( Settings.FRAME_DELAY );
			
			//if ( rest < Settings.FRAME_DELAY + Settings.FRAME_DELAY )
			if ( time.frameRest < 2 )
			{
				//trace(_entitiesMoved.length);
				sysGraphic.refresh( _entitiesMoved );
				_entitiesMoved = [];
				
				
				#if (debugHitbox && (flash || openfl ))
					_sceneHitBox.graphics.clear();
					_sceneHitBox.x = sysGraphic.camera2d.x;
					_sceneHitBox.y = sysGraphic.camera2d.y;
					
					sysPhysic.space.draw( _sceneHitBox );
					for ( compBody in sysPhysic.space.all )
					{
						compBody.draw( _sceneHitBox );
					}
				#end
			}
			
			sysController.refresh( Settings.FRAME_DELAY, true );
			sysController.refresh( Settings.FRAME_DELAY, false );
			
			for ( e in _entitiesVelocity )
			{
				e.transform.x += e.transform.vX;
				e.transform.y += e.transform.vY;
			}
			
			sysPhysic.space.testSleeping();
			
			time.frameRest -= 1;
			//rest -= Settings.FRAME_DELAY;
		}
		
		//_time = realTime - rest;
	}
}