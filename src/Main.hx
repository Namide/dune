package ;

import dune.Game;
import dune.GameLevel;

#if (flash || openfl)

	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.Lib;

#elseif cpp

	import cpp.Lib;

#elseif js

	import js.Lib;
	
#end
//

/**
 * ...
 * @author Namide
 */

class Main 
{
	static var game:GameLevel;
	
	static function main() 
	{
		#if (flash || openfl)
			var stage = Lib.current.stage;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		#end
		
		/*#if debugHitbox
			trace("hitbox");
		#else
			trace("no hitbox");
		#end*/
		
		#if flash
			var s = new net.hires.debug.Stats();
			s.x = 800 - 69;
			Lib.current.addChild( s );
		#end
		
		game = new GameLevel();
	}
	
}