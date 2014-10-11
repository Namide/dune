package dune.input;

import dune.input.core.IInput;
import flash.events.Event;
import flash.Lib;
import haxe.Json;

/**
 * ...
 * @author Namide
 */
class GamepadJsHandler implements IInput
{

	// commands
	// https://github.com/robhawkes/gamepad-demo/blob/master/js/gamepad.js
	var _datas:Dynamic;
	var _axisMin:Float = 0.2;
	
	public function new() 
	{
		connectJs();
	}
	
	function connectJs():Void
	{
		if ( flash.external.ExternalInterface.available )
		{
			//trace( flash.external.ExternalInterface.call( "duneGamepad.getController", 0) );
			flash.Lib.current.stage.addEventListener( flash.events.Event.ENTER_FRAME, refresh );
		}
	}
	
	function disconnectJs():Void
	{
		flash.Lib.current.stage.removeEventListener( flash.events.Event.ENTER_FRAME, refresh );
	}
	
	function refresh(d:Dynamic):Void
	{
		_datas = haxe.Json.parse( Std.string( flash.external.ExternalInterface.call( "duneGamepad.getController", 0 ) ) );
	}
	
	/* INTERFACE dune.input.core.IInput */
	
	public function getAxisX():Float 
	{
		if ( _datas != null )
		{
			if( _datas.axes != null && _datas.axes[0] != null )
			{
				var val:Float = _datas.axes[0];
				if ( val < _axisMin && val > -_axisMin ) val = 0;
				if ( val != 0 ) return val;
			}
			
			if ( _datas != null && _datas.buttons != null )
			{
				if ( _datas.buttons[14] != null && _datas.buttons[14].value )
				{
					return -1;
				}
				if ( _datas.buttons[14] != null && _datas.buttons[15].value )
				{
					return 1;
				}
			}
		}
		return 0;
	}
	
	public function getAxisY():Float 
	{
		if ( _datas != null )
		{
			if( _datas.axes != null && _datas.axes[1] != null )
			{
				var val:Float = _datas.axes[1];
				if ( val < _axisMin && val > -_axisMin ) val = 0;
				if ( val != 0 ) return val;
			}
			
			if ( _datas != null && _datas.buttons != null )
			{
				if ( _datas.buttons[12] != null && _datas.buttons[12].value )
				{
					return -1;
				}
				if ( _datas.buttons[13] != null && _datas.buttons[13].value )
				{
					return 1;
				}
			}
		}
		return 0;
	}
	
	public function getB1():Float 
	{
		if ( _datas != null && _datas.buttons != null && _datas.buttons[0] )
		{
			return _datas.buttons[0].value;
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
		if ( _datas != null && _datas.buttons != null && _datas.buttons[1] )
		{
			return _datas.buttons[1].value;
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
		if ( _datas != null && _datas.buttons != null && _datas.buttons[9] )
		{
			return _datas.buttons[9].value;
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
		if ( _datas != null && _datas.buttons != null && _datas.buttons[8] )
		{
			return _datas.buttons[8].value;
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