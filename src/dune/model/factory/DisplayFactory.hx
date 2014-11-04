package dune.model.factory ;

import dune.helper.core.DRect;
import dune.system.graphic.component.Display2dAnim;
import dune.system.graphic.component.Display2dSprite;
import dune.system.Settings;
import dune.system.SysManager;
import flash.display.StageQuality;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.Lib;
import h2d.Anim;
import flash.display.MovieClip;
import h2d.Bitmap;
import h2d.Drawable;
import h2d.Graphics;
import h2d.Sprite;
import h2d.Tile;
import h2d.TileGroup;
import h3d.anim.Animation;
import h3d.impl.AllocPos;
import h3d.mat.BlendMode;
import h3d.mat.Data.MipMap;
import h3d.mat.Data.TextureFlags;
import h3d.mat.Data.Wrap;
import h3d.mat.Material;
import h3d.mat.MeshMaterial;
import h3d.mat.Pass;
import h3d.mat.Texture;
import h3d.prim.Polygon;
import h3d.prim.Primitive;
import h3d.prim.UV;
import h3d.scene.Mesh;
import h3d.scene.Object;
import h3d.shader.BaseMesh;
import h3d.shader.VertexColor;
import hxd.BitmapData;
import hxd.fmt.fbx.Filter;
import hxd.IndexBuffer;
import hxd.Math;
import hxsl.ShaderList;

class AnimCache
{
	public var mcClassName:String;
	public var mc:MovieClip;
	
	public var animDatas:Array<AnimData>;
	
	public function new() { }
}

/**
 * ...
 * @author Namide
 */
class DisplayFactory
{
	static var _cache:Array<AnimCache> = [];
	
	public static function clear():Void
	{
		_cache = [];
	}
	
	public static function getBackground( sm:SysManager, w:Float, h:Float, p:Float ):h3d.scene.Object
	{
		var o = new h3d.scene.Object(sm.sysGraphic.s3d);
		
		
		var floor = new h3d.prim.Cube(w, h, 0.1);
		floor.addNormals();
		floor.translate( -w*0.5, -h*0.5, -(0.1+p) );
		var floorMesh = new h3d.scene.Mesh( floor, o );
		floorMesh.material.color.set( 0.0, 0.5, 0.5 );
		floorMesh.material.mainPass.enableLights = true;
		floorMesh.material.shadows = true;

		
		/*var pts = new Array<h3d.col.Point>();
		var idx = new hxd.IndexBuffer();
		var uvs = new Array<h3d.prim.UV>();
		
		var uv00 = new h3d.prim.UV(0, 0);
		var uv01 = new h3d.prim.UV(0, 1);
		var uv10 = new h3d.prim.UV(1, 0);
		var uv11 = new h3d.prim.UV(1, 1);
		
		var s:Float = 6;
		for ( i in 0...1 )
		{
			var x = Math.random( w );
			var y = Math.random( h );
			var z = Math.random( p );
			
			var i = pts.length;
			
			pts.push( new h3d.col.Point( x, 	y, 		z ) );
			pts.push( new h3d.col.Point( x + s, y, 		z ) );
			pts.push( new h3d.col.Point( x + s, y + s, 	z ) );
			pts.push( new h3d.col.Point( x, 	y + s, 	z ) );
			
			idx.push( i ); 		idx.push( i + 1 ); 	idx.push( i + 2 );
			idx.push( i + 2 ); 	idx.push( i + 3 );	idx.push( i );
			
			uvs.push( uv00 ); uvs.push( uv10 ); uvs.push( uv11 );
			uvs.push( uv11 ); uvs.push( uv01 ); uvs.push( uv00 );
		}
		
		
		var poly = new h3d.prim.Polygon( pts, idx );
		poly.unindex();
		poly.uvs = uvs;*/
		
		var poly = new BgTest01( w, h, p );
		poly.addUVs();
		poly.addNormals();
		poly.translate( -w*0.5, -h*0.5, -p );
		
		var mc = Lib.attach("LightUI");
		var bd = new flash.display.BitmapData( Math.round(mc.width), Math.round(mc.height), true, 0x00FFFF00 );
		bd.draw( mc );
		//bd.perlinNoise( 32, 32, 3, 0, false, true );
		
		
		var m2 = new h3d.mat.MeshMaterial();
		m2.color.setColor( 0x000000 );
		var vc = new VertexColor();
		//vc.additive = false;
		
		//m2.addPass( new Pass("vertexColor", new ShaderList( vc ), m2.mainPass ) );
		//m2.mainPass = new Pass("vertexColor", new ShaderList( vc ), m2.mainPass );
		for ( s in m2.mainPass.getShaders() )
		{
			m2.mainPass.removeShader( s );
		}
		m2.mainPass.addShader( vc );
		m2.mainPass.addShader( new BaseMesh() );
		
		//m2.mainPass.addShader( new VertexColor() );
		
		
		var mesh = new h3d.scene.Mesh( poly );
		mesh.material = m2;
		o.addChild( mesh );
		
		//mesh.material.blendMode = h3d.mat.BlendMode.;
		//mesh.material.texture = h3d.mat.Texture.fromBitmap( hxd.BitmapData.fromNative(bd) );
		//mesh.material.texture.mipMap = h3d.mat.MipMap.Linear;
		
		
		/*var pass = new Pass( "vertexColor", new ShaderList( new VertexColor() ) );
		mesh.material.mainPass.enableLights = true;
		mesh.material.shadows = true;
		for ( s in mesh.material.mainPass.getShaders() )
		{
			trace(s);
		}*/
		//mesh.material.mainPass. .addShader( new VertexColor() );
		
		//mesh.material.color.setColor( Std.random(0x1000000) );
		
		
		
		/*var sphere = new h3d.prim.Sphere(32,24);
		var cube = new h3d.prim.Cube(1, 1, 1 );
		sphere.addNormals();
		cube.addNormals();
		var spheres  = [];
		for ( i in 0...50 ) {
			var isCube = Std.random(2) > 0;
			var m = ( !isCube ) ? new h3d.scene.Mesh(sphere, o) : new h3d.scene.Mesh(cube, o);
			m.scale(40 + Math.random() * 40);
			m.x = hxd.Math.srand(w * 0.5) - m.scaleX * 0.5;
			m.y = hxd.Math.srand(h * 0.5) - m.scaleY * 0.5;
			m.z = ( ( !isCube ) ? m.scaleZ : 0 ) - ( Math.round(p) - Math.random() * p );
			m.material.mainPass.enableLights = true;
			m.material.shadows = true;
			m.material.color.setColor( Std.random(0x1000000) );
		}*/
		
		return o;
	}
	
