package dune.system.scene;
import dune.entities.Entity;

/**
 * ...
 * @author Namide
 */
class SysScene
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
	
	public function getNear(  entity:Entity ):Array<Entity>
	{
		return new Array<Entity>();
	}
	
}