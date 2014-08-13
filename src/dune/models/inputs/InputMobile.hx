package dune.models.inputs;

import dune.system.input.components.CompIA;

/**
 * @author Namide
 */
class InputMobile extends CompIA
{
	
	public static var TYPE_LINEAR:UInt = 0;
	public static var TYPE_SIN:UInt = 0;
	public static var TYPE_COS:UInt = 0;
	
	private static inline var PI2:Float = Math.PI * 2;
	
	public var anchorX(default, default):Float;
	public var anchorY(default, default):Float;
	
	public var moveTypeX(default, default):UInt = CompIA.TYPE_LINEAR;
	public var moveDistX(default, default):Float = 0;
	public var moveTimeX(default, default):Float = 0;
	public var movePauseX(default, default):Float = 0;
	public var moveLoopX(default, default):Bool = true;
	
	public var time(default, default):UInt = 0;
	
	public function new() 
	{
		super();
	}
	
	override public function execute( dt:Float ):Void 
	{
		time += dt;
		var x:Float, y:Float;
		
		var allTimeMove:Float = moveTimeX + movePauseX;
		
		switch ( moveTypeX )
		{
			case CompIA.TYPE_LINEAR :
				x = ( time % allTimeMove ) / moveTimeX;
				x = ( x > moveTimeX ) ? x = moveTimeX : x;
				x = calculateLoop( x, moveLoopX );
				break;
				
			case CompIA.TYPE_SIN :
				if ( time % allTimeMove > moveTimeX ) { x = 1; }
				else { x = Math.sin( time * CompIA.PI2 / allTimeMove ); }
				x = calculateLoop( x, !moveLoopX );
				break;
				
			case CompIA.TYPE_COS :
				if ( time % allTimeMove > moveTimeX ) { x = 1; }
				else { x = Math.cos( time * CompIA.PI2 / allTimeMove ); }
				x = calculateLoop( x, !moveLoopX );
				break;
		}
		
		this.entity.transform.x = anchorX + x * moveDistX / moveTimeX;
		super.execute();
	}
	
	private inline function calculateLoop( x:Float, loop:Bool ):Float
	{
		var allMoveTime:Float = moveTimeX + movePauseX;
		return ( loop && (time % (allMoveTime + allMoveTime) ) > allMoveTime) ) ? moveTimeX - x : x;
	}
	
	private inline function calculatePause( x:Float ):Float
	{
		return 
	}
}