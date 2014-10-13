package dune.model.controller ;
import dune.component.IDisplay;
import dune.entity.Entity;
import dune.helper.core.ArrayUtils;
//import dune.helper.core.DTime;
import dune.component.Controller;
import dune.input.core.IInput;
import dune.input.GamepadJsHandler;
import dune.input.KeyboardHandler;
import dune.input.MultiInput;
import dune.system.physic.component.Body;
import dune.system.physic.component.BodyType;
import dune.system.physic.component.ContactBodies;
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
	//var _groundAccX:Float;
	var _jumpStartVY:Float;
	//var _jumpAccX:Float;
	var _jumpVY:Float;
	var _jumpVXMin:Float;
	var _jumpVXMax:Float;
	var _jumpTimeLock:UInt;
	
	var _actionPressed:Bool = false;
	
	var _landmark:UInt = 0;
	var _contacts:ContactBodies;
	
	var _display:IDisplay;
	var _input:IInput;
	
	var _t:UInt;
	
	public function new() 
	{
		super();
		beforePhysic = false;
		
		/*setRun( 14, 0.06 );
		setJump( 1.5, 3, 6, 0.06, 0.2 );*/
		setRun( 12, 0.06 );
		setJump( 1.5, 3, 3, 6, 0.06, 0.3 );
		
		_input = new MultiInput( new KeyboardHandler(), new GamepadJsHandler() );
	}
	
	/**
	 * 
	 * @param	vel			Velocity in tile by seconds
	 * @param	accTime		Time to accelerate in seconds
	 */
	public function setRun( vel:Float, accTime:Float ):Void
	{
		//_groundAccX = ControllerPlatformPlayer.getAccX( vel, Math.round(accTime * 1000) );
		_groundVX = ControllerPlatformPlayer.getVX( vel );
	}
	
	/**
	 * 
	 * @param	hMin		Minimal height of the jump in tiles
	 * @param	hMax		Maximal height of the jump in tiles
	 * @param	lMax		Length of the jump in tiles
	 */
	public function setJump( hMin:Float, hMax:Float, lMin:Float, lMax:Float, accTime:Float, timeLock:Float ):Void
	{
		_jumpStartVY = ControllerPlatformPlayer.getJumpStartVY( hMin );
		_jumpVY = ControllerPlatformPlayer.getJumpVY( hMax, _jumpStartVY );
		_jumpVXMin = ControllerPlatformPlayer.getJumpVX( lMin, _jumpStartVY, _jumpVY );
		_jumpVXMax = ControllerPlatformPlayer.getJumpVX( lMax, _jumpStartVY, _jumpVY );
		//_jumpAccX = ControllerPlatformPlayer.getAccX( _jumpVXMax, Math.round(accTime * 1000) );
		_jumpTimeLock = Math.round(timeLock * 1000);
	}
	
	override function set_entity(value:Entity):Entity 
	{
		value.transform.vActive = true;
		
		var body:Body = Lambda.find( value.bodies, function ( cb:Body ):Bool { return (cb.typeOfSolid & BodyType.SOLID_TYPE_MOVER == BodyType.SOLID_TYPE_MOVER); } );
		if ( body == null ) throw "An entity with input keyboard must have a solid type mover in physic body";
		_contacts = body.contacts;
		
		if ( !Std.is( value.display, IDisplay) ) throw "An entity with ControllerPlatformPlayer must have a display:Display";
		_display = value.display;
		
		return entity = value;
	}
	
	public override function execute( dt:UInt ):Void
	{
		_t += dt;
		var bottomWall:Bool = 	_contacts.hasTypeOfSolid( BodyType.SOLID_TYPE_WALL, ContactBodies.BOTTOM ) || 
								_contacts.hasTypeOfSolid( BodyType.SOLID_TYPE_PLATFORM, ContactBodies.BOTTOM );
		
		var leftWall:Bool = 	_contacts.hasTypeOfSolid( BodyType.SOLID_TYPE_WALL, ContactBodies.LEFT );
		var rightWall:Bool = 	_contacts.hasTypeOfSolid( BodyType.SOLID_TYPE_WALL, ContactBodies.RIGHT );
		var topWall:Bool = 		_contacts.hasTypeOfSolid( BodyType.SOLID_TYPE_WALL, ContactBodies.TOP );
		
		var xAxis:Float = _input.getAxisX();
		
		entity.transform.vY += Settings.GRAVITY;
		
		var platformVX:Float = 0;
		if ( bottomWall )
		{
			var platformVY:Float = 0;
			for ( body in _contacts.getByType( BodyType.SOLID_TYPE_WALL , ContactBodies.BOTTOM ) )
			{
				platformVX += body.entity.transform.vX;
				platformVY += body.entity.transform.vY;
			}
			for ( body in _contacts.getByType( BodyType.SOLID_TYPE_PLATFORM , ContactBodies.BOTTOM ) )
			{
				platformVX += body.entity.transform.vX;
				platformVY += body.entity.transform.vY;
			}
			entity.transform.vY = platformVY;
		}
		if ( leftWall )
		{
			for ( body in _contacts.getByType( BodyType.SOLID_TYPE_WALL , ContactBodies.LEFT ) )
			{
				if ( platformVX < body.entity.transform.vX )
				{
					platformVX = body.entity.transform.vX;
				}
			}
		}
		if ( rightWall )
		{
			for ( body in _contacts.getByType( BodyType.SOLID_TYPE_WALL , ContactBodies.RIGHT ) )
			{
				if ( platformVX > body.entity.transform.vX )
				{
					platformVX = body.entity.transform.vX;
				}
			}
		}
		if ( topWall )
		{
			for ( body in _contacts.getByType( BodyType.SOLID_TYPE_WALL , ContactBodies.TOP ) )
			{
				if ( entity.transform.vY < body.entity.transform.vY )
				{
					entity.transform.vY = body.entity.transform.vY;
				}
			}
		}
		
		if ( xAxis != 0 )
		{
			if ( xAxis < 0 && !leftWall )
			{
				if ( bottomWall )
				{
					if ( entity.transform.vX > platformVX-_groundVX )
					{
						entity.transform.vX = platformVX + xAxis * _groundVX;
						/*entity.transform.vX -= _groundAccX;
						if ( entity.transform.vX < platformVX - _groundVX )
						{
							entity.transform.vX = platformVX-_groundVX;
						}*/
					}
				}
				else if ( entity.transform.vX > -_jumpVXMax && /*DTime.getRealMS()*/_t > _landmark )
				{
					entity.transform.vX = xAxis * _jumpVXMax;
					/*entity.transform.vX -= _jumpAccX;
					if ( entity.transform.vX < -_jumpVXMax )
					{
						entity.transform.vX = -_jumpVXMax;
					}*/
				}
				/*else
				{
					entity.transform.vX = xAxis * _jumpVXMax;
				}*/
				/*else if ( TimeUtils.getMS() > _landmark )
				{
					if ( entity.transform.vX > -_jumpVXMax )
					{
						entity.transform.vX -= _jumpAccX;
						if ( entity.transform.vX < -_jumpVXMax )
						{
							entity.transform.vX = -_jumpVXMax;
						}
					}
				}*/
			}
			else
			{
				if ( !rightWall )
				{
					if ( bottomWall  )
					{
						if ( entity.transform.vX < platformVX + _groundVX )
						{
							entity.transform.vX = platformVX + xAxis * _groundVX;
							/*entity.transform.vX += _groundAccX;
							if ( entity.transform.vX > platformVX + _groundVX )
							{
								entity.transform.vX = platformVX+_groundVX;
							}*/
						}
					}
					else if ( entity.transform.vX < _jumpVXMax && /*DTime.getRealMS()*/_t > _landmark )
					{
						entity.transform.vX = xAxis * _jumpVXMax;
						/*entity.transform.vX += _jumpAccX;
						if ( entity.transform.vX > _jumpVXMax )
						{
							entity.transform.vX = _jumpVXMax;
						}*/
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
			else if ( !topWall && !leftWall && !rightWall )
			{
				if ( entity.transform.vX > _jumpVXMin ) entity.transform.vX = _jumpVXMin;
				if ( entity.transform.vX < -_jumpVXMin ) entity.transform.vX = -_jumpVXMin;
			}
		}
		
		var b1:Float = _input.getB1();
		if ( b1 > 0 )//kh.getKeyPressed( keyAction ) )
		{
			if ( bottomWall && !_actionPressed )
			{
				entity.transform.vY = - _jumpStartVY;
				if ( xAxis < 0 ) 		entity.transform.vX = -_jumpVXMax;
				else if ( xAxis > 0 ) 	entity.transform.vX = _jumpVXMax;
			}
			else if ( leftWall && !_actionPressed )
			{
				entity.transform.vY = - _jumpStartVY;
				entity.transform.vX = _jumpVXMax;
				_landmark = /*DTime.getRealMS()*/_t + _jumpTimeLock;
			}
			else if ( rightWall && !_actionPressed )
			{
				entity.transform.vY = - _jumpStartVY;
				entity.transform.vX = - _jumpVXMax;
				_landmark = /*DTime.getRealMS()*/_t + _jumpTimeLock;
			}
			else if ( 	(!topWall && !bottomWall && !leftWall && !rightWall) ||
						(!topWall && !bottomWall && _actionPressed ) )
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
		
		
		// 		ANIMATIONS
		
		if ( entity.transform.vX < platformVX )			_display.setToRight( false );
		else if ( entity.transform.vX > platformVX ) 	_display.setToRight( true );
		
		if ( bottomWall )
		{
			if ( entity.transform.vX == platformVX ) 	_display.play( "stand" );
			else										_display.play( "run" );
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
		return ControllerPlatformPlayer.maxTilesXJump( maxTilesXJump, _jumpStartVY, _jumpVXMax, _jumpVY, gravity );
	}
	
	public inline function getMaxTilesYJump( maxTilesYJump:Float, gravity:Float = Settings.GRAVITY ):Float
	{
		return ControllerPlatformPlayer.maxTilesYJump( maxTilesYJump, _jumpStartVY, _jumpVXMax, _jumpVY, gravity );
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
	
	/*public inline static function getAccX( distTile:Float, timeMS:UInt ):Float
	{
		var a:Float = distTile * Settings.TILE_SIZE / ( 1000 * timeMS / Settings.FRAME_DELAY );
		return a * Settings.FRAME_DELAY;
	}*/
	
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