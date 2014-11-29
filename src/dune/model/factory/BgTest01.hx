package dune.model.factory;

import flash.Lib;
import h3d.col.Point;
import h3d.prim.Polygon;

/**
 * ...
 * @author Namide
 */
class BgTest01 extends Polygon
{

	public function new( w:Float, h:Float, pr:Float, ?num:Int = 100, size:Int = 64 )
	{
		var p = [];
		var idx = new hxd.IndexBuffer();
		//uvs = new Array<h3d.prim.UV>();
		colors = [];
		
		for ( i in 0...num )
		{
			var x = hxd.Math.random( w );
			var y = hxd.Math.random( h );
			var z = hxd.Math.random( pr );
			
			var i = p.length;
			
			p.push( new h3d.col.Point( varC(x, 2), 			varC(y, 2), 			varC(z, 2) ) );
			p.push( new h3d.col.Point( varC(x + size, 2), 	varC(y, 2), 			varC(z, 2) ) );
			p.push( new h3d.col.Point( varC(x + size, 2), 	varC(y + size, 2), 		varC(z, 2) ) );
			p.push( new h3d.col.Point( varC(x, 2), 			varC(y + size, 2), 		varC(z, 2) ) );
			
			
			idx.push( i ); 		idx.push( i + 1 ); 	idx.push( i + 2 );
			idx.push( i ); 		idx.push( i + 2 );	idx.push( i + 3 );
			
			var c1 = new h3d.col.Point( Math.random(), Math.random(), Math.random() );
			
			colors.push( c1 );
			colors.push( newC(c1, 0.2) );
			colors.push( newC(c1, 0.2) );
			colors.push( newC(c1, 0.2) );
			//colors.push( new h3d.col.Point( Math.random(), Math.random(), Math.random() ) );
			//colors.push( new h3d.col.Point( Math.random(), Math.random(), Math.random() ) );
			
			//uvs.push( uv00 ); uvs.push( uv10 ); uvs.push( uv11 );
			//uvs.push( uv11 ); uvs.push( uv01 ); uvs.push( uv00 );
		}
		
		super(p, idx);
	}
	
	inline function newC( color:h3d.col.Point, decal:Float = 0.2 ):h3d.col.Point
	{
		return new h3d.col.Point( varC(color.x, decal),  varC(color.y, decal), varC(color.z, decal) );
	}
	
	inline function varC( v:Float, decal:Float = 0.2 ):Float
	{
		return v + Math.random() * 2 * decal - decal;
	}
	
	override function addUVs()
	{
		unindex();

		var uv00 = new h3d.prim.UV(0, 0);
		var uv01 = new h3d.prim.UV(0, 1);
		var uv10 = new h3d.prim.UV(1, 0);
		var uv11 = new h3d.prim.UV(1, 1);
		
		uvs = [];
		for ( i in 0...Math.round(points.length/ 6) )
		{
			uvs.push( uv00 ); uvs.push( uv10 ); uvs.push( uv11 );
			uvs.push( uv00 ); uvs.push( uv11 ); uvs.push( uv01 );
		}
		
		/*var z = new UV(0, 1);
		var x = new UV(1, 1);
		var y = new UV(0, 0);
		var o = new UV(1, 0);

		uvs = [
			z, x, o,
			z, o, y,
			x, z, y,
			x, y, o,
			x, z, y,
			x, y, o,
			z, o, x,
			z, y, o,
			x, y, z,
			x, o, y,
			z, o, x,
			z, y, o,
		];*/
	}
	
}