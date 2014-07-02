package dune.system;
import dune.entities.Entity;
import dune.system.graphic.SysGraphic;
import dune.system.physic.SysPhysic;
import dune.system.space.SysSpace;
import dune.system.System;

/**
 * ...
 * @author Namide
 */
class SysManager implements System
{

	public var space(default, default):SysSpace;
	public var physic(default, default):SysPhysic;
	public var graphic(default, default):SysGraphic;
	
	public function new() 
	{
		space = new SysSpace();
		graphic = new SysGraphic();
		physic = new SysPhysic();
	}
	
	/* INTERFACE dune.system.System */
	
	public function refresh(dt:Float):Void 
	{
		
	}
}