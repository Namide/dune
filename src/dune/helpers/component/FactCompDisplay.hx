package dune.helpers.component;

import dune.system.graphic.components.CompDisplay2dAnim;
import dune.system.SysManager;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.geom.Matrix;
import h2d.Anim;
import h2d.Bitmap;
import h2d.Tile;
import h2d.TileGroup;
import h3d.mat.Texture;

/**
 * ...
 * @author namide.com
 */
class FactCompDisplay
{

	public function new() 
	{
		
	}
	
	public inline static function mcToDisplay2dAnim( mc:MovieClip, scale:Float = 1.0, innerTex:Texture ):Anim
	{
		
		var tile : Tile;
		//------------------------------
		
		
		var surf = 0;
		var sizes = [];
		
		for ( i in 0...mc.totalFrames )
		{
			mc.gotoAndStop(i+1);
			var w = Math.ceil(mc.width) + 1;
			var h = Math.ceil(mc.height) + 1;
			surf += (w + 1) * (h + 1);
			sizes[i] = { w:w, h:h };
		}
		
		var side = Math.ceil( Math.sqrt(surf) );
		
		var width = 1;
		while ( side > width ) width <<= 1;
		
		var height = width;
		while ( width * height >> 1 > surf ) height >>= 1;
		
		var all, bmp;
		
		do {
			bmp = new flash.display.BitmapData(width, height, true, 0);
			bmp.lock();
			
			all = [];
			var m = new flash.geom.Matrix();
			var x = 0, y = 0, lineH = 0;
			
			for ( i in 0...options.chars.length )
			{
				var size = sizes[i];
				
				if ( size == null ) continue;
				
				var w = size.w;
				var h = size.h;
				if ( x + w > width )
				{
					x = 0;
					y += lineH + 1;
				}
				
				// no space, resize
				if ( y + h > height )
				{
					bmp.dispose();
					bmp = null;
					height <<= 1;
					break;
				}
				
				m.tx = x - 2;
				m.ty = y - 2;
				
				//tf.text = options.chars.charAt(i);
				bmp.fillRect(new flash.geom.Rectangle(x, y, w, h), 0);
				mc.gotoAndStop( i + 1 );
				bmp.draw(mc, m);
				
				var t = new h2d.Tile(innerTex, x, y, w - 1, h - 1);
				all.push(t);
				
				//font.glyphs.set(options.chars.charCodeAt(i), new h2d.Font.FontChar(t, w - 1));
				
				// next element
				if( h > lineH ) lineH = h;
				x += w + 1;
			}
			
		}
		while ( bmp == null );
		
		var pixels = hxd.BitmapData.fromNative(bmp).getPixels();
		bmp.dispose();
		
		// let's remove alpha premult (all pixels should be white with alpha)
		pixels.convert(BGRA);
		var r = hxd.impl.Memory.select(pixels.bytes);
		for ( i in 0...pixels.width * pixels.height )
		{
			var p = i << 2;
			var b = r.b(p+3);
			if ( b > 0 )
			{
				r.wb(p, 0xFF);
				r.wb(p + 1, 0xFF);
				r.wb(p + 2, 0xFF);
				r.wb(p + 3, b);
			}
		}
		r.end();
		if ( innerTex == null )
		{
			innerTex = h3d.mat.Texture.fromPixels(pixels);
			tile = h2d.Tile.fromTexture(innerTex);
			
			for( t in all ) t.setTexture(innerTex);
			
			innerTex.realloc = function() { mcToDisplay2dAnim( mc, scale, innerTex ); };
		}
		else innerTex.uploadPixels( pixels );
		
		pixels.dispose();
		
		
		
		
		
		
		
		var spr = new Anim( mc.totalFrames, 1000/SysManager.FRAME_DELAY, systemManager.sysGraphic.s2d );
		var bmp = new h2d.Bitmap(tile, spr);
		
		
		var ca:CompDisplay2dAnim = new CompDisplay2dAnim( spr );
		ca.addAnim( );
		
		//TileGroup.
		
		/*var anim:Anim = new Anim( mc.totalFrames, 1000 / SysManager.FRAME_DELAY, systemManager.sysGraphic.s2d );
		var bmp2 = new Bitmap(tile, spr2);
		e2.display = new CompDisplay2dSprite( spr2 );*/
	}
	
	
	
}