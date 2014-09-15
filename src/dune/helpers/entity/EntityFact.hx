package dune.helpers.entity;
import dune.entities.Entity;
import dune.system.graphic.components.CompDisplay2dSprite;
import dune.system.physic.components.CompBody;
import dune.system.physic.components.CompBodyType;
import dune.system.physic.shapes.PhysShapeRect;
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
	
	public static function addSolid( sm:SysManager, x:Float, y:Float, w:Float, h:Float, compBodyType:UInt = CompBodyType.SOLID_TYPE_WALL ):Entity
	{
		var e = new Entity();
		
		var g = new h2d.Graphics(sm.sysGraphic.s2d);
		g.beginFill( Math.round( 0xFFFFFF * Math.random() ) );
		g.lineStyle( 1, Math.round( 0xFFFFFF * Math.random() ) );
		g.drawRect( 0, 0, w, h );
		g.endFill();
		
		// graphic
		
			//var spr4 = new h2d.Sprite( sm.sysGraphic.s2d );
			//var bmp4 = new h2d.Bitmap( tile, spr4 );
			e.transform.x = x;
			e.transform.y = y;
			e.display = new CompDisplay2dSprite( g );
		
		// collision
		
			var b4:CompBody = new CompBody();
			var psr4:PhysShapeRect = new PhysShapeRect();
			psr4.w = w;
			psr4.h = h;
			b4.shape = psr4;
			b4.typeOfCollision = compBodyType;
			b4.typeOfSolid = CompBodyType.SOLID_TYPE_WALL;
			e.addBody( b4 );
		
		sm.addEntity( e );
		return e;
	}
	
}