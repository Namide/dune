package dune.helpers.display;

import dune.system.graphic.components.CompDisplay2dAnim;
import dune.system.Settings;
import dune.system.SysManager;
import flash.geom.Matrix;
import flash.geom.Rectangle;
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
class DisplayFact
{

	public function new() 
	{
		throw "Static class!";
	}
	
	public static function movieClipToDisplay2dAnim( mc:MovieClip, sm:SysManager, scale:Float = 1 ):CompDisplay2dAnim
	{
		//var tileGroup:TileGroup;
		
		var anim:Anim = new Anim( null, Settings.FRAME_ANIM, sm.sysGraphic.s2d );
		var d:CompDisplay2dAnim = new CompDisplay2dAnim( anim );
		
		var m:Matrix = new Matrix();
		var a:Array<Tile> = [];
		//var animator:Animator2D = new Animator2D();
		
		var label:String = mc.currentLabel;
		var first:String = label;
		var animData:AnimData = new AnimData( label, [] );
		
		for ( i in 0...mc.totalFrames )
		{
			m.createBox( scale, scale, 0, 0, 0 );
			mc.gotoAndStop(i + 1);
			
			if ( mc.currentLabel != label )
			{
				label = mc.currentLabel;
				//animator.push( animData );
				d.pushAnimData( animData );
			}
			
			var bd = new flash.display.BitmapData( Math.floor(mc.width), Math.floor(mc.height), true, 0x00FFFFFF );
			bd.draw( mc, m );
			var hbd = hxd.BitmapData.fromNative( bd ); // new hxd.BitmapData(bd.width, bd.height);
			//hbd.setPixels( hxd.P bd.getVector( new Rectangle( 0, 0, bd.width, bd.height ) ) );
			var t:Tile = Tile.fromBitmap( hbd );
			bd.dispose();
			animData.frames.push( t );
		}
		
		anim.frames = animData.frames;
		
		//d.play(first);
		
		//var spr2 = new h2d.Sprite( systemManager.sysGraphic.s2d );
		//var bmp2 = new h2d.Bitmap(tile, spr2);
		//e2.display = new CompDisplay2dSprite( spr2 );
		//e2.display = EntityFact.getSolidDisplay( systemManager, 3*TS, TS );
		
		//var a = new Anim( a, Settings.FRAME_ANIM, sm.sysGraphic.s2d );
		//animator.anim = a;
		
		//d.pushAnimData( 
		
		return d;
	}
	
}