package dune.helpers.entity;
import dune.entities.Entity;
import dune.system.graphic.components.Display2dSprite;
import dune.system.physic.components.CompBody;
import dune.system.physic.components.CompBodyType;
import dune.system.physic.shapes.ShapeRect;
import dune.system.SysManager;

/**
 * ...
 * @author Namide
 */
class EntityFact
{

	public function new() 
	{
		throw "this class is static!";
	}
	
	public static function getSolidDisplay( sm:SysManager, w:Float, h:Float ):Display2dSprite
	{
		var g = new h2d.Graphics( sm.sysGraphic.s2d );
		g.beginFill( Math.round( 0xFFFFFF * Math.random() ) );
		//g.lineStyle( 1, Math.round( 0xFFFFFF * Math.random() ) );
		g.drawRect( 0, 0, w, h );
		g.endFill();
		
		return new Display2dSprite( g );
	}
	
	public static function addSolid( sm:SysManager, x:Float, y:Float, w:Float, h:Float, solidType:UInt = CompBodyType.SOLID_TYPE_WALL ):Entity
	{
		var e = new Entity();
		
		// graphic
		
			e.transform.x = x;
			e.transform.y = y;
			e.display = getSolidDisplay( sm, w, h );
		
		// collision
		
			var b4:CompBody = new CompBody();
			var psr4:ShapeRect = new ShapeRect();
			psr4.w = w;
			psr4.h = h;
			b4.shape = psr4;
			b4.typeOfCollision = CompBodyType.COLLISION_TYPE_PASSIVE;
			b4.typeOfSolid = solidType;
			e.addBody( b4 );
		
		sm.addEntity( e );
		return e;
	}
	
}