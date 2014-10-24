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
	public var bounds:DRect;
	
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
	
	static function mcToCache( mc:MovieClip, textScale:Float, quality:Float ):AnimCache
	{
		var list:Array<AnimData> = [];
		
		
		var m:Matrix = new Matrix();
		m.createBox( textScale * quality, textScale * quality, 0, 0, 0 );
		
		var label:String = null;
		var animData:AnimData = null;
		
		//var boundLimits = new Rectangle(Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY, Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY );
		var boundLimits = new DRect( 0xFFFFFF, 0xFFFFFF, -0xFFFFFF, -0xFFFFFF );
		
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
			if ( bb.x < boundLimits.x ) boundLimits.x = bb.x;
			if ( bb.y < boundLimits.y ) boundLimits.y = bb.y;
			if ( bb.w > boundLimits.w ) boundLimits.w = bb.w;
			if ( bb.h > boundLimits.w ) boundLimits.h = bb.h;
			
			bbs[i] = bb;
			
			var bd = new flash.display.BitmapData( Math.floor(bb.w * textScale), Math.floor(bb.h * textScale), true, 0x00FFFFFF );
			m.createBox( textScale * quality, textScale * quality, 0, -Math.ceil(bb.x), -Math.ceil(bb.y) );
			
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
			ts[i].setPos( boundLimits.x - bbs[i].x, boundLimits.y - bbs[i].y );
		}
		
		var c = new AnimCache();
		c.bounds = boundLimits;
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
		
		var d = new Display2dAnim( anim, r.bounds/*r.width * textScale*/ );
		
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