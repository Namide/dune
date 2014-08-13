package dune.models.inputs;

import dune.system.input.components.CompInput;

/**
 * @author Namide
 */
class InputMobile extends CompInput
{
	
	public static var TYPE_LINEAR:UInt = 0;
	public static var TYPE_SIN:UInt = 1;
	public static var TYPE_COS:UInt = 2;
	
	private static inline var PI2:Float = 2 * 3.14159265359;
	
	public var anchorX(default, default):Float = 0;
	public var anchorY(default, default):Float = 0;
	
	public var moveTypeX(default, default):UInt = InputMobile.TYPE_LINEAR;
	public var moveDistX(default, default):Float = 0;
	public var moveTimeX(default, default):Float = 0;
	public var movePauseX(default, default):Float = 0;
	public var moveLoopX(default, default):Bool = true;
	
	public var time(default, default):UInt = 0;
	
	public function new() 
	{
		super();
	}
	
	public function initX( type:UInt, x:Float, dist:UInt, time:UInt, pause:Float = 0, loop:Bool = true ):Void
	{
		anchorX = x;
		moveTypeX = type;
		moveDistX = dist;
		moveTimeX = time;
		movePauseX = pause;
		moveLoopX = loop;
		time = 0;
	}
	
	override public function execute( dt:UInt ):Void 
	{
		time += dt;
		var x:Float = 0, y:Float = 0;
		
		var allTimeMove:Float = moveTimeX + movePauseX;
		
		switch ( moveTypeX )
		{
			case InputMobile.TYPE_LINEAR :
				x = ( time % allTimeMove ) / moveTimeX;
				x = ( x > moveTimeX ) ? x = moveTimeX : x;
				x = calculateLoop( x, moveLoopX );
				
			case InputMobile.TYPE_SIN :
				if ( time % allTimeMove > moveTimeX ) { x = 1; }
				else { x = Math.sin( time * InputMobile.PI2 / allTimeMove ) * 0.5 + 0.5; }
				
				x = calculateLoop( x, !moveLoopX );
				
			case InputMobile.TYPE_COS :
				if ( time % allTimeMove > moveTimeX ) { x = 1; }
				else { x = Math.cos( time * InputMobile.PI2 / allTimeMove ) * 0.5 + 0.5; }
				x = calculateLoop( x, !moveLoopX );
		}
		
		this.entity.transform.x = anchorX + x * moveDistX / moveTimeX;
		trace( this.entity.transform.x );
		super.execute( dt );
	}
	
	private inline function calculateLoop( x:Float, loop:Bool ):Float
	{
		var allMoveTime:Float = moveTimeX + movePauseX;
		return ( loop && (time % (allMoveTime + allMoveTime) ) > allMoveTime ) ? moveTimeX - x : x;
	}
	
}