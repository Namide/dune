package dune.models.controller ;
import dune.entities.Entity;
import dune.compBasic.Controller;
import dune.system.physic.components.CompBodyType;
import dune.system.physic.components.ContactBodies;
import dune.system.Settings;
import dune.system.SysManager;

/**
 * @author Namide
 */
class ControllerPlatform extends Controller
{

	public var bounce(default, default):Float = 0.25;
	
	public function new() 
	{
		super();
		beforePhysic = true;
	}
	
	override function set_entity(value:Entity):Entity 
	{
		value.transform.vActive = true;
		return entity = value;
	}
	
	public override function execute( dt:UInt ):Void
	{
		var bottomWall:Bool = 	_contacts.hasTypeOfSolid( CompBodyType.SOLID_TYPE_WALL, ContactBodies.BOTTOM ) || 
								_contacts.hasTypeOfSolid( CompBodyType.SOLID_TYPE_PLATFORM, ContactBodies.BOTTOM );
		
		var leftWall:Bool = 	_contacts.hasTypeOfSolid( CompBodyType.SOLID_TYPE_WALL, ContactBodies.LEFT );
		var rightWall:Bool = 	_contacts.hasTypeOfSolid( CompBodyType.SOLID_TYPE_WALL, ContactBodies.RIGHT );
		var topWall:Bool = 		_contacts.hasTypeOfSolid( CompBodyType.SOLID_TYPE_WALL, ContactBodies.TOP );
		
		var platformVX:Float = 0;
		if ( bottomWall )
		{
			var platformVY:Float = 0;
			for ( body in _contacts.getByType( CompBodyType.SOLID_TYPE_WALL , ContactBodies.BOTTOM ) )
			{
				platformVX += body.entity.transform.vX;
				platformVY += body.entity.transform.vY;
			}
			for ( body in _contacts.getByType( CompBodyType.SOLID_TYPE_PLATFORM , ContactBodies.BOTTOM ) )
			{
				platformVX += body.entity.transform.vX;
				platformVY += body.entity.transform.vY;
			}
			entity.transform.vY = platformVY;
		}
		
		if ( leftWall )
		{
			for ( body in _contacts.getByType( CompBodyType.SOLID_TYPE_WALL , ContactBodies.LEFT ) )
			{
				if ( platformVX < body.entity.transform.vX ) platformVX = body.entity.transform.vX;
			}
		}
		if ( rightWall )
		{
			for ( body in _contacts.getByType( CompBodyType.SOLID_TYPE_WALL , ContactBodies.RIGHT ) )
			{
				if ( platformVX > body.entity.transform.vX ) platformVX = body.entity.transform.vX;
			}
		}
		if ( topWall )
		{
			for ( body in _contacts.getByType( CompBodyType.SOLID_TYPE_WALL , ContactBodies.TOP ) )
			{
				if ( entity.transform.vY < body.entity.transform.vY ) entity.transform.vY = body.entity.transform.vY;
			}
		}
		
		if ( bottomWall  ) entity.transform.vX = platformVX;
	}
	
	public override function clear() 
	{
		super.clear();
	}
	
	
	
}