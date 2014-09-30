package dune.models.controller ;
import dune.compBasic.Display;
import dune.entities.Entity;
import dune.helpers.core.ArrayUtils;
import dune.helpers.core.TimeUtils;
import dune.helpers.keyboard.KeyboardHandler;
import dune.compBasic.Controller;
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
class ControllerPlatformPlayer extends Controller
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
	
	var _display:Display;
	
	public function new() 
	{
		super();
		beforePhysic = false;
		
		setRun( 14, 0.06 );
		setJump( 1.5, 3, 6, 0.06, 0.2 );
		
		trace( getMaxTilesXJump( 1.5 ) );
		trace( getMaxTilesXJump( 2 ) );
	}
	
	/**
	 * 
	 * @param	vel			Velocity in tile by seconds
	 * @param	accTime		Time to accelerate in seconds
	 */
	public function setRun( vel:Float, accTime:Float ):Void
	{
		//_groundTimeAccX = Math.round(accTime * 1000);
		_groundAccX = ControllerPlatformPlayer.getAccX( vel, Math.round(accTime * 1000) );
		_groundVX = ControllerPlatformPlayer.getVX( vel );
	}
	
	/**
	 * 
	 * @param	hMin		Minimal height of the jump in tiles
	 * @param	hMax		Maximal height of the jump in tiles
	 * @param	lMax		Length of the jump in tiles
	 */
	public function setJump( hMin:Float, hMax:Float, lMax:Float, accTime:Float, timeLock:Float ):Void
	{
		_jumpStartVY = ControllerPlatformPlayer.getJumpStartVY( hMin );
		_jumpVY = ControllerPlatformPlayer.getJumpVY( hMax, _jumpStartVY );
		_jumpVX = ControllerPlatformPlayer.getJumpVX( lMax, _jumpStartVY, _jumpVY );
		_jumpAccX = ControllerPlatformPlayer.getAccX( _jumpVX, Math.round(accTime * 1000) );
		_jumpTimeLock = Math.round(timeLock * 1000);
	}
	
	override function set_entity(value:Entity):Entity 
	{
		value.transform.vActive = true;
		
		var body:CompBody = Lambda.find( value.bodies, function ( cb:CompBody ):Bool { return (cb.typeOfSolid & CompBodyType.SOLID_TYPE_MOVER == CompBodyType.SOLID_TYPE_MOVER); } );
		if ( body == null ) throw "An entity with input keyboard must have a solid type mover in physic body";
		_contacts = body.contacts;
		
		if ( !Std.is( value.display, Display) ) throw "An entity with ControllerPlatformPlayer must have a display:Display";
		_display = value.display;
		
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
		
		//trace( _contacts.mainCollide );
		//trace( bottomWall, leftWall, rightWall, topWall );
		
		entity.transform.vY += Settings.GRAVITY;
		
		trace(leftWall);
		trace( "1. vX:" + entity.transform.vX );
		
		var platformVX:Float = 0;
		if ( bottomWall )
		{
			var platformVY:Float = 0;
			for ( body in _contacts.getByType( CompBodyType.SOLID_TYPE_WALL , ContactBodies.BOTTOM ) )
			{
				platformVX += body.entity.transform.vX;
				platformVY += body.entity.transform.vY;
			}
			for ( body in _contacts.getByType( CompBodyType.SOLID_TYPE_PLATFORM , ContactBodies.BOTTOM ) )
			{
				platformVX += body.entity.transform.vX;
				platformVY += body.entity.transform.vY;
			}
			entity.transform.vY = platformVY;
		}
		if ( leftWall )
		{
			for ( body in _contacts.getByType( CompBodyType.SOLID_TYPE_WALL , ContactBodies.LEFT ) )
			{
				if ( platformVX < body.entity.transform.vX )
				{
					platformVX = body.entity.transform.vX;
				}
			}
		}
		if ( rightWall )
		{
			for ( body in _contacts.getByType( CompBodyType.SOLID_TYPE_WALL , ContactBodies.RIGHT ) )
			{
				if ( platformVX > body.entity.transform.vX )
				{
					platformVX = body.entity.transform.vX;
				}
			}
		}
		if ( topWall )
		{
			for ( body in _contacts.getByType( CompBodyType.SOLID_TYPE_WALL , ContactBodies.TOP ) )
			{
				if ( entity.transform.vY < body.entity.transform.vY )
				{
					entity.transform.vY = body.entity.transform.vY;
				}
			}
		}
		
		trace( "2. vX:" + entity.transform.vX );
		
		if ( kh.getKeyPressed( keyLeft ) )
		{
			if ( !leftWall )
			{
				if ( bottomWall )
				{
					if ( entity.transform.vX > platformVX-_groundVX )
					{
						entity.transform.vX -= _groundAccX;
						if ( entity.transform.vX < platformVX - _groundVX )
						{
							entity.transform.vX = platformVX-_groundVX;
						}
					}
				}
				else if ( TimeUtils.getMS() > _landmark )
				{
					if ( entity.transform.vX > -_jumpVX )
					{
						entity.transform.vX -= _jumpAccX;
						if ( entity.transform.vX < -_jumpVX )
						{
							entity.transform.vX = -_jumpVX;
						}
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
					if ( entity.transform.vX < platformVX+_groundVX )
					{
						entity.transform.vX += _groundAccX;
						if ( entity.transform.vX > platformVX + _groundVX )
						{
							entity.transform.vX = platformVX+_groundVX;
						}
					}
				}
				else if ( TimeUtils.getMS() > _landmark )
				{
					if ( entity.transform.vX < _jumpVX )
					{
						entity.transform.vX += _jumpAccX;
						if ( entity.transform.vX > _jumpVX )
						{
							entity.transform.vX = _jumpVX;
						}
					}
				}
			}
		}
		else
		{
			if ( bottomWall  )
			{
				entity.transform.vX = platformVX;
			}
		}
		
		trace( "4. vX:" + entity.transform.vX );
		
		if ( kh.getKeyPressed( keyAction ) )
		{
			if ( bottomWall )
			{
				entity.transform.vY = - _jumpStartVY;
				if ( kh.getKeyPressed( keyLeft ) ) 			entity.transform.vX = -_jumpVX;
				else if ( kh.getKeyPressed( keyRight ) ) 	entity.transform.vX = _jumpVX;
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
			
			
			if ( !_actionPressed )
			{
				_actionPressed = true;
			}
		}
		else if ( _actionPressed )
		{
			_actionPressed = false;
		}
		
		trace( "4. vX:" + entity.transform.vX );
		
		// 		ANIMATIONS
		
		if ( entity.transform.vX < 0 )		_display.setToRight( false );
		else if ( entity.transform.vX > 0 ) _display.setToRight( true );
		
		if ( bottomWall )
		{
			if ( entity.transform.vX == 0 ) _display.play( "stand" );
			else							_display.play( "run" );
		}
		else if ( leftWall || rightWall )
		{
			_display.play( "wall" );
		}
		else
		{
			_display.play( "jump" );
		}
	}
	
	
	
	public inline function getMaxTilesXJump( maxTilesXJump:Float, gravity:Float = Settings.GRAVITY ):Float
	{
		return ControllerPlatformPlayer.maxTilesXJump( maxTilesXJump, _jumpStartVY, _jumpVX, _jumpVY, gravity );
	}
	
	public inline function getMaxTilesYJump( maxTilesYJump:Float, gravity:Float = Settings.GRAVITY ):Float
	{
		return ControllerPlatformPlayer.maxTilesYJump( maxTilesYJump, _jumpStartVY, _jumpVX, _jumpVY, gravity );
	}
	
	
	
	public override function clear():Void
	{
		
	}
	
	// STATICS CALCULATIONS
	
	public inline static function getVX( tilesBySec:Float ):Float
	{
		var f:Float = 1000 / Settings.FRAME_DELAY;
		var p:Float = tilesBySec * Settings.TILE_SIZE;
		return p / f;
	}
	
	public inline static function getAccX( distTile:Float, timeMS:UInt ):Float
	{
		var a:Float = distTile * Settings.TILE_SIZE / ( 1000 * timeMS / Settings.FRAME_DELAY );
		return a * Settings.FRAME_DELAY;
	}
	
	/**
	 * 
	 * @param	jumpTiles		To jump 4 tiles use 4
	 * @param	gravity			In pixels added by frames
	 * @return
	 */
	public inline static function getJumpStartVY( jumpTiles:Float, gravity:Float = Settings.GRAVITY ):Float
	{
		return Math.sqrt( 2 * gravity * jumpTiles * Settings.TILE_SIZE );
	}
	
	public inline static function getJumpVY( maxTilesJump:Float, jumpStartVY:Float, gravity:Float = Settings.GRAVITY ):Float
	{
		return - (jumpStartVY * jumpStartVY / (2 * maxTilesJump * Settings.TILE_SIZE) - gravity );
	}
	
	public inline static function getJumpVX( maxTilesJump:Float, jumpStartVY:Float, jumpVY:Float = 0, gravity:Float = Settings.GRAVITY ):Float
	{
		//var frames:Float = 2 * jumpStartVY / ( gravity - jumpVY );
		return maxTilesJump * Settings.TILE_SIZE * ( gravity - jumpVY ) / ( 2 * jumpStartVY );
	}
	
	static function maxTilesYJump( maxTilesXJump:Float, jumpStartVY:Float, jumpVX:Float, jumpVY:Float, gravity:Float = Settings.GRAVITY ):Float
	{
		maxTilesXJump *= Settings.TILE_SIZE;
		var vY:Float = jumpStartVY;
		var vX:Float = jumpVX;
		var h:Float = 0;
		var w:Float = 0;
		while ( h >= 0 )
		{
			h += vY;
			w += jumpVX;
			if ( w > maxTilesXJump ) return h / Settings.TILE_SIZE;
			vY += jumpVY - gravity;
		}
		return -1;
	}
	
	static function maxTilesXJump( maxTilesYJump:Float, jumpStartVY:Float, jumpVX:Float, jumpVY:Float, gravity:Float = Settings.GRAVITY ):Float
	{
		maxTilesYJump *= Settings.TILE_SIZE;
		var vY:Float = jumpStartVY;
		var vX:Float = jumpVX;
		var h:Float = 0;
		var w:Float = 0;
		while ( vY > 0 )
		{
			h += vY;
			w += jumpVX;
			if ( h > maxTilesYJump ) return w / Settings.TILE_SIZE;
			vY += jumpVY - gravity;
		}
		return -1;
	}
	
}