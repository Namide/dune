package dune.models.controller ;
import dune.entities.Entity;
import dune.compBasic.Controller;
import dune.system.physic.components.CompBody;
import dune.system.physic.components.CompBodyType;
import dune.system.physic.components.ContactBodies;
import dune.system.Settings;
import dune.system.SysManager;

/**
 * @author Namide
 */
class ControllerPlatform extends Controller
{

	public var bounce(default, default):Float = 0.5;
	public var friction(default, default):Float = 0.95;
	public var stopBounceVY(default, default):Float = 3;
	
	var _contacts:ContactBodies;
	
	public function new() 
	{
		super();
		beforePhysic = false;
	}
	
	override function set_entity(value:Entity):Entity 
	{
		value.transform.vActive = true;
		
		var body:CompBody = Lambda.find( value.bodies, function ( cb:CompBody ):Bool { return (cb.typeOfSolid & CompBodyType.SOLID_TYPE_MOVER == CompBodyType.SOLID_TYPE_MOVER); } );
		if ( body == null ) throw "An entity with controller platform must have a solid type mover in physic body";
		_contacts = body.contacts;
		
		return entity = value;
	}
	
	
	public override function execute( dt:UInt ):Void
	{
		var bottomWall:Bool = 	_contacts.hasTypeOfSolid( CompBodyType.SOLID_TYPE_WALL, ContactBodies.BOTTOM ) || 
								_contacts.hasTypeOfSolid( CompBodyType.SOLID_TYPE_PLATFORM, ContactBodies.BOTTOM );
		
		var leftWall:Bool = 	_contacts.hasTypeOfSolid( CompBodyType.SOLID_TYPE_WALL, ContactBodies.LEFT );
		var rightWall:Bool = 	_contacts.hasTypeOfSolid( CompBodyType.SOLID_TYPE_WALL, ContactBodies.RIGHT );
		var topWall:Bool = 		_contacts.hasTypeOfSolid( CompBodyType.SOLID_TYPE_WALL, ContactBodies.TOP );
		
		var vX:Float = 0;
		var vY:Float = 0;
		//var bounceX:Bool = false;
		//var bounceY:Bool = false;
		if ( bottomWall )
		{
			for ( body in _contacts.getByType( CompBodyType.SOLID_TYPE_WALL , ContactBodies.BOTTOM ) )
			{
				vX += body.entity.transform.vX;
				vY += body.entity.transform.vY;
				//bounceY = true;
			}
			for ( body in _contacts.getByType( CompBodyType.SOLID_TYPE_PLATFORM , ContactBodies.BOTTOM ) )
			{
				vX += body.entity.transform.vX;
				vY += body.entity.transform.vY;
				//bounceY = true;
			}
		}
		
		
		if ( leftWall )
		{
			for ( body in _contacts.getByType( CompBodyType.SOLID_TYPE_WALL , ContactBodies.LEFT ) )
			{
				if ( vX < body.entity.transform.vX ) 
				{
					vX += body.entity.transform.vX;
				}
				//bounceX = true;
			}
		}
		if ( rightWall )
		{
			for ( body in _contacts.getByType( CompBodyType.SOLID_TYPE_WALL , ContactBodies.RIGHT ) )
			{
				if ( vX > body.entity.transform.vX )
				{
					vX += body.entity.transform.vX;
				}
				//bounceX = true;
			}
		}
		if ( topWall )
		{
			for ( body in _contacts.getByType( CompBodyType.SOLID_TYPE_WALL , ContactBodies.TOP ) )
			{
				if ( entity.transform.vY < body.entity.transform.vY )
				{
					vY = body.entity.transform.vY;
				}
				//bounceY = true;
			}
		}
		
		
		
		//vX += entity.transform.vX;
		entity.transform.vY += Settings.GRAVITY;
		
		var grip:Bool = false;
		if ( bottomWall && entity.transform.vY > 0 )
		{
			if ( entity.transform.vY > stopBounceVY )
			{
				vY += -entity.transform.vY * bounce;
			}
			else
			{
				vY = 0;
				grip = true;
			}
			
			/*if ( Math.abs(vY) < Settings.GRAVITY )
			{
				trace("sleep?");
				for ( body in entity.bodies )
				{
					entity.transform.vX = 0;
					entity.transform.vY = 0;
					body.sleep = true;
					return;
				}
			}*/
		}
		else if ( topWall && entity.transform.vY < 0 )
		{
			vY += -entity.transform.vY * bounce;
		}
		else
		{
			vY += entity.transform.vY;
		}
		
		if ( leftWall && entity.transform.vX < 0 )
		{
			vX += -entity.transform.vX * bounce;
		}
		else if ( rightWall && entity.transform.vX > 0 )
		{
			vX += -entity.transform.vX * bounce;
		}
		else
		{
			//if ( entity.transform.vX > vX )
			//{
			if ( (bottomWall || topWall) && !grip )
			{
				vX = Math.max( vX, entity.transform.vX ) * friction;
				//vX += entity.transform.vX * friction;
			}
			else if ( !grip )
			{
				vX += entity.transform.vX;
			}
			else if ( vX == 0 )
			{
				vX += entity.transform.vX * friction;
			}
			//}
		}
		
		//if ( leftWall ) 		vX += -entity.transform.vX * bounce;
		//if ( rightWall ) 		vX += -entity.transform.vX * bounce;
		
		
		if ( leftWall || rightWall ) vY *= friction;
		
		//if ( bottomWall && vY < 0 && -vY <= Settings.GRAVITY )
		//trace(vY, Settings.GRAVITY);
		
		//if ( topWall ) 	vX += -entity.transform.vX * bounce;
		//else			vX += entity.transform.vX;
		
		//vX += entity.transform.vX;
		//vY += entity.transform.vY;
		
		entity.transform.vX = vX;
		entity.transform.vY = vY;
	}
	
	public override function clear() 
	{
		super.clear();
	}
	
	
	
}