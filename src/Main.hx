package ;

import dune.Game;
import net.hires.debug.Stats;

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
	static var game:Game;
	
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
		
		var s:Stats = new Stats();
		s.x = 800 - 69;
		Lib.current.addChild( s );
		
		game = new Game();
	}
	
}