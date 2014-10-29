package dune.model.factory ;

import dune.model.factory.DisplayFactory.SpriteRes;
import dune.system.graphic.component.Display2dAnim;
import dune.system.graphic.component.Display2dSprite;
import dune.system.Settings;
import dune.system.SysManager;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
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

class _AnimRes
{
	public var animDatas:Array<AnimData>;
	public var mcName:String;
	public var width:Float;
	
	public function new() { }
}

class _SpriteRes
{
	public var tile:h2d.Tile;
	public var mcName:String;
	
	public function new() { }
}

class _SpriteDatas
{
	public var sprite:h2d.Sprite;
	public var bitmap:h2d.Bitmap;
	
	public function new() { }
}

/**
 * ...
 * @author Namide
 */
class _DisplayFactory
{
	static var _resAnims:Array<AnimRes> = [];
	static var _resTiles:Array<SpriteRes> = [];
	//static var _res
	
	public static function clear():Void
	{
		_resAnims = [];
		_resTiles = [];
	}
	
	public function new() 
	{
		throw "Static class!";
	}
	
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
			
			//var bd = new flash.display.BitmapData( Math.floor(mc.width * textScale), Math.floor(mc.height * textScale), true, 0x00FFFFFF );
			
			var bb = mc.getBounds( mc );
			var bd = new flash.display.BitmapData( Math.floor(bb.width * textScale), Math.floor(bb.height * textScale), true, 0x00FFFFFF );
			m.createBox( textScale * quality, textScale * quality, 0, -Math.ceil(bb.x), -Math.ceil(bb.y) );
			
			bd.draw( mc, m );
			var hbd = hxd.BitmapData.fromNative( bd );
			var t:Tile = Tile.fromBitmap( hbd );
			t.setPos( -Math.ceil(bb.x), -Math.ceil(bb.y) );
			
			//t.setSize( Math.round(t.width * quality), Math.round(t.height * quality) );
			//t.setSize( 256, 256 );
			//trace(t.width);
			
			bd.dispose();
			animData.frames.push( t );
		}
		
		return list;
	}
	
	public static function assetMcToSprite( mcName:String, sm:SysManager, textScale:Float, quality:Float = null ):SpriteDatas
	{
		if ( quality == null ) quality = sm.settings.textDefinition;
		
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
	}
	
	public static function assetMcToDisplay2d( mcName:String, sm:SysManager, textScale:Float, quality:Float = null ):Display2dSprite
	{
		if ( quality == null ) quality = sm.settings.textDefinition;
		
		var spr = assetMcToSprite( mcName, sm, textScale, quality ).sprite;
		var d = new Display2dSprite( spr );
		return d;
	}
	
	public static function assetMcToAnim( mcName:String, sm:SysManager, textScale:Float, labelNum:Int = 0 , quality:Float = null ):Anim
	{
		if ( quality == null ) quality = sm.settings.textDefinition;
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
	}
	
	public static function assetMcToDisplay2dAnim( mcName:String, sm:SysManager, textScale:Float, quality:Float = null ):Display2dAnim
	{
		if ( quality == null ) quality = sm.settings.textQuality;
		var anim:Anim = new Anim( null, Lib.current.stage.frameRate , sm.sysGraphic.s2d );
		anim.setScale( 1 / quality );
		
		var r:AnimRes = Lambda.find( _resAnims, function( r:AnimRes ):Bool { return r.mcName == mcName; } );
		if ( r == null )
		{
			r = new AnimRes();
			r.mcName = mcName;
			var mc:MovieClip = Lib.attach( mcName );
			r.width = mc.width;
			r.animDatas = movieClipToTiles( mc, textScale, quality );
			_resAnims.push( r );
		}
		
		var a:Array<AnimData> = r.animDatas;
		
		var d:Display2dAnim = new Display2dAnim( anim, r.width * textScale );
		
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
	}
	
}