	public static function getRect( sm:SysManager, w:Float, h:Float, color:Int = -1 ):h2d.Graphics
	{
		if ( color < 0 ) color = Math.round( 0xFFFFFF * Math.random() );
		
		var g = new h2d.Graphics( sm.sysGraphic.s2d );
		g.beginFill( color );
		//g.lineStyle( 1, Math.round( 0xFFFFFF * Math.random() ) );
		g.drawRect( 0, 0, w, h );
		g.endFill();
		return g;
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
	
	static function mcToCache( mc:MovieClip, textScale:Float, quality:Float, sm:SysManager, forceSizeX:Int = -1, forceSizeY:Int = -1 ):AnimCache
	{
		var list:Array<AnimData> = [];
		//quality = 1;
		var m:Matrix = new Matrix();
		//m.createBox( textScale * quality, textScale * quality, 0, 0, 0 );
		
		var label:String = Std.string( Math.random );
		var animData:AnimData = null;
		
		//var boundLimits = new Rectangle(Math.POSITIVE_INFINITY, Math.POSITIVE_INFINITY, Math.NEGATIVE_INFINITY, Math.NEGATIVE_INFINITY );
		//var boundLimits = new DRect( 0xFFFFFF, 0xFFFFFF, -0xFFFFFF, -0xFFFFFF );
		
		forceSizeX = Math.floor(forceSizeX * textScale * quality);
		forceSizeY = Math.floor(forceSizeY * textScale * quality);
		
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
			
			var sizeX:Int = ( forceSizeX > 0 ) ? forceSizeX : Math.floor(bb.w * textScale * quality);
			var sizeY:Int = ( forceSizeY > 0 ) ? forceSizeY : Math.floor(bb.h * textScale * quality);
			var decalX:Int = ( forceSizeX > 0 ) ? 0 : -Math.ceil(bb.x * quality);
			var decalY:Int = ( forceSizeY > 0 ) ? 0 : -Math.ceil(bb.y * quality);
			
			//trace(forceSizeX, forceSizeY, sizeX, sizeY);
			
			var bd = new flash.display.BitmapData( sizeX, sizeY, true, 0x00FFFFFF );
			m.createBox( textScale * quality, textScale * quality, 0, decalX, decalY );
			
			var q = Lib.current.stage.quality;
			Lib.current.stage.quality = sm.settings.textQuality;
			bd.draw( mc, m, null, null, null, false );
			
			var hbd = hxd.BitmapData.fromNative( bd );
			var t:Tile = Tile.fromBitmap( hbd );
			
			Lib.current.stage.quality = q;
			
			//t.getTexture().filter = new hxd.fmt.fbx.Filter();
			
			//t.getTexture().resize( 60, 60 );
			//t.setPos( -Math.ceil(bb.x), -Math.ceil(bb.y) );
			//t.setSize( bb.w, bb.h );
			
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
	
	public static function mcToSprite( mc:MovieClip, sm:SysManager, textScale:Float, quality:Float = null, forceSizeX:Int = -1, forceSizeY:Int = -1 ):h2d.Sprite
	{
		if ( quality == null ) quality = sm.settings.textDefinition;
		
		var r:AnimCache = Lambda.find( _cache, function( r:AnimCache ):Bool { return r.mcClassName == getName( mc ); } );
		if ( r == null )
		{
			r = mcToCache( mc, textScale, quality, sm, forceSizeX, forceSizeY );//new AnimCache();
			r.mcClassName = getName( mc );
			_cache.push( r );
		}
		
		// NO ANIMATED
		if ( r.animDatas.length < 2 && r.animDatas[0].frames.length < 2 )
		{
			//var sd = new SpriteDatas();
			var sprite = new h2d.Sprite( sm.sysGraphic.s2d );
			sprite.setScale( 1 / quality );
			
			var bitmap = new h2d.Bitmap( r.animDatas[0].frames[0], sprite );
			//bitmap.blendMode = h3d.mat.BlendMode.Alpha;
			
			return bitmap;
		}
		
		// ANIMATED
		var anim:Anim = new Anim( null, Lib.current.stage.frameRate , sm.sysGraphic.s2d );
		anim.setScale( 1 / quality );
		/*var a:Array<AnimData> = r.animDatas;
		var d = new Display2dAnim( anim );
		for ( ad in a )
		{
			d.pushAnimData( ad );
		}
		d.play( a[0].label );*/
		anim.play( r.animDatas[0].frames );
		return anim;
		
		
		
		
		
		/*if ( quality == null ) quality = sm.settings.textQuality;
		
		var r:SpriteRes = Lambda.find( _resTiles, function( r:SpriteRes ):Bool { return r.mcName == getName( mc ); } );
		if ( r == null )
		{
			r = new SpriteRes();
			r.mcName = mcName;
			
			var mc:MovieClip = mc;
			var bmpd = new flash.display.BitmapData( Math.ceil(mc.width * textScale), Math.ceil(mc.height * textScale), true, 0x00FFFFFF );
			var m = new Matrix();
			m.createBox( textScale, textScale );
			bmpd.draw( mc, m );
			r.tile = Tile.fromBitmap( hxd.BitmapData.fromNative(bmpd) );
		}
		
		var sd = new SpriteDatas();
		sd.sprite = new h2d.Sprite( sm.sysGraphic.s2d );
		sd.bitmap = new h2d.Bitmap(r.tile, sd.sprite);
		return sd;*/
	}
	
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
	
	
	
	public static function assetMcToDisplay2dAnim( mcClassName:String, sm:SysManager, textScale:Float, quality:Float = null, forceSizeX:Int = -1, forceSizeY:Int = -1 ):Display2dAnim
	{
		return mcToDisplay2dAnim( Lib.attach( mcClassName ), sm, textScale, quality, forceSizeX, forceSizeY );
	}
	
	public static function mcToDisplay2dAnim( mc:MovieClip, sm:SysManager, textScale:Float, quality:Float = null, forceSizeX:Int = -1, forceSizeY:Int = -1 ):Display2dAnim
	{
		if ( quality == null ) quality = sm.settings.textDefinition;
		var anim:Anim = new Anim( null, Lib.current.stage.frameRate , sm.sysGraphic.s2d );
		anim.setScale( 1 / quality );
		
		var r:AnimCache = Lambda.find( _cache, function( r:AnimCache ):Bool { return r.mcClassName == getName( mc ); } );
		if ( r == null )
		{
			r = mcToCache( mc, textScale, quality, sm, forceSizeX, forceSizeY );//new AnimCache();
			r.mcClassName = getName( mc );
			_cache.push( r );
		}
		
		var a:Array<AnimData> = r.animDatas;
		
		var d = new Display2dAnim( anim );
		
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
	
		static inline function getName( c:Dynamic ):String
		{
			return Type.getClassName( Type.getClass(c) );
		}
	
}