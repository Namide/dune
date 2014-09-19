package dune.models.inputs;
import dune.entities.Entity;
import dune.helpers.core.ArrayUtils;
import dune.helpers.keyboard.KeyboardHandler;
import dune.system.input.components.CompInput;
import dune.system.physic.components.CompBody;
import dune.system.physic.components.CompBodyType;
import dune.system.physic.components.ContactBodies;
import dune.system.Settings;



#if flash

	import flash.ui.Keyboard;
	
#elseif js
	
#end

/**
 * @author Namide
 */
class IntputKeyboard extends CompInput
{

	public var keyLeft(default, default):UInt = Keyboard.LEFT;
	public var keyRight(default, default):UInt = Keyboard.RIGHT;
	public var keyTop(default, default):UInt = Keyboard.UP;
	public var keyBottom(default, default):UInt = Keyboard.DOWN;
	public var keyAction(default, default):UInt = Keyboard.SPACE;
	
	public var groundTimeAccX(default, default):UInt = 100;
	public var groundVX(default, default):Float = Settings.getVX( 10 );
	public var groundAccX(default, default):Float;
	public var runTime:UInt = 0;
	
	public var jumpVY(default, default):Float = Settings.getJumpVY( 2 );
	
	private var _contacts:ContactBodies;
	
	public function new() 
	{
		super();
		beforePhysic = false;
		groundAccX = Settings.getAccX( groundVX, groundTimeAccX );
	}
	
	override function set_entity(value:Entity):Entity 
	{
		value.transform.vActive = true;
		
		var body:CompBody = Lambda.find( value.bodies, function ( cb:CompBody ):Bool { return (cb.typeOfSolid & CompBodyType.SOLID_TYPE_MOVER == CompBodyType.SOLID_TYPE_MOVER); } );
		if ( body == null ) throw "An entity with input keyboard must have a solid type mover in physic body";
		_contacts = body.contacts;
		
		
		return entity = value;
	}
	
	public override function execute( dt:UInt ):Void
	{
		var kh:KeyboardHandler = KeyboardHandler.getInstance();
		
		if ( kh.getKeyPressed( keyLeft ) )
		{
			if ( !_contacts.hasTypeOfSolid( CompBodyType.SOLID_TYPE_WALL, ContactBodies.LEFT ) )
			{
				runTime += dt;
				if ( runTime < groundTimeAccX )
				{
					entity.transform.vX = -groundAccX * runTime;
				}
				else
				{
					entity.transform.vX = -groundVX;
				}
			}
			
		}
		else if ( kh.getKeyPressed( keyRight ) ) 
		{
			if ( !_contacts.hasTypeOfSolid( CompBodyType.SOLID_TYPE_WALL, ContactBodies.RIGHT ) )
			{
				runTime += dt;
				if ( runTime < groundTimeAccX )
				{
					entity.transform.vX = groundAccX * runTime;
				}
				else
				{
					entity.transform.vX = groundVX;
				}
			}
		}
		else
		{
			runTime = 0;
			entity.transform.vX = 0;
		}
		
		if ( 	kh.getKeyPressed( keyAction ) &&
				( 	_contacts.hasTypeOfSolid( CompBodyType.SOLID_TYPE_WALL, ContactBodies.BOTTOM ) ||
					_contacts.hasTypeOfSolid( CompBodyType.SOLID_TYPE_PLATFORM, ContactBodies.BOTTOM )
				)
			)
		{
			entity.transform.vY = -jumpVY;
		}
		
		
		/*if ( kh.getKeyPressed( keyTop ) ) 			{ onTop(entity); }
		else if ( kh.getKeyPressed( keyBottom ) ) 	{ onBottom(entity); }
		else 										{ offTop(entity); }*/
		
		
	}
	
	public override function clear():Void
	{
		
	}
	
}