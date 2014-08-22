package dune.models.inputs;
import dune.entities.Entity;
import dune.helpers.core.ArrayUtils;
import dune.helpers.keyboard.KeyboardHandler;
import dune.system.input.components.CompInput;
import flash.ui.Keyboard;

/**
 * @author Namide
 */
class CompKeyboard extends CompInput
{

	public var keyLeft(default, default):UInt = Keyboard.LEFT;
	public var keyRight(default, default):UInt = Keyboard.RIGHT;
	public var keyTop(default, default):UInt = Keyboard.UP;
	public var keyBottom(default, default):UInt = Keyboard.DOWN;
	public var keyAction(default, default):UInt = Keyboard.SPACE;
	
	public var groundVX(default, default):Float = 5;
	
	public function new() 
	{
		super();
		
	}
	
	override function set_entity(value:Entity):Entity 
	{
		value.transform.vActive = true;
		return entity = value;
	}
	
	public override function execute( dt:UInt ):Void
	{
		var kh:KeyboardHandler = KeyboardHandler.getInstance();
		
		
		if ( kh.getKeyPressed( keyLeft ) ) 			{ entity.transform.vX = -groundVX; }
		else if ( kh.getKeyPressed( keyRight ) ) 	{ entity.transform.vX = groundVX; }
		else 										{ entity.transform.vX = 0; }
		
		/*if ( kh.getKeyPressed( keyTop ) ) 			{ onTop(entity); }
		else if ( kh.getKeyPressed( keyBottom ) ) 	{ onBottom(entity); }
		else 										{ offTop(entity); }*/
		
		
	}
	
	public override function clear():Void
	{
		
	}
	
}