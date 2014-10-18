package dune.input;

import dune.helper.core.DTime;
import dune.component.IInput;
import flash.events.Event;
import flash.Lib;
import haxe.Json;

/**
 * ...
 * @author Namide
 */
class GamepadJsHandler implements IInput
{
	static var _CONNECTED:Bool = false;
	static var _LIST_HANDLERS:Array<GamepadJsHandler> = [];
	
	// commands
	// https://github.com/robhawkes/gamepad-demo/blob/master/js/gamepad.js
	static var _DATAS:Array<Dynamic>;
	var _axisMin:Float = 0.2;
	var _idGamepad:Int = 0;
	
	// to simulate joystick with arrows
	var _listKeyPressed:Array<UInt>;
	var _listKeyPressedTime:Array<UInt>;
	var _accTime:UInt = 80;
	static var _LEFT(default, default):UInt = 1;
	static var _RIGHT(default, default):UInt = 2;
	static var _TOP(default, default):UInt = 3;
	static var _BOTTOM(default, default):UInt = 4;
	
	
	public function new() 
	{
		connectJs( this );
		
		_listKeyPressed = [];
		_listKeyPressedTime = [];
	}
	
	static function connectJs( handler:GamepadJsHandler ):Void
	{
		_LIST_HANDLERS.push( handler );
		if ( !_CONNECTED && flash.external.ExternalInterface.available )
		{
			//flash.Lib.current.stage.addEventListener( flash.events.Event.ENTER_FRAME, refresh );
			flash.external.ExternalInterface.addCallback( "getControllers", GamepadJsHandler.REFRESH );
			_CONNECTED = true;
		}
	}
	
	function disconnectJs():Void
	{
		_LIST_HANDLERS.remove(this);
		//flash.Lib.current.stage.removeEventListener( flash.events.Event.ENTER_FRAME, refresh );
	}
	
	static function REFRESH( a:String /*as:Array<String>*/ ):Void
	{
		_DATAS = haxe.Json.parse(a);
		
		for ( h in _LIST_HANDLERS )
		{
			h.refresh();
		}
		
		/*trace(a);
		_DATAS = [];
		for ( s in as )
		{
			_DATAS.push( haxe.Json.parse( Std.string( s ) ) );
		}*/
		
		//var t:UInt = DTime.getRealMS();
		//trace( DTime.getRealMS() - t );
	}
	
	function getFloat(key:UInt):Float
	{
		var i = Lambda.indexOf( _listKeyPressed, key );
		if ( i > -1 )
		{
			var t:Float = ( DTime.getRealMS() - _listKeyPressedTime[i] ) / _accTime;
			return ( t > 1 ) ? 1 : ( t < 0 ) ? 0 : t; 
		}
		return 0;
	}
	
	function testKey( val:Bool, keyId:UInt ):Void
	{
		if ( val && !Lambda.has( _listKeyPressed, keyId) )
		{
			_listKeyPressed.push( keyId );
			_listKeyPressedTime.push( DTime.getRealMS() );
		}
		else if ( !val )
		{
			while ( Lambda.has( _listKeyPressed, keyId ) )
			{
				var i:Int = Lambda.indexOf( _listKeyPressed, keyId );
				_listKeyPressed.splice( i, 1 );
				_listKeyPressedTime.splice( i, 1 );
			}
		}
	}
	
	function refresh():Void
	{
		if ( _DATAS == null || _DATAS.length < _idGamepad + 1 ) return;
		
		var data:Dynamic = _DATAS[_idGamepad];
		if ( data != null )
		{
			if ( data != null && data.buttons != null )
			{
				testKey( data.buttons[14] != null && data.buttons[14].value, _LEFT );
				testKey( data.buttons[15] != null && data.buttons[15].value, _RIGHT );
				testKey( data.buttons[12] != null && data.buttons[12].value, _TOP );
				testKey( data.buttons[13] != null && data.buttons[13].value, _BOTTOM );
			}
		}
	}
	
	/*function refresh(d:Dynamic):Void
	{
		//_datas = haxe.Json.parse( Std.string( flash.external.ExternalInterface.call( "duneGamepad.getController", 0 ) ) );
		if ( _DATAS != null && _DATAS.length > 0 ) 	_datas = GamepadJsHandler._DATAS[0];
		else 						_datas = [];
	}*/
	
	/* INTERFACE dune.input.core.IInput */
	
	public function getAxisX():Float 
	{
		if ( _DATAS == null || _DATAS.length < _idGamepad + 1 ) return 0;
		
		var data:Dynamic = _DATAS[_idGamepad];
		if ( data != null )
		{
			if( data.axes != null && data.axes[0] != null )
			{
				var val:Float = data.axes[0];
				if ( val < _axisMin && val > -_axisMin ) val = 0;
				if ( val != 0 ) return val;
			}
			
			var o:Float = getFloat( _RIGHT );
			if ( o <= 0 ) o = -getFloat( _LEFT );
			return o;
			
		}
		return 0;
	}
	
	public function getAxisY():Float 
	{
		if ( _DATAS == null || _DATAS.length < _idGamepad + 1 ) return 0;
		var data:Dynamic = _DATAS[_idGamepad];
		if ( data != null )
		{
			if( data.axes != null && data.axes[1] != null )
			{
				var val:Float = -data.axes[1];
				if ( val < _axisMin && val > -_axisMin ) val = 0;
				if ( val != 0 ) return val;
			}
			
			var o:Float = -getFloat( _TOP );
			if ( o <= 0 ) o = getFloat( _BOTTOM );
			return o;
		}
		return 0;
	}
	
	public function getB1():Float 
	{
		if ( _DATAS == null || _DATAS.length < _idGamepad + 1 ) return 0;
		var data:Dynamic = _DATAS[_idGamepad];
		if ( data != null && data.buttons != null && data.buttons[0] )
		{
			return data.buttons[0].value;
			/*var pressed = val == 1.0;
			if (typeof (val) == "object")
			{
				pressed = val.pressed;
				val = val.value;
			}*/
		}
		return 0;
	}
	
	public function getB2():Float 
	{
		if ( _DATAS == null || _DATAS.length < _idGamepad + 1 ) return 0;
		var data:Dynamic = _DATAS[_idGamepad];
		if ( data != null && data.buttons != null && data.buttons[1] )
		{
			return data.buttons[1].value;
			/*var pressed = val == 1.0;
			if (typeof (val) == "object")
			{
				pressed = val.pressed;
				val = val.value;
			}*/
		}
		return 0;
	}
	
	public function getStart():Bool 
	{
		if ( _DATAS == null || _DATAS.length < _idGamepad + 1 ) return false;
		var data:Dynamic = _DATAS[_idGamepad];
		if ( data != null && data.buttons != null && data.buttons[9] )
		{
			return data.buttons[9].value;
			/*var pressed = val == 1.0;
			if (typeof (val) == "object")
			{
				pressed = val.pressed;
				val = val.value;
			}*/
		}
		return false;
	}
	
	public function getSelect():Bool 
	{
		if ( _DATAS == null || _DATAS.length < _idGamepad + 1 ) return false;
		var data:Dynamic = _DATAS[_idGamepad];
		if ( data != null && data.buttons != null && data.buttons[8] )
		{
			return data.buttons[8].value;
			/*var pressed = val == 1.0;
			if (typeof (val) == "object")
			{
				pressed = val.pressed;
				val = val.value;
			}*/
		}
		return false;
	}
	
}