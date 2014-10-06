package dune.model.factory ;

import dune.system.graphic.component.Display2dAnim;
import dune.system.Settings;
import dune.system.SysManager;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.Lib;
import h2d.Anim;
import flash.display.MovieClip;
import h2d.Sprite;
import h2d.Tile;
import h2d.TileGroup;
import hxd.BitmapData;



/**
 * ...
 * @author Namide
 */
class DisplayFactory
{

	public function new() 
	{
		throw "Static class!";
	}
	
	/*static function movieClipToSpriteSheet( mc:MovieClip, innerTex:h3d.mat.Texture, scale:Float = 1.0 ):Array<AnimData>
	{
		var tile : Tile;
		
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
			
			innerTex.realloc = function() { movieClipToSpriteSheet( mc, innerTex, scale ); };
		}
		else innerTex.uploadPixels( pixels );
		
		pixels.dispose();
		
		
		var spr = new Anim( mc.totalFrames, 1000/SysManager.FRAME_DELAY, systemManager.sysGraphic.s2d );
		var bmp = new h2d.Bitmap(tile, spr);
		
		var ca:Display2dAnim = new Display2dAnim( spr );
		ca.addAnim( );
	}*/
	
	static function movieClipToTiles( mc:MovieClip, textScale:Float, quality:Float ):Array<AnimData>
	{
		var list:Array<AnimData> = [];
		
		
		var m:Matrix = new Matrix();
		m.createBox( textScale * quality, textScale * quality, 0, 0, 0 );
		
		var label:String = null;
		var animData:AnimData = null;
		
		for ( i in 0...mc.totalFrames )
		{
			mc.gotoAndStop(i + 1);
			
			if ( mc.currentLabel != label )
			{
				animData = new AnimData( mc.currentLabel, [] );
				
				label = mc.currentLabel;
				list.push( animData );
			}
			
			var bd = new flash.display.BitmapData( Math.floor(mc.width), Math.floor(mc.height), true, 0x00FFFFFF );
			bd.draw( mc, m );
			var hbd = hxd.BitmapData.fromNative( bd ); 
			var t:Tile = Tile.fromBitmap( hbd );
			//t.setSize( Math.round(t.width * quality), Math.round(t.height * quality) );
			//t.setSize( 256, 256 );
			//trace(t.width);
			
			bd.dispose();
			animData.frames.push( t );
		}
		
		return list;
	}
	
	public static function movieClipToDisplay2dAnim( mc:MovieClip, sm:SysManager, textScale:Float, quality:Float = Settings.TEXT_QUALITY ):Display2dAnim
	{
		var anim:Anim = new Anim( null, Lib.current.stage.frameRate , sm.sysGraphic.s2d );
		anim.setScale( 1 / quality );
		var d:Display2dAnim = new Display2dAnim( anim, mc.width * textScale );
		
		var first:String = mc.currentLabel;
		var a:Array<AnimData> = movieClipToTiles( mc, textScale, quality );
		
		for ( ad in a )
		{
			d.pushAnimData( ad );
		}
		
		d.play(first);
		
		return d;
	}
	
}