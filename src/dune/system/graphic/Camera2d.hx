package dune.system.graphic;

import dune.system.graphic.Camera2d.Layer;
import dune.system.SysManager;
import h2d.Sprite;

class Layer
{
	public var sprite:Sprite;
	public var x:Float;
	public var y:Float;
	//public var z:Float;
	
	public var w:Int;
	public var h:Int;
	
	public function new () { }
}

/**
 * ...
 * @author Namide
 */
class Camera2d
{
	public var display(default, null):Sprite;
	
	var _moved:Bool = false;
	
	public var x(default, set):Float = 0;
	inline function set_x(val:Float):Float
	{
		if ( x == val ) return val;
		x = val;
		_moved = true;
		return val;
	}
	
	public var y(default, set):Float = 0;
	inline function set_y(val:Float):Float
	{
		if ( y == val ) return val;
		y = val;
		_moved = true;
		return val;
	}
	
	public inline function zoom( val:Float ):Void
	{
		zoomY = val;
		zoomY = val;
		_moved = true;
		//display.scale(val);
	}
	
	public var zoomX(default, set):Float = 1;
	inline function set_zoomX(val:Float):Float
	{
		if ( val == zoomX ) return val;
		zoomX = val;
		_moved = true;
		return val;
	}
	
	public var zoomY(default, set):Float = 1;
	inline function set_zoomY(val:Float):Float
	{
		if ( val == zoomY ) return val;
		zoomY = val;
		_moved = true;
		return zoomY;
	}
	
	var _stageZoom:Float = 1;
	public function stageZoom( zoom:Float ):Void
	{
		if ( zoom == _stageZoom ) return;
		_stageZoom = zoom;
		_moved = true;
	}
	
	public var wallLimited(default, default):Bool = true;
	
	var _layers:Array<Layer> = [];
	public function addLayer( layerDisplay:Sprite, w:Int, h:Int ):Void
	{
		var layer = new Layer();
		layer.sprite = new h2d.Sprite( _sm.sysGraphic.s2d );
		layer.x = layerDisplay.x;
		layer.y = layerDisplay.y;
		
		layer.w = w;
		layer.h = h;
		
		//layer.z = z;
		//trace( 0, display.parent.getChildIndex(display) );
		//trace( 1, display.parent.numChildren );
		//trace( display.parent.getChildIndex(display), display.parent.numChildren );
		display.parent.addChild( layerDisplay );
		layer.sprite.addChild( layerDisplay );
		display.parent.addChild( display );
		
		//layerDisplay.parent.removeChild( layerDisplay ); //parent.remove();
		//display.parent.addChildAt( layerDisplay, display.parent.numChildren - 2 );
		
		_layers.push(layer);
		
		_moved = true;
	}
	
	var _sm:SysManager;
	
	public function new( sm:SysManager, ?parent:Sprite) 
	{
		_sm = sm;
		display = new Sprite(parent);
		_moved = true;
		
		//_sm.sysGraphic.s3d.camera.target.x =
		//_sm.sysGraphic.s3d.camera.target.y = 0;
		//_sm.sysGraphic.s3d.camera.target.z = ;
		
		
		_sm.sysGraphic.s3d.camera.zNear = 1;
		_sm.sysGraphic.s3d.camera.zFar = 1000;
		
		_sm.sysGraphic.s3d.camera.pos.set( 0, 0, 0, 1 );
		_sm.sysGraphic.s3d.camera.target.set( 0, 0, -1000 );
		_sm.sysGraphic.s3d.camera.up.set( 0, -100, 0 );
	}
	
