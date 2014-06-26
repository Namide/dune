package dune.system;
import dune.entities.Entity;
import dune.system.space.SysSpace;
import dune.system.System;

/**
 * ...
 * @author Namide
 */
class SysManager implements System
{

	public var space(default, default):SysSpace;
	
	public function new() 
	{
		//space = new SysSpace();
	}
	
	public function add( entity:Entity ):Entity
	{
		return entity;
	}
	
	public function remove( entity:Entity ):Entity
	{
		return entity;
	}
	
	public function getAll():Array<Entity>
	{
		return new Array<Entity>();
	}
	
	/* INTERFACE dune.system.System */
	
	public function refresh(dt:Float):Void 
	{
		
	}
}