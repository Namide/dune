package dune.system.physic;

import dune.helpers.core.TimeUtils;
import dune.system.core.SysSpace;
import dune.system.physic.components.CompBody;
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
	public var space(default, null):SysSpace;
	
	#if (debugHitbox && (flash || openfl ))
		var _sceneHitBox:Sprite;
	#end
	
	public function new() 
	{
		space = new dune.system.core.SysSpaceSimple();
		
		#if (debugHitbox && (flash || openfl ))
			_sceneHitBox = new Sprite();
			Lib.current.stage.addChild( _sceneHitBox );
		#end
	}
	
	public function refresh( dt:UInt/*, link:SysLink*/ ):Void 
	{
		//space.refreshGrid();
		var tTemp:UInt = TimeUtils.getMS();
		var list:Iterable<CompBody> = space.hitTest();
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