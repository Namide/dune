package dune.helper.core ;
import dune.system.Settings;

/**
 * ...
 * @author Namide
 */
class DTime
{
	var _realT:UInt;
	
	public var frameRest:Float;
	
	public var pause( default, default ):Bool;
	public var tMs( default, null ):UInt;
	public var dtMs( default, null ):UInt;
	
	public var distord( default, default ):Float;
	
	public function new( ms:UInt = 0 ) 
	{
		_realT = DTime.getRealMS() - ms;
		
		dtMs = 0;
		distord = 1;
		
		pause = false;
		frameRest = 0;
	}
	
	public function update( frameDelay:Int ):Void
	{
		if ( pause )
		{
			dtMs = 0;
			_realT = getRealMS();
			return;
		}
		
		dtMs = getRealMS() - _realT;
		if ( dtMs <= 0 ) return;
		
		frameRest += ( dtMs / frameDelay );
		
		tMs += ( distord == 1 ) ? dtMs : Math.round( dtMs * distord );
		_realT = getRealMS();
	}
	
	public function restart():Void { _realT = getRealMS(); dtMs = 0; frameRest = 0; };
	
	public inline function getDtSec():Float { return dtMs * 0.001; }
	public inline function getSec():Float { return tMs * 0.001; }
	
	public static inline function getRealMS():UInt
	{
		#if (flash || openfl)
			return flash.Lib.getTimer();
		#elseif (neko || php)
			return Sys.time() * 1000;
		#elseif js
			return Math.round( Date.now().getTime() );
		#elseif cpp
			return untyped __global__.__time_stamp() * 1000;
		#else
			return 0;
		#end
	}
	
}