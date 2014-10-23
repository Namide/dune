package dune.system.physic;

import dune.helper.core.DTime;
import dune.system.core.ISpace;
import dune.system.core.SpaceGrid;
import dune.system.physic.component.Body;
import dune.system.SysManager;
//import dune.system.core.SysSpaceGrid;


/**
 * ...
 * @author Namide
 */
class SysPhysic
{
	/**
	 * Scene of the bodies
	 */
	public var space(default, null):ISpace;
	
	public function new( sm:SysManager ) 
	{
		space = new dune.system.core.SpaceGrid( sm );
	}
	
	public function refresh( /*time:DTime,*/ dt:UInt/*, link:SysLink*/ ):Void 
	{
		//space.refreshGrid();
		//var tTemp:UInt = time.tMs;// DTime.getRealMS();
		var list:Iterable<Body> = space.hitTest();
		//trace( TimeUtils.getMS() - tTemp );
		
		for ( b in list )
		{
			b.contacts.moveAndDispatch();
		}
		
		
		
	}
}