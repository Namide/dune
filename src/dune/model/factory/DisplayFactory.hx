package dune.model.factory ;

import dune.helper.core.DRect;
import dune.system.graphic.component.Display2dAnim;
import dune.system.graphic.component.Display2dSprite;
import dune.system.Settings;
import dune.system.SysManager;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.Lib;
import h2d.Anim;
import flash.display.MovieClip;
import h2d.Bitmap;
import h2d.Drawable;
import h2d.Sprite;
import h2d.Tile;
import h2d.TileGroup;
import h3d.impl.AllocPos;
import hxd.BitmapData;

/*class AnimRes
{
	public var animDatas:Array<AnimData>;
	public var mcName:String;
	public var width:Float;
	
	public function new() { }
}

class SpriteRes
{
	public var tile:h2d.Tile;
	public var mcName:String;
	
	public function new() { }
}

class SpriteDatas
{
	public var sprite:h2d.Sprite;
	public var bitmap:h2d.Bitmap;
	
	public function new() { }
}*/

class AnimCache
{
	public var mcClassName:String;
	public var mc:MovieClip;
	
	public var animDatas:Array<AnimData>;
	//public var width:Float;
	//public var bounds:DRect;
	
	public function new() { }
}

/**
 * ...
 * @author Namide
 */
class DisplayFactory
{
	static var _cache:Array<AnimCache> = [];
	//static var _resTiles:Array<SpriteRes> = [];
	//static var _res
	
	public static function clear():Void
	{
		_cache = [];
	}
	
	public function new() 
	{
		throw "Static class!";
	}
	
	/*
		OPTIMAL TEXTURE
	
	public static function mcToDisplay2dAnim( mc:MovieClip, scale:Float = 1.0, innerTex:Texture ):ComponentAnim
	{
		var tile:Tile;
		
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
	}*/
	
	
	
	
	
	static function mcToCache( mc:MovieClip, textScale:Float, quality:Float ):AnimCache
	{
		var list:Array<AnimData> = [];
		
		var m:Matrix = new Matrix();
		//m.createBox( textScale * quality, textScale * quality, 0, 0, 0 );
		
		var label:String = null;
		var animData:AnimData = null;
		
		//var boundLimits = new Rectangle(Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY, Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY );
		//var boundLimits = new DRect( 0xFFFFFF, 0xFFFFFF, -0xFFFFFF, -0xFFFFFF );
		
		var bbs = new Array<DRect>();
		var ts = new Array<Tile>();
		for ( i in 0...mc.totalFrames )
		{
			mc.gotoAndStop(i + 1);
			
			if ( mc.currentLabel != label )
			{
				animData = new AnimData( mc.currentLabel, [] );
				
				label = mc.currentLabel;
				list.push( animData );
			}
			
			//var bd = new flash.display.BitmapData( Math.floor(mc.width * textScale), Math.floor(mc.height * textScale), true, 0x00FFFFFF );
			
			var bb = DRect.fromFlashRect( mc.getBounds( mc ) );
			/*mc.getBounds( mc );*/
			/*if ( bb.x < boundLimits.x ) boundLimits.x = bb.x;
			if ( bb.y < boundLimits.y ) boundLimits.y = bb.y;
			if ( bb.w > boundLimits.w ) boundLimits.w = bb.w;
			if ( bb.h > boundLimits.w ) boundLimits.h = bb.h;*/
			
			bbs[i] = bb;
			
			var bd = new flash.display.BitmapData( Math.floor(bb.w * textScale), Math.floor(bb.h * textScale), true, 0x00FFFFFF );
			m.createBox( textScale * quality, textScale * quality, 0, -Math.ceil(bb.x * quality), -Math.ceil(bb.y * quality) );
			
			bd.draw( mc, m );
			var hbd = hxd.BitmapData.fromNative( bd );
			var t:Tile = Tile.fromBitmap( hbd );
			//t.setPos( -Math.ceil(bb.x), -Math.ceil(bb.y) );
			
			ts[i] = t;
			
			bd.dispose();
			animData.frames.push( t );
		}
		
		for ( i in 0...ts.length )
		{
			//ts[i].setPos( boundLimits.x - bbs[i].x, boundLimits.y - bbs[i].y );
			ts[i].dx = Math.round(bbs[i].x * quality);
			ts[i].dy = Math.round(bbs[i].y * quality);
		}
		
		var c = new AnimCache();
		//c.bounds = boundLimits;
		c.animDatas = list;
		
		return c;
	}
	
