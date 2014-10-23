package dune.system.graphic;

import dune.system.graphic.Camera2d.Layer;
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
	
	public var x(get, set):Float;
	inline function get_x():Float
	{
		return -display.x;
	}
	inline function set_x(val:Float):Float
	{
		display.x = -val;
		refresh();
		return val;
	}
	
	public var y(get, set):Float;
	inline function get_y():Float
	{
		return -display.y;
	}
	inline function set_y(val:Float):Float
	{
		display.y = -val;
		refresh();
		return val;
	}
	
	public inline function zoom( val:Float ):Void
	{
		display.scale(val);
		refresh();
	}
	
	public var zoomX(get, set):Float;
	inline function get_zoomX():Float
	{
		return display.scaleX;
	}
	inline function set_zoomX(val:Float):Float
	{
		display.scaleX = val;
		refresh();
		return val;
	}
	
	public var zoomY(get, set):Float;
	inline function get_zoomY():Float
	{
		return display.scaleY;
	}
	inline function set_zoomY(val:Float):Float
	{
		display.scaleY = val;
		refresh();
		return val;
	}
	
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
	
	public function new(?parent:Sprite) 
	{
		display = new Sprite(parent);
	}
	
	function refresh():Void
	{
		for ( layer in _layers )
		{
			layer.sprite.setPos( 	display.x * layer.z + layer.x,
									display.y * layer.z + layer.y );
			//layer.sprite.scale( 0.5 * (display.scaleX + display.scaleY) * layer.z );
		}
	}
	
	public inline function setPos( x:Float, y:Float ):Void
	{
		display.setPos( -x, -y );
		refresh();
	}
	
}