package dune.system.physic;

import dune.helper.core.TimeUtils;
import dune.system.core.ISpace;
import dune.system.core.SpaceGrid;
import dune.system.physic.components.Body;
//import dune.system.core.SysSpaceGrid;

#if (debugHitbox && (flash || openfl))
	import flash.display.Sprite;
	import flash.Lib;
#end

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
	
	#if (debugHitbox && (flash || openfl ))
		var _sceneHitBox:Sprite;
	#end
	
	public function new() 
	{
		space = new dune.system.core.SpaceGrid();
		
		#if (debugHitbox && (flash || openfl ))
			_sceneHitBox = new Sprite();
			Lib.current.stage.addChild( _sceneHitBox );
		#end
	}
	
	public function refresh( dt:UInt/*, link:SysLink*/ ):Void 
	{
		//space.refreshGrid();
		var tTemp:UInt = TimeUtils.getMS();
		var list:Iterable<Body> = space.hitTest();
		//trace( TimeUtils.getMS() - tTemp );
		
		for ( b in list )
		{
			b.contacts.moveAndDispatch();
		}
		
		#if (debugHitbox && (flash || openfl ))
		
			_sceneHitBox.graphics.clear();
			
			space.draw( _sceneHitBox );
			
			for ( compBody in space.all )
			{
				compBody.draw( _sceneHitBox );
			}
			
		#end
		
	}
}