	/*public static function assetMcToSprite( mcName:String, sm:SysManager, textScale:Float, quality:Float = null ):SpriteDatas
	{
		if ( quality == null ) quality = sm.settings.textQuality;
		
		var r:SpriteRes = Lambda.find( _resTiles, function( r:SpriteRes ):Bool { return r.mcName == mcName; } );
		if ( r == null )
		{
			r = new SpriteRes();
			r.mcName = mcName;
			
			var mc:MovieClip = Lib.attach( mcName );
			var bmpd = new flash.display.BitmapData( Math.ceil(mc.width * textScale), Math.ceil(mc.height * textScale), true, 0x00FFFFFF );
			var m = new Matrix();
			m.createBox( textScale, textScale );
			bmpd.draw( mc, m );
			r.tile = Tile.fromBitmap( hxd.BitmapData.fromNative(bmpd) );
		}
		
		var sd = new SpriteDatas();
		sd.sprite = new h2d.Sprite( sm.sysGraphic.s2d );
		sd.bitmap = new h2d.Bitmap(r.tile, sd.sprite);
		return sd;
	}*/
	
	/*public static function assetMcToDisplay2d( mcName:String, sm:SysManager, textScale:Float, quality:Float = null ):Display2dSprite
	{
		if ( quality == null ) quality = sm.settings.textQuality;
		
		var spr = assetMcToSprite( mcName, sm, textScale, quality ).sprite;
		var d = new Display2dSprite( spr );
		return d;
	}*/
	
	/*public static function assetMcToAnim( mcName:String, sm:SysManager, textScale:Float, labelNum:Int = 0 , quality:Float = null ):Anim
	{
		if ( quality == null ) quality = sm.settings.textQuality;
		var anim:Anim = new Anim( null, Lib.current.stage.frameRate , sm.sysGraphic.s2d );
		anim.setScale( 1 / quality );
		
		var r:AnimRes = Lambda.find( _resAnims, function( r:AnimRes ):Bool { return r.mcName == mcName; } );
		if ( r == null )
		{
			//trace("recup");
			r = new AnimRes();
			r.mcName = mcName;
			var mc:MovieClip = Lib.attach( mcName );
			r.width = mc.width;
			r.animDatas = movieClipToTiles( mc, textScale, quality );
			_resAnims.push( r );
		}
		
		anim.play( r.animDatas[labelNum].frames );
		return anim;
	}*/
	
	public static function assetMcToDisplay2dAnim( mcClassName:String, sm:SysManager, textScale:Float, quality:Float = null ):Display2dAnim
	{
		if ( quality == null ) quality = sm.settings.textQuality;
		var anim:Anim = new Anim( null, Lib.current.stage.frameRate , sm.sysGraphic.s2d );
		anim.setScale( 1 / quality );
		
		var r:AnimCache = Lambda.find( _cache, function( r:AnimCache ):Bool { return r.mcClassName == mcClassName; } );
		if ( r == null )
		{
			r = mcToCache( Lib.attach( mcClassName ), textScale, quality );//new AnimCache();
			r.mcClassName = mcClassName;
			//var mc:MovieClip = Lib.attach( mcName );
			//r.width = mc.width;
			//r.animDatas = 
			_cache.push( r );
		}
		
		var a:Array<AnimData> = r.animDatas;
		
		var d = new Display2dAnim( anim /*r.width * textScale*/ );
		
		for ( ad in a )
		{
			d.pushAnimData( ad );
		}
		
		d.play( a[0].label );
		
		return d;
	}
	
	
	
	/*public static function movieClipToDisplay2dAnim( mc:MovieClip, sm:SysManager, textScale:Float, quality:Float = null ):Display2dAnim
	{
		if ( quality == null ) quality = sm.settings.textQuality;
		
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
	}*/
	
}