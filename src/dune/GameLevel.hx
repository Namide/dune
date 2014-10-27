package dune ;
import dune.model.factory.LevelFactory;
import dune.system.SysManager;
import flash.Lib;

/**
 * ...
 * @author Namide
 */
class GameLevel
{
	public var sm:SysManager;
	
	public function new() 
	{
		sm = new SysManager( run );
	}
	
	public function run()
	{
		
		var levelGen = new LevelFactory( sm );
		levelGen.construct( cast( flash.Lib.attach("Level1MC"), MovieClipData ) );
		sm.start();
		
	}
	
}