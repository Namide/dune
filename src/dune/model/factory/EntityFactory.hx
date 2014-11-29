package dune.model.factory ;
import dune.entity.Entity;
import dune.system.graphic.component.Display2dSprite;
import dune.model.factory.EntityFactory.EntityFactory;
import dune.system.physic.component.Body;
import dune.system.physic.component.BodyType;
import dune.system.physic.shapes.ShapeRect;
import dune.system.SysManager;

/**
 * ...
 * @author Namide
 */
class EntityFactory
{

	public function new() 
	{
		throw "this class is static!";
	}
	
	public static inline function getSolidDisplay( sm:SysManager, w:Float, h:Float, color:Int = -1 ):Display2dSprite
	{
		/*var g = new h2d.Graphics( sm.sysGraphic.s2d );
		g.beginFill( Math.round( 0xFFFFFF * Math.random() ) );
		g.drawRect( 0, 0, w, h );
		g.endFill();*/
		return new Display2dSprite( DisplayFactory.getRect( sm, w, h, color ) );
	}
	
	public static function addSolidEmpty( sm:SysManager, x:Float, y:Float, w:Float, h:Float, solidType:UInt = BodyType.SOLID_TYPE_WALL ):Entity
	{
		var e = new Entity();
		
		// graphic
		
			e.transform.x = x;
			e.transform.y = y;
			
		// collision
		
			var b4:Body = new Body();
			var psr4:ShapeRect = new ShapeRect();
			psr4.w = w;
			psr4.h = h;
			b4.shape = psr4;
			b4.typeOfCollision = BodyType.COLLISION_TYPE_PASSIVE;
			b4.typeOfSolid = solidType;
			e.addBody( b4 );
		
		sm.addEntity( e );
		return e;
	}
	
	public static function addSolid( sm:SysManager, x:Float, y:Float, w:Float, h:Float, solidType:UInt = BodyType.SOLID_TYPE_WALL, display:Display2dSprite = null ):Entity
	{
		var e = addSolidEmpty( sm, x, y, w, h, solidType );
		e.display = (display == null) ? getSolidDisplay( sm, w, h ) : display;
		sm.addEntity( e );
		return e;
	}
	
}