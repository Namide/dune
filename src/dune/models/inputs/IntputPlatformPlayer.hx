package dune.models.inputs;
import dune.entities.Entity;
import dune.helpers.core.ArrayUtils;
import dune.helpers.core.TimeUtils;
import dune.helpers.keyboard.KeyboardHandler;
import dune.system.input.components.CompInput;
import dune.system.physic.components.CompBody;
import dune.system.physic.components.CompBodyType;
import dune.system.physic.components.ContactBodies;
import dune.system.Settings;



#if (flash || openfl)

	import flash.ui.Keyboard;

#end

/**
 * @author Namide
 */
class IntputPlatformPlayer extends CompInput
{

	#if (flash || openfl)
		public var keyLeft(default, default):UInt = Keyboard.LEFT;
		public var keyRight(default, default):UInt = Keyboard.RIGHT;
		public var keyTop(default, default):UInt = Keyboard.UP;
		public var keyBottom(default, default):UInt = Keyboard.DOWN;
		public var keyAction(default, default):UInt = Keyboard.SPACE;
	#else
		public var keyLeft(default, default):UInt = 37;
		public var keyRight(default, default):UInt = 39;
		public var keyTop(default, default):UInt = 38;
		public var keyBottom(default, default):UInt = 40;
		public var keyAction(default, default):UInt = 8;
	#end
	
	
	var _groundTimeAccX:UInt;  	// milliseconds
	var _groundVX:Float;		// tiles / sec
	var _groundAccX:Float;
	var _jumpStartVY:Float;
	var _jumpAccX:Float;
	var _jumpVY:Float;
	var _jumpVX:Float;
	var _jumpTimeLock:UInt;
	
	var _actionPressed:Bool = false;
	
	var _landmark:UInt = 0;
	var _contacts:ContactBodies;
	
	public function new() 
	{
		super();
		beforePhysic = false;
		
		setRun( 10, 0.06 );
		setJump( 1, 3, 4, 0.06, 0.2 );
	}
	
	/**
	 * 
	 * @param	vel			Velocity in tile by seconds
	 * @param	accTime		Time to accelerate in seconds
	 */
	public function setRun( vel:Float, accTime:Float ):Void
	{
		//_groundTimeAccX = Math.round(accTime * 1000);
		_groundAccX = Settings.getAccX( vel, Math.round(accTime * 1000) );
		_groundVX = Settings.getVX( vel );
	}
	
	/**
	 * 
	 * @param	hMin		Minimal height of the jump in tiles
	 * @param	hMax		Maximal height of the jump in tiles
	 * @param	lMax		Length of the jump in tiles
	 */
	public function setJump( hMin:Float, hMax:Float, lMax:Float, accTime:Float, timeLock:Float ):Void
	{
		_jumpStartVY = Settings.getJumpStartVY( hMin );
		_jumpVY = Settings.getJumpVY( hMax, _jumpStartVY );
		_jumpVX = Settings.getJumpVX( lMax, _jumpStartVY, _jumpVY );
		_jumpAccX = Settings.getAccX( _jumpVX, Math.round(accTime * 1000) );
		_jumpTimeLock = Math.round(timeLock * 1000);
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
		
		var bottomWall:Bool = 	_contacts.hasTypeOfSolid( CompBodyType.SOLID_TYPE_WALL, ContactBodies.BOTTOM ) || 
								_contacts.hasTypeOfSolid( CompBodyType.SOLID_TYPE_PLATFORM, ContactBodies.BOTTOM );
		
		var leftWall:Bool = 	_contacts.hasTypeOfSolid( CompBodyType.SOLID_TYPE_WALL, ContactBodies.LEFT );
		var rightWall:Bool = 	_contacts.hasTypeOfSolid( CompBodyType.SOLID_TYPE_WALL, ContactBodies.RIGHT );
		var topWall:Bool = 		_contacts.hasTypeOfSolid( CompBodyType.SOLID_TYPE_WALL, ContactBodies.TOP );
		
		
		if ( kh.getKeyPressed( keyLeft ) )
		{
			
			if ( !leftWall )
			{
				if ( bottomWall )
				{
					if ( entity.transform.vX > -_groundVX )
					{
						entity.transform.vX -= _groundAccX;
						if ( entity.transform.vX < -_groundVX ) entity.transform.vX = -_groundVX;
					}
				}
				else if ( TimeUtils.getMS() > _landmark )
				{
					if ( entity.transform.vX > -_jumpVX )
					{
						entity.transform.vX -= _jumpAccX;
						if ( entity.transform.vX < -_jumpVX ) entity.transform.vX = -_jumpVX;
					}
				}
				
			}
			
		}
		else if ( kh.getKeyPressed( keyRight ) ) 
		{
			if ( !rightWall )
			{
				if ( bottomWall  )
				{
					if ( entity.transform.vX < _groundVX )
					{
						entity.transform.vX += _groundAccX;
						if ( entity.transform.vX > _groundVX ) entity.transform.vX = _groundVX;
					}
				}
				else if ( TimeUtils.getMS() > _landmark )
				{
					if ( entity.transform.vX < _jumpVX )
					{
						entity.transform.vX += _jumpAccX;
						if ( entity.transform.vX > _jumpVX ) entity.transform.vX = _jumpVX;
					}
				}
			}
		}
		else
		{
			if ( bottomWall  ) entity.transform.vX = 0;
		}
		
		if ( kh.getKeyPressed( keyAction ) )
		{
			if ( bottomWall )
			{
				entity.transform.vY = - _jumpStartVY;
				if ( kh.getKeyPressed( keyLeft ) ) 			entity.transform.vX = -_jumpVX;
				else if ( kh.getKeyPressed( keyRight ) ) 	entity.transform.vX = _jumpVX;
				
				//_landmark = TimeUtils.getMS() + _jumpTimeLock;
			}
			else if ( leftWall && !_actionPressed )
			{
				entity.transform.vY = - _jumpStartVY;
				entity.transform.vX = _jumpVX;
				_landmark = TimeUtils.getMS() + _jumpTimeLock;
			}
			else if ( rightWall && !_actionPressed )
			{
				entity.transform.vY = - _jumpStartVY;
				entity.transform.vX = - _jumpVX;
				_landmark = TimeUtils.getMS() + _jumpTimeLock;
			}
			else if ( !topWall )
			{
				entity.transform.vY -= _jumpVY;
			}
			
			if ( !_actionPressed ) { _actionPressed = true; }
		}
		else if ( _actionPressed )
		{
			_actionPressed = false;
		}
		
		/*if ( kh.getKeyPressed( keyTop ) ) 			{ onTop(entity); }
		else if ( kh.getKeyPressed( keyBottom ) ) 	{ onBottom(entity); }
		else 										{ offTop(entity); }*/
		
		
	}
	
	public override function clear():Void
	{
		
	}
	
}