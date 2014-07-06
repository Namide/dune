package dune;

import dune.entities.Entity;
import dune.system.physic.components.CompTransformPhysic;
import dune.system.SysManager;

/**
 * ...
 * @author Namide
 */
class Game
{
	public var systemManager:SysManager;
	
	public function new() 
	{
		systemManager = new SysManager();
		
		var e1:Entity = new Entity();
		e1.transform = new CompTransformPhysic();
	}
}