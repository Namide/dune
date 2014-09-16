package dune.system.physic;

import dune.system.core.SysLink;
import dune.system.physic.components.CompBody;
import dune.system.core.SysSpace;

#if debugHitbox
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
	
	#if debugHitbox
		var _sceneHitBox:Sprite;
	#end
	
	public function new() 
	{
		space = new SysSpace();
		
		#if debugHitbox
			_sceneHitBox = new Sprite();
			Lib.current.stage.addChild( _sceneHitBox );
		#end
	}
	
	public function refresh( dt:UInt, link:SysLink ):Void 
	{
		space.refreshGrid();
		var list:Array<CompBody> = space.hitTest();
		for ( b in list )
		{
			b.contacts.moveAndDispatch( link );
		}
		
		#if debugHitbox
		
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