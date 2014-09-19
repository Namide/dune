package dune.models.inputs;

import dune.system.input.components.CompInput;

/**
 * @author Namide
 */
class InputMobile extends CompInput
{
	
	public static var TYPE_LINEAR:UInt = 1;
	public static var TYPE_SIN:UInt = 2;
	public static var TYPE_COS:UInt = 3;
	
	private static inline var PI2:Float = 2 * 3.14159265359;
	
	public var anchorX(default, default):Float = 0;
	public var anchorY(default, default):Float = 0;
	
	public var moveTypeX(default, default):UInt = InputMobile.TYPE_LINEAR;
	public var moveDistX(default, default):Float = 0;
	public var moveTimeX(default, default):UInt = 0;
	public var movePauseX(default, default):UInt = 0;
	public var moveLoopX(default, default):Bool = true;
	
	public var moveTypeY(default, default):UInt = InputMobile.TYPE_LINEAR;
	public var moveDistY(default, default):Float = 0;
	public var moveTimeY(default, default):UInt = 0;
	public var movePauseY(default, default):UInt = 0;
	public var moveLoopY(default, default):Bool = true;
	
	public var time(default, default):UInt = 0;
	
	public function new() 
	{
		super();
		beforePhysic = true;
	}
	
	public function initX( type:UInt, x:Float, dist:Float, time:UInt, pause:UInt = 0, loop:Bool = true ):Void
	{
		anchorX = x;
		moveTypeX = type;
		moveDistX = dist;
		moveTimeX = time;
		movePauseX = pause;
		moveLoopX = loop;
		time = 0;
	}
	
	public function initY( type:UInt, y:Float, dist:UInt, time:UInt, pause:UInt = 0, loop:Bool = true ):Void
	{
		anchorY = y;
		moveTypeY = type;
		moveDistY = dist;
		moveTimeY = time;
		movePauseY = pause;
		moveLoopY = loop;
		time = 0;
	}
	
	override public function execute( dt:UInt ):Void 
	{
		time += dt;
		var x:Float = 0, y:Float = 0;
		var allTimeMove:Float = moveTimeX + movePauseX;
		
		if ( moveDistX != 0 )
		{
			switch ( moveTypeX )
			{
				case InputMobile.TYPE_LINEAR :
					x = ( time % allTimeMove ) / moveTimeX;
					x = ( x > 1 ) ? x = 1 : x;
					x = calculateLoop( x, moveLoopX );
					
				case InputMobile.TYPE_SIN :
					if ( time % allTimeMove >= moveTimeX ) { x = 1; }
					else { x = Math.sin( ( time % allTimeMove ) * InputMobile.PI2 / moveTimeX ) * 0.5 + 0.5; }
					x = calculateLoop( x, !moveLoopX );
					
				case InputMobile.TYPE_COS :
					if ( time % allTimeMove > moveTimeX ) { x = 1; }
					else { x = Math.cos( time * InputMobile.PI2 / allTimeMove ) * 0.5 + 0.5; }
					x = calculateLoop( x, !moveLoopX );
			}
		}
		
		if ( moveDistY != 0 )
		{
			switch ( moveTypeY )
			{
				case InputMobile.TYPE_LINEAR :
					y = ( time % allTimeMove ) / moveTimeY;
					y = ( y > 1 ) ? y = 1 : y;
					y = calculateLoop( y, moveLoopY );
					
				case InputMobile.TYPE_SIN :
					if ( time % allTimeMove >= moveTimeY ) { y = 1; }
					else { y = Math.sin( ( time % allTimeMove ) * InputMobile.PI2 / moveTimeY ) * 0.5 + 0.5; }
					y = calculateLoop( y, !moveLoopY );
					
				case InputMobile.TYPE_COS :
					if ( time % allTimeMove > moveTimeY ) { y = 1; }
					else { y = Math.cos( time * InputMobile.PI2 / allTimeMove ) * 0.5 + 0.5; }
					y = calculateLoop( y, !moveLoopY );
			}
		}
		
		var dX:Float = anchorX + x * moveDistX;
		var dY:Float = anchorY + y * moveDistY;
		
		entity.transform.vX = dX - entity.transform.x;
		entity.transform.vY = dY - entity.transform.y;
		entity.transform.x = dX;
		entity.transform.y = dY;
		
		super.execute( dt );
	}
	
	private inline function calculateLoop( x:Float, loop:Bool ):Float
	{
		var allMoveTime:Float = moveTimeX + movePauseX;
		return ( loop && (time % (allMoveTime + allMoveTime) ) >= allMoveTime ) ? 1 - x : x;
	}
	
}