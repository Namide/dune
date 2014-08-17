package dune.models.inputs;
import dune.entities.Entity;
import dune.system.input.components.CompInput;
import dune.system.SysManager;

/**
 * @author Namide
 */
class InputGravity extends CompInput
{

	/**
	 * Gravity of the entity in X axis (wild?).
	 * For a similar to "time dependant", you must do like the following:
	 * X = 10 / SysManager.FRAME_DELAY;
	 */
	public static var X(default, default):Float = 0;
	
	/**
	 * Gravity of the entity in Y axis.
	 * For a similar to "time dependant", you must do like the following:
	 * X = 10 / SysManager.FRAME_DELAY;
	 */
	public static var Y(default, default):Float = 9 / SysManager.FRAME_DELAY;
	
	public var x(default, set):Float = 1;
	function set_x(val:Float):Float 
	{
		xFinal = InputGravity.X * val;
		return x = val;
	}
	
	public var y(default, set):Float = 1;
	function set_y(val:Float):Float 
	{
		yFinal = InputGravity.Y * val;
		return y = val;
	}
	
	private var xFinal:Float;
	private var yFinal:Float;
	
	public function new() 
	{
		super();
	}
	
	override function set_entity(value:Entity):Entity 
	{
		value.transform.vActive = true;
		return entity = value;
	}
	
	public override function execute( dt:UInt ):Void
	{
		if ( X != 0 && x != 0 ) { entity.transform.vX += xFinal; }
		if ( Y != 0 && y != 0 ) { entity.transform.vY += yFinal; }
	}
	
	public override function clear() 
	{
		super.clear();
		x = 1;
		y = 1;
		xFinal = InputGravity.X * x;
		yFinal = InputGravity.Y * y;
	}
	
	
	
}