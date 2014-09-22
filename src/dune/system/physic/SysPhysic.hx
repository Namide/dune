package dune.system.physic;

import dune.system.physic.components.CompBody;
import dune.system.core.SysSpaceGrid;

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
	public var space(default, null):SysSpaceGrid;
	
	#if (debugHitbox && (flash || openfl ))
		var _sceneHitBox:Sprite;
	#end
	
	public function new() 
	{
		space = new SysSpaceGrid();
		
		#if (debugHitbox && (flash || openfl ))
			_sceneHitBox = new Sprite();
			Lib.current.stage.addChild( _sceneHitBox );
		#end
	}
	
	public function refresh( dt:UInt/*, link:SysLink*/ ):Void 
	{
		//space.refreshGrid();
		var list:Iterable<CompBody> = space.hitTest();
		for ( b in list )
		{
			b.contacts.moveAndDispatch( /*link*/ );
		}
		
		#if (debugHitbox && (flash || openfl ))
		
			_sceneHitBox.graphics.clear();
			
			space.draw( _sceneHitBox );
			
			for ( compBody in space._active )
			{
				compBody.body.draw( _sceneHitBox );
			}
			
			for ( compBody in space._passive )
			{
				compBody.body.draw( _sceneHitBox );
			}
			
		#end
		
	}
}