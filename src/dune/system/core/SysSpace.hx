package dune.system.core;

import dune.system.physic.components.CompBody;
import flash.display.Sprite;

/**
 * @author Namide
 */

interface SysSpace 
{
	public function hitTest():List<CompBody>;
	public function testSleeping():Void;
	
	public var all(default, null):List<CompBody>;
	
	public function removeBody( body:CompBody ):Void;
	public function addBody( body:CompBody ):Void;
	
	#if (debugHitbox && (flash || openfl ))
		public function draw( sceneHitBox:flash.display.Sprite ):Void;
	#end
}