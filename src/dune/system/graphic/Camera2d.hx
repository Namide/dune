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
	
	public function new () { }
}

/**
 * ...
 * @author Namide
 */
class Camera2d
{
	public var display(default, null):Sprite;
	
	public var x(default, set):Float = 0;
	inline function set_x(val:Float):Float
	{
		if ( x == val ) return val;
		x = val;
		refresh();
		return val;
	}
	
	public var y(default, set):Float = 0;
	inline function set_y(val:Float):Float
	{
		if ( y == val ) return val;
		y = val;
		refresh();
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
		refresh();
		return val;
	}
	
	public var zoomY(default, set):Float = 1;
	inline function set_zoomY(val:Float):Float
	{
		if ( val == zoomY ) return val;
		zoomY = val;
		refresh();
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
		
		refresh();
	}
	
	var _sm:SysManager;
	
	public function new( sm:SysManager, ?parent:Sprite) 
	{
		_sm = sm;
		display = new Sprite(parent);
	}
	
	function refresh():Void
	{
		var zX = _stageZoom * zoomX;
		var zY = _stageZoom * zoomY;
		
		if ( zX != display.scaleX && zY != display.scaleY )
		{
			display.scaleX = zX;
			display.scaleY = zY;
		}
		
		
		var pX:Float = x;
		var pY:Float = y;
		
		var eng = _sm.sysGraphic.engine;
		var set = _sm.settings;
		
		if ( wallLimited && eng.width > Std.int(set.limitXMax - set.limitXMin) )
		{
			pX = set.limitXMin - ( ( ( eng.width - Std.int(set.limitXMax - set.limitXMin) ) >> 1 ) );
		}
		else
		{
			pX = pX - (eng.width >> 1);
			if ( pX < set.limitXMin ) pX = set.limitXMin;
			if ( pX > Std.int(set.limitXMax) - eng.width ) pX = Std.int(set.limitXMax) - eng.width;
		}
		
		if ( wallLimited && eng.height > Std.int(set.limitYMax - set.limitYMin) )
		{
			pY = set.limitYMin - ( ( ( eng.height - Std.int(set.limitYMax - set.limitYMin) ) >> 1 ) );
		}
		else
		{
			pY = pY - (eng.height >> 1);
			if ( pY < set.limitYMin ) pY = set.limitYMin;
			if ( pY > Std.int(set.limitYMax) - eng.height ) pY = Std.int(set.limitYMax) - eng.height;
		}
		
		pX += eng.width >> 1;
		pY += eng.height >> 1;
		
		pX = -pX * zX;
		pY = -pY * zY;
		
		pX += eng.width >> 1;
		pY += eng.height >> 1;
		
		display.x = pX;
		display.y = pY;
		
		//pX -= ;
		//pX -= ;
		
		for ( layer in _layers )
		{
			layer.sprite.setPos( 	-pX * layer.z + layer.x,
									-pY * layer.z + layer.y );
			//layer.sprite.scale( 0.5 * (display.scaleX + display.scaleY) * layer.z );
		}
	}
	
	public inline function setPos( x:Float, y:Float ):Void
	{
		this.x = x;
		this.y = y;
		//display.setPos( -x, -y );
		refresh();
	}
	
}