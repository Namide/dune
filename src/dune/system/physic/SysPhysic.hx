package dune.system.physic;

import dune.system.core.SysLink;
import dune.system.physic.components.CompBody;
import dune.system.core.SysSpaceSimple;

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
	public var space(default, null):SysSpaceSimple;
	
	#if (debugHitbox && (flash || openfl ))
		var _sceneHitBox:Sprite;
	#end
	
	public function new() 
	{
		space = new SysSpaceSimple();
		
		#if (debugHitbox && (flash || openfl ))
			_sceneHitBox = new Sprite();
			Lib.current.stage.addChild( _sceneHitBox );
		#end
	}
	
	public function refresh( dt:UInt, link:SysLink ):Void 
	{
		//space.refreshGrid();
		var list:Iterable<CompBody> = space.hitTest();
		for ( b in list )
		{
			b.contacts.moveAndDispatch( link );
		}
		
		#if (debugHitbox && (flash || openfl ))
		
			_sceneHitBox.graphics.clear();
			
			for ( compBody in space._active )
			{
				compBody.draw( _sceneHitBox );
			}
			
			for ( compBody in space._passive )
			{
				compBody.draw( _sceneHitBox );
			}
			
		#end
		
	}
}