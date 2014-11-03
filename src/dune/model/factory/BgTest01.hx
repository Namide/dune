package dune.model.factory;

import flash.Lib;
import h3d.prim.Polygon;

/**
 * ...
 * @author Namide
 */
class BgTest01 extends Polygon
{

	public function new( w:Float, h:Float, pr:Float, ?num:Int = 1, size:Int = 32 )
	{
		var p = [];
		var idx = new hxd.IndexBuffer();
		//uvs = new Array<h3d.prim.UV>();
		colors = [];
		
		var s:Float = 20;
		for ( i in 0...num )
		{
			var x = hxd.Math.random( w );
			var y = hxd.Math.random( h );
			var z = hxd.Math.random( pr );
			
			var i = p.length;
			
			p.push( new h3d.col.Point( x, 			y, 			z ) );
			p.push( new h3d.col.Point( x + size, 	y, 			z ) );
			p.push( new h3d.col.Point( x + size, 	y + size, 	z ) );
			p.push( new h3d.col.Point( x, 			y + size, 	z ) );
			
			
			idx.push( i ); 		idx.push( i + 1 ); 	idx.push( i + 2 );
			idx.push( i ); 		idx.push( i + 2 );	idx.push( i + 3 );
			
			colors.push( new h3d.col.Point( Math.random(), Math.random(), Math.random() ) );
			colors.push( new h3d.col.Point( Math.random(), Math.random(), Math.random() ) );
			colors.push( new h3d.col.Point( Math.random(), Math.random(), Math.random() ) );
			colors.push( new h3d.col.Point( Math.random(), Math.random(), Math.random() ) );
			colors.push( new h3d.col.Point( Math.random(), Math.random(), Math.random() ) );
			colors.push( new h3d.col.Point( Math.random(), Math.random(), Math.random() ) );
			
			//uvs.push( uv00 ); uvs.push( uv10 ); uvs.push( uv11 );
			//uvs.push( uv11 ); uvs.push( uv01 ); uvs.push( uv00 );
		}
		
		super(p, idx);
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