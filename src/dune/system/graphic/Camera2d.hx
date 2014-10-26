package dune.system.graphic;

import dune.system.graphic.Camera2d.Layer;
import dune.system.SysManager;
import h2d.Sprite;

class Layer
{
	public var sprite:Sprite;
	public var x:Float;
	public var y:Float;
	public var z:Float;
	
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
		refresh();
	}
	
	public var wallLimited(default, default):Bool = true;
	
	var _layers:Array<Layer> = [];
	public function addLayer( layerDisplay:Sprite, z:Float ):Void
	{
		var layer = new Layer();
		layer.sprite = layerDisplay;
		layer.x = layerDisplay.x;
		layer.y = layerDisplay.y;
		layer.z = z;
		//trace( 0, display.parent.getChildIndex(display) );
		//trace( 1, display.parent.numChildren );
		//trace( display.parent.getChildIndex(display), display.parent.numChildren );
		display.parent.addChild( layerDisplay );
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
	}
	
	public function refresh():Void
	{
		if ( !_moved ) return;
		
		var eng = _sm.sysGraphic.engine;
		var set = _sm.settings;
		
		var zX = _stageZoom * zoomX;
		var zY = _stageZoom * zoomY;
		
		if ( zX != display.scaleX && zY != display.scaleY )
		{
			display.scaleX = zX;
			display.scaleY = zY;
		}
		
		var pX:Float = x;
		var pY:Float = y;
		
		var scaleX:Float = (pX - (set.width >> 1)) / (Std.int(set.limitXMax - set.limitXMin) - set.width);
		var scaleY:Float = (pY - (set.height >> 1)) / (Std.int(set.limitYMax - set.limitYMin) - set.height);
		//trace(scaleX);
		
		if ( wallLimited && set.width > Std.int(set.limitXMax - set.limitXMin) )
		{
			//pX = set.limitXMin - ( ( ( set.width - Std.int(set.limitXMax - set.limitXMin) ) >> 1 ) );
			scaleX = 0.5;
		}
		else
		{
			scaleX = (scaleX<0)?0:(scaleX>1)?1:scaleX;
			
			var min = set.limitXMin + (set.width >> 1);
			var max = set.limitXMax - (set.width >> 1);
			
			pX = min + scaleX * ( max - min ) - (set.width >> 1);
			/*pX = pX - (set.width >> 1);
			if ( pX < set.limitXMin ) pX = set.limitXMin;
			if ( pX > Std.int(set.limitXMax) - set.width ) pX = Std.int(set.limitXMax) - set.width;*/
		}
		
		if ( wallLimited && set.height > Std.int(set.limitYMax - set.limitYMin) )
		{
			//pY = set.limitYMin - ( ( ( set.height - Std.int(set.limitYMax - set.limitYMin) ) >> 1 ) );
			scaleY = 0.5;
		}
		else
		{
			scaleY = (scaleY<0)?0:(scaleY>1)?1:scaleY;
			
			var min = set.limitYMin + (set.height >> 1);
			var max = set.limitYMax - (set.height >> 1);
			
			pY = min + scaleY * ( max - min ) - (set.height >> 1);
			
			/*pY = pY - (set.height >> 1);
			if ( pY < set.limitYMin ) pY = set.limitYMin;
			if ( pY > Std.int(set.limitYMax) - set.height ) pY = Std.int(set.limitYMax) - set.height;*/
		}
		
		pX += set.width >> 1;
		pY += set.height >> 1;
		
		pX = -pX * zX;
		pY = -pY * zY;
		
		pX += eng.width >> 1;
		pY += eng.height >> 1;
		
		display.x = Math.round(pX);
		display.y = Math.round(pY);
		
		//pX -= ;
		//pX -= ;
		
		for ( layer in _layers )
		{
			layer.sprite.setPos( 	-pX * layer.z + layer.x,
									-pY * layer.z + layer.y );
			//layer.sprite.scale( 0.5 * (display.scaleX + display.scaleY) * layer.z );
		}
		
		_moved = false;
	}
	
	public inline function setPos( x:Float, y:Float ):Void
	{
		this.x = x;
		this.y = y;
		//display.setPos( -x, -y );
	}
	
}