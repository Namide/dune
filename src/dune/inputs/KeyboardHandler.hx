package dune.inputs;

import dune.helpers.core.TimeUtils;
import dune.inputs.core.IInput;
import hxd.Event;

import flash.display.Stage;
import flash.events.KeyboardEvent;
import flash.Lib;

/**
 * Gestionnaire d'interaction avec le clavier.
 * Cette classe stocke les interactions
 * afin que des objets puissent récupérer l'état du clavier à des moments précis.
 * 
 * @author Namide
 */
class KeyboardHandler implements IInput
{
	//static var _CAN_INSTANTIATE:Bool = false;
	//static var _INSTANCE:KeyboardHandler;
	
	//#if (flash || openfl)
		public var keyLeft(default, default):UInt = flash.ui.Keyboard.LEFT;
		public var keyRight(default, default):UInt = flash.ui.Keyboard.RIGHT;
		public var keyTop(default, default):UInt = flash.ui.Keyboard.UP;
		public var keyBottom(default, default):UInt = flash.ui.Keyboard.DOWN;
		public var keyB1(default, default):UInt = flash.ui.Keyboard.SPACE;
		public var keyB2(default, default):UInt = flash.ui.Keyboard.SHIFT;
		public var keyStart(default, default):UInt = flash.ui.Keyboard.ENTER;
		public var keySelect(default, default):UInt = flash.ui.Keyboard.DELETE;
		
	/*#else
		public var keyLeft(default, default):UInt = 37;
		public var keyRight(default, default):UInt = 39;
		public var keyTop(default, default):UInt = 38;
		public var keyBottom(default, default):UInt = 40;
		public var keyAction(default, default):UInt = 8;
	#end*/
	
	var _listKeyPressed:Array<UInt>;
	var _listKeyPressedTime:Array<UInt>;
	
	var _accTime:UInt = 80;
	
	//var _listKeyCodeHandler:Array<UInt>;
	//var _listCallbackHandler:Array<Void->Void>;
	//var _stage:Stage;
	
	public function new() 
	{
		//if (_CAN_INSTANTIATE = false) throw "You can't instancies a singleton, you must use the static method getInstance()";
		
		_listKeyPressed = [];
		_listKeyPressedTime = [];
		//_listKeyCodeHandler = [];
		//_listCallbackHandler = [];
		
		Lib.current.stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDown );
		Lib.current.stage.addEventListener( KeyboardEvent.KEY_UP, keyUp );
	}
	
	
	
	public inline function getAxisX():Float
	{
		var o:Float = getFloat( keyRight );
		if ( o <= 0 ) o = -getFloat( keyLeft );
		return o;
	}
	public inline function getAxisY():Float
	{
		var o:Float = getFloat( keyTop );
		if ( o <= 0 ) o = -getFloat( keyBottom );
		return o;
	}
	
	function getFloat(key:UInt):Float
	{
		var i = Lambda.indexOf( _listKeyPressed, key );
		if ( i > -1 )
		{
			var t:Float = ( TimeUtils.getMS() - _listKeyPressedTime[i] ) / _accTime;
			return ( t > 1 ) ? 1 : ( t < 0 ) ? 0 : t; 
		}
		return 0;
	}
	
	public inline function getB1():Float
	{
		return getFloat( keyB1 );
	}
	public inline function getB2():Float
	{
		return getFloat( keyB2 );
	}
	
	public inline function getStart():Bool
	{
		return getFloat( keyStart ) != 0;
	}
	public inline function getSelect():Bool
	{
		return getFloat( keySelect ) != 0;
	}
	
	
	
	/*public function addCallback( keyCode:UInt, pCallback:Void->Void ):Void
	{
		_listCallbackHandler.push(pCallback);
		_listKeyCodeHandler.push(keyCode);
	}*/
	
	public function getKeyPressed( keyCode:UInt ):Bool
	{
		return Lambda.has( _listKeyPressed, keyCode );
	}
	
	function keyDown( e:KeyboardEvent ):Void
	{
		_listKeyPressed.push( e.keyCode );
		_listKeyPressedTime.push( TimeUtils.getMS() );
	}
	
	function keyUp( e:KeyboardEvent ):Void
	{
		/*if ( Lambda.has( _listKeyCodeHandler, e.keyCode ) )
		{
			var i:Int;
			for ( i in 0..._listKeyCodeHandler.length )
			{
				if ( _listKeyCodeHandler[i] == e.keyCode ) _listCallbackHandler[i]();
			}
		}*/
		
		while ( Lambda.has( _listKeyPressed, e.keyCode ) )
		{
			var i:Int = Lambda.indexOf( _listKeyPressed, e.keyCode );
			_listKeyPressed.splice( i, 1 );
			_listKeyPressedTime.splice( i, 1 );
		}
	}
	
	/*public static function getInstance():KeyboardHandler
	{
        if (_INSTANCE == null)
		{
            _CAN_INSTANTIATE = true;
            _INSTANCE = new KeyboardHandler();
            _CAN_INSTANTIATE = false;
        }
        return _INSTANCE;
    }*/
	
	public function dispose():Void
	{
		//#if (flash || openfl )
			Lib.current.stage.removeEventListener( KeyboardEvent.KEY_DOWN, keyDown );
			Lib.current.stage.removeEventListener( KeyboardEvent.KEY_UP, keyUp );
		/*#elseif js
			js.Browser.document.onkeydown = null;
			js.Browser.document.onkeyup = null;
		#end*/
		
		_listKeyPressed = [];
		_listKeyPressedTime = [];
		//_listKeyCodeHandler = [];
		//_listCallbackHandler = [];
	}
}