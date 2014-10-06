package dune.helper.sound ;

import flash.errors.Error;

/**
 * @author Namide
 */
class SoundManager
{
	private static var _CAN_INSTANTIATE:Bool = false;
	private static var _INSTANCE:SoundManager;
	
	public var sampleMutted(get, set):Bool = false;
	public var musicMutted(get, set):Bool = false;
	
	private var _musicListNames:Array<String>;
	private var _musicListSimpleSound:Array<SimpleSound>;
	
	private var _sampleListNames:Array<String>;
	private var _sampleListSimpleSound:Array<SimpleSound>;
	
	public function new() 
	{
		if (_CAN_INSTANTIATE = false) throw new Error( "You can't instancies a singleton, you must use the static method getInstance()" );
		
		_sampleListNames = [];
		_sampleListSimpleSound = [];
		
		_musicListNames = [];
		_musicListSimpleSound = [];
	}
	
	/**
	 * 
	 * @param	name		Name of the sound (to play it after)
	 * @param	src			source of the sound
	 * @param	sample		Can be sample or music
	 */
	public function addSound( name:String, src:String, sample:Bool = true ):Void
	{
		if ( sample )
		{
			_sampleListNames.push( name );
			_sampleListSimpleSound( new SimpleSound( src ) );
		}
		else
		{
			_musicListNames.push( name );
			_musicListSimpleSound( new SimpleSound( src ) );
		}
	}
	
	public function play( name:String ):Void
	{
		var i:Int = Lambda.indexOf( _sampleListNames, name );
		if ( i > -1 )
		{
			if ( !_soundsMutted ) 
			{
				_sampleListSimpleSound[i].play();
			}
		}
		else if ( !_musicMutted && i > -1 ) 
		{
			i = Lambda.indexOf( _musicListNames, name );
			_musicListSimpleSound[i].play();
		}
	}
	
	public static function getInstance():SoundManager
	{
        if (_INSTANCE == null)
		{
            _CAN_INSTANTIATE = true;
            _INSTANCE = new SoundManager();
            _CAN_INSTANTIATE = false;
        }
        return _INSTANCE;
    }
	
	function get_sampleMutted():Bool 
	{
		return sampleMutted;
	}
	
	function set_sampleMutted(val:Bool):Bool 
	{
		sampleMutted = val;
		if ( sampleMutted )
		{
			for ( ss in _sampleListSimpleSound )
			{
				ss.volume = 0;
			}
		}
		else
		{
			for ( ss in _sampleListSimpleSound )
			{
				ss.volume = 1;
			}
		}
		return sampleMutted;
	}
	
	function get_musicMutted():Bool 
	{
		return musicMutted;
	}
	
	function set_musicMutted(val:Bool):Bool 
	{
		musicMutted = val;
		if ( musicMutted )
		{
			for ( ss in _musicListSimpleSound )
			{
				ss.volume = 0;
			}
		}
		else
		{
			for ( ss in _musicListSimpleSound )
			{
				ss.volume = 1;
			}
		}
		return musicMutted;
	}
}