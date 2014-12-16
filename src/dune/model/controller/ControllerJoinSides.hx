package dune.model.controller;
import dune.component.Controller;
import dune.entity.Entity;

/**
 * ...
 * @author Namide
 */
class ControllerJoinSides extends Controller
{

	public var limitXMin:Int;
	public var limitXMax:Int;
	public var limitYMin:Int;
	public var limitYMax:Int;
	
	public function new() 
	{
		super();
	}
	
	public override function execute( dt:UInt ):Void
	{
		if ( entity.transform.x < limitXMin )
			entity.transform.x += limitXMax - limitXMin;
		else if ( entity.transform.x > limitXMax )
			entity.transform.x -= limitXMax - limitXMin;
		
		if ( entity.transform.y < limitYMin )
			entity.transform.y += limitYMax - limitYMin;
		else if ( entity.transform.y > limitYMax )
			entity.transform.y -= limitYMax - limitYMin;
	}
	
	public override function clear() 
	{
		super.clear();
	}
	
}