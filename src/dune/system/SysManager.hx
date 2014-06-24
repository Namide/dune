package dune.system;
import dune.entities.Entity;
import dune.system.System;

/**
 * ...
 * @author Namide
 */
class SysManager implements System
{

	public function new() 
	{
		
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
	
}