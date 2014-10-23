package dune.system.core;

import dune.system.graphic.SysGraphic;
import dune.system.physic.component.Body;
import flash.display.Sprite;

/**
 * @author Namide
 */

interface ISpace 
{
	public function hitTest():List<Body>;
	public function testSleeping():Void;
	
	public var all(default, null):List<Body>;
	
	public function removeBody( body:Body ):Void;
	public function addBody( body:Body ):Void;
	
	public function init( 	?minX:Int = null,
							?minY:Int = null,
							?maxX:Int = null,
							?maxY:Int = null,
							?pitchX:Int = null,
							?pitchY:Int = null ):Void;
	
	#if (debugHitbox && (flash || openfl ))
		public function draw( sceneHitBox:flash.display.Sprite ):Void;
	#end
}