package dune.model.factory;
import dune.entity.Entity;
import dune.system.SysManager;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.display.Shader;
import flash.display.Shape;
import h2d.Sprite;

/**
 * ...
 * @author Namide
 */
class LevelFactory
{
	var _sm:SysManager;

	
	
	public function new( sm:SysManager ) 
	{
		_sm = sm;
	}
	
	public function construct( mc:MovieClipData ):Void
	{
		analyseObject( mc, _sm.sysGraphic.camera2d.display );
	}
	
	function analyseObject( obj:DisplayObject, target:h2d.Sprite ):Bool
	{
		if ( Std.is( obj, flash.display.DisplayObjectContainer ) )
		{
			
			if ( Std.is( obj, MovieClipData ) )
			{
				var mcd = cast( obj, MovieClipData );
				//if ( mc.dType != null ) trace( mc.dType );
				
				mcd.gotoAndStop(1);
				if ( mcd.type == "level" )
				{
					//_sm.settings.autoLimit = false;
					_sm.settings.limitXMin = mcd.x;
					_sm.settings.limitYMin = mcd.y;
					_sm.settings.limitXMax = mcd.x + mcd.datas.w;
					_sm.settings.limitYMax = mcd.y + mcd.datas.h;
				}
				if ( mcd.type == "player" )
				{
					mcd.parent.removeChild( mcd );
					construcPlayer( mcd );
					return false;
				}
				else if ( mcd.type == "wall" )
				{
					mcd.parent.removeChild( mcd );
					constructWall( mcd );
					return false;
				}
				else if ( mcd.type == "platform" )
				{
					mcd.parent.removeChild( mcd );
					constructPF( mcd );
					return false;
				}
				else if ( mcd.type == "layer" )
				{
					mcd.parent.removeChild( mcd );
					var targetChild = constructLayer( mcd, target );
					
					var i = 0;
					while ( i<mcd.numChildren )
					{
						var childMC = mcd.getChildAt(i);
						var isd = analyseObject( childMC, target );
						if ( isd )
						{
							i++;
						}
					}
					
					return false;
				}
				
			}
			
			var isDrawable = false;
			
			var objCont = cast( obj, flash.display.DisplayObjectContainer );
			
			var i = 0;
			while ( i<objCont.numChildren )
			{
				var childMC = objCont.getChildAt(i);
				var isd = analyseObject( childMC, target );
				if ( isd )
				{
					isDrawable = true;
					i++;
				}
			}
			
			if ( isDrawable && Std.is( obj, MovieClip ) )
			{
				var mc = cast( obj, MovieClip );
				if ( mc.parent != null ) mc.parent.removeChild( mc );
				constructGraphic( mc, target );
				return false;
			}
		}
		
		return true;// constructGraphic( obj );
	}
	
	function construcPlayer( mcd:MovieClipData ):Void
	{
		var p = new Entity();
		p.transform.x = mcd.x;
		p.transform.y = mcd.y;
		var size = [Std.int(mcd.datas.width), Std.int(mcd.datas.height)];
		
			// graphic
			
				//var spr3 = new h2d.Sprite( systemManager.sysGraphic.s2d );
				//var bmp3 = new h2d.Bitmap(tile, spr3);
				//e3.display = new CompDisplay2dSprite( spr3 );
				p.display = DisplayFactory.mcToDisplay2dAnim( mcd, _sm, 1 );//EntityFactory.getSolidDisplay( systemManager, size[0], size[1] );
				p.display.width = size[0];
				
			// gravity
			
				//var g3:dune.model.controller.ControllerGravity = new ControllerGravity( 0, systemManager.settings.gravity );
				//e3.addController( new ControllerGravity() );
				
			// collision
			
				var b3 = new dune.system.physic.component.Body();
				b3.typeOfCollision = dune.system.physic.component.BodyType.COLLISION_TYPE_ACTIVE;
				b3.typeOfSolid = dune.system.physic.component.BodyType.SOLID_TYPE_MOVER;
				b3.insomniac = true;
				var psr3 = new dune.system.physic.shapes.ShapeRect();
				psr3.w = size[0];
				psr3.h = size[1];
				b3.shape = psr3;
				p.addBody( b3 );
			
			// Inputs
			
				p.input = new dune.component.MultiInput( new dune.input.KeyboardHandler(), new dune.input.GamepadJsHandler() );
			
			// Platform controller
			
				var i3 = new dune.model.controller.ControllerPlatformPlayer( _sm );
				//i3.groundVX = 5;
				p.addController( i3 );
			
			// Camera traking
			
				var ct = new dune.model.controller.ControllerCamera2dTracking( _sm );
				//ct.setAnchor( size[0] >> 1, size[1] >> 1 );
				p.addController( ct );
			
			
		_sm.addEntity( p );
	}
	
	function constructWall( mc:MovieClip ):Void
	{
		EntityFactory.addSolidEmpty( _sm, mc.x, mc.y, mc.width, mc.height, dune.system.physic.component.BodyType.SOLID_TYPE_WALL );
	}
	
	function constructPF( mc:MovieClip ):Void
	{
		EntityFactory.addSolidEmpty( _sm, mc.x, mc.y, mc.width, mc.height, dune.system.physic.component.BodyType.SOLID_TYPE_PLATFORM );
	}
	
	function constructLayer( mc:MovieClipData, target:h2d.Sprite ):h2d.Sprite
	{
		var layer = DisplayFactory.mcToSprite( mc, _sm, 1 );
		//target.addChild( layer );
		
		_sm.sysGraphic.camera2d.addLayer( layer, mc.datas.w, mc.datas.h );
		return layer;
	}
	
	function constructGraphic( mc:MovieClip, target:h2d.Sprite ):Void
	{
		target.addChild( DisplayFactory.mcToSprite( mc, _sm, 1 ) );
	}
	
	/*function constructAnim( mc:MovieClip, target:h2d.Sprite = null ):Void
	{
		target.addChild( DisplayFactory.mcToSprite( mc, _sm, 1 ) );
	}*/
}