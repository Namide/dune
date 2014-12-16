package ;

import dune.Game;
import dune.GameLevel;


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
			var stage = flash.Lib.current.stage;
			stage.scaleMode = flash.display.StageScaleMode.NO_SCALE;
			stage.align = flash.display.StageAlign.TOP_LEFT;
		#end
		
		/*#if debugHitbox
			trace("hitbox");
		#else
			trace("no hitbox");
		#end*/
		
		#if flash
			var s = new net.hires.debug.Stats();
			s.x = 800 - 69;
			flash.Lib.current.addChild( s );
		#end
		
		game = new GameLevel();
	}
	
}