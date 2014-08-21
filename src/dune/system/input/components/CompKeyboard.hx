package dune.system.input.components;
import dune.entities.Entity;
import dune.helpers.keyboard.KeyboardHandler;
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
	
	public dynamic function onLeft(entity:Entity):Void { };
	public dynamic function onTop(entity:Entity):Void { };
	public dynamic function onRight(entity:Entity):Void { };
	public dynamic function onBottom(entity:Entity):Void { };
	public dynamic function onAction(entity:Entity):Void { };
	
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
		
		if ( kh.getKeyPressed( keyLeft ) ) 		{ onLeft(entity); }
		if ( kh.getKeyPressed( keyRight ) ) 	{ onRight(entity); }
		if ( kh.getKeyPressed( keyTop ) ) 		{ onTop(entity); }
		if ( kh.getKeyPressed( keyBottom ) ) 	{ onBottom(entity); }
		if ( kh.getKeyPressed( keyAction ) ) 	{ onAction(entity); }
	}
	
	public override function clear():Void
	{
		
	}
	
}