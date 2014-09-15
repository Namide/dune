package ;

import dune.Game;
import dune.helpers.keyboard.KeyboardHandler;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.Lib;

/**
 * ...
 * @author Namide
 */

class Main 
{
	static var game:Game;
	
	static function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		
		/*#if debugHitbox
			trace("hitbox");
		#else
			trace("no hitbox");
		#end*/
		
		//KeyboardHandler.getInstance().init( stage );
		game = new Game();
	}
	
}