	public function refresh():Void
	{
		if ( !_moved ) return;
		
		//var eng = _sm.sysGraphic.engine;
		var set = _sm.settings;
		
		var W = Std.int(set.limitXMax - set.limitXMin);
		var H = Std.int(set.limitYMax - set.limitYMin);
		
		var scaleX:Float = (x - (set.width >> 1)) / (W - set.width);
		var scaleY:Float = (y - (set.height >> 1)) / (H - set.height);
		scaleX = (scaleX < 0) ? 0 : (scaleX > 1) ? 1 : scaleX;
		scaleY = (scaleY < 0) ? 0 : (scaleY > 1) ? 1 : scaleY;
		
		appliTransform( display, scaleX, scaleY, Math.floor(set.limitXMin), Math.floor(set.limitYMin), Math.ceil(set.limitXMax), Math.ceil(set.limitYMax) );
		_sm.sysGraphic.s3d.camera.pos.x = 
		_sm.sysGraphic.s3d.camera.target.x = (scaleX - 0.5) * W * 0.1;
		
		_sm.sysGraphic.s3d.camera.pos.y = 
		_sm.sysGraphic.s3d.camera.target.y = (scaleY - 0.5) * H * 0.1;
		
		//trace( scaleX, scaleY );
		
		//_sm.sysGraphic.s3d.camera.target.x = (scaleX - 0.5) * W;
		//_sm.sysGraphic.s3d.camera.target.y = (scaleY - 0.5) * H;
		//trace( scaleX * set.width, scaleY * set.height, _sm.sysGraphic.s3d.camera.target.x );
		
		//pX -= ;
		//pX -= ;
		for ( layer in _layers )
		{
			/*layer.sprite.setPos( 	-pX * layer.z + layer.x,
									-pY * layer.z + layer.y );*/
			appliLayerTransform( layer.sprite, scaleX, scaleY, layer.w, layer.h );
		}
		
		_moved = false;
	}
	
	public inline function appliLayerTransform( sprite:Sprite, scaleX:Float, scaleY:Float, maxX:Int, maxY:Int ):Void
	{
		var eng = _sm.sysGraphic.engine;
		var set = _sm.settings;
		
		// SCALE
		var zX = _stageZoom * zoomX;
		var zY = _stageZoom * zoomY;
		if ( zX != sprite.scaleX && zY != sprite.scaleY )
		{
			sprite.scaleX = zX;
			sprite.scaleY = zY;
		}
		
		// POSITION
		var realW:Int = Math.ceil( zX * maxX );
		var realH:Int = Math.ceil( zY * maxY );
		
		var pX = Math.ceil( scaleX * ( (eng.width - realW) >> 1) );
		var pY = Math.ceil( scaleY * ( (eng.height - realH) >> 1) );
		
		sprite.x = pX;
		sprite.y = pY;
	}
	
	public inline function appliTransform( sprite:Sprite, scaleX:Float, scaleY:Float, minX:Int, minY:Int, maxX:Int, maxY:Int ):Void
	{
		var eng = _sm.sysGraphic.engine;
		var set = _sm.settings;
		
		// SCALE
		var zX = _stageZoom * zoomX;
		var zY = _stageZoom * zoomY;
		if ( zX != sprite.scaleX && zY != sprite.scaleY )
		{
			sprite.scaleX = zX;
			sprite.scaleY = zY;
		}
		
		// POSITION
		var pX:Int = 0;
		var pY:Int = 0;
		
		if ( wallLimited && set.width > maxX - minX )
		{
			scaleX = 0.5;
		}
		else
		{
			scaleX = (scaleX<0)?0:(scaleX>1)?1:scaleX;
			
			var min = minX + (set.height >> 1);
			var max = maxX - (set.height >> 1);
			
			pX = min + Std.int(scaleX * ( max - min )) - (set.height >> 1);
		}
		
		if ( wallLimited && set.height > Std.int(set.limitYMax - set.limitYMin) )
		{
			scaleY = 0.5;
		}
		else
		{
			scaleY = (scaleY<0)?0:(scaleY>1)?1:scaleY;
			
			var min = minY + (set.height >> 1);
			var max = maxY - (set.height >> 1);
			
			pY = min + Std.int(scaleY * ( max - min )) - (set.height >> 1);
		}
		
		pX += set.width >> 1;
		pY += set.height >> 1;
		
		pX = Math.round(-pX * zX);
		pY = Math.round(-pY * zY);
		
		pX += eng.width >> 1;
		pY += eng.height >> 1;
		
		sprite.x = pX;
		sprite.y = pY;
	}
	
	public inline function setPos( x:Float, y:Float ):Void
	{
		this.x = x;
		this.y = y;
		//display.setPos( -x, -y );
	}
	
}