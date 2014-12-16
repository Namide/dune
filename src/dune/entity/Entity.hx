package dune.entity ;

import dune.component.Health;
import dune.component.IDisplay;
import dune.component.IInput;
import dune.component.Transform;
import dune.helper.core.ArrayUtils;
import dune.component.Controller;
import dune.system.physic.component.Body;
import dune.system.SysManager;

/**
 * ...
 * @author Namide
 */
class Entity
{
	public var sm(default, default):SysManager;
	
	public var name(default, default):String;
	public var type(default, default):UInt;
	
	public var transform(default, null):Transform;
	
	public var input(default, default):IInput;
	
	public var health(default, default):Health;
	
	public var controllers(default, null):Array<Controller>;
	public var bodies(default, null):Array<Body>;
	
	public var display(default, set):IDisplay;
	private function set_display( cd:IDisplay ):IDisplay
	{
		cd.setPos( transform.x, transform.y );
		return display = cd;
	}
	
	public function new( name:String = "" ) 
	{
		this.name = name;
		clear();
	}
	
	public function clear():Void
	{
		type = 0;
		
		if ( transform == null )	{ transform = new Transform( this ); }
		else 						{ transform.clear(); }
		
		if ( controllers == null ) 	{ controllers = []; }
		if ( bodies == null ) 		{ bodies = []; }
		
		for ( input in controllers )	{ input.clear(); }
		for ( body in bodies ) 			{ body.clear(); }
	}
	
	public function addBody( body:Body ):Void
	{
		body.entity = this;
		bodies.push( body );
		if ( sm != null )
			sm.sysPhysic.space.addBody( body );
	}
	
	public function addController( cont:Controller ):Void
	{
		cont.entity = this;
		controllers.push( cont );
		if ( sm != null )
			sm.sysController.addController( cont );
	}
	
	public function removeBody( body:Body ):Void
	{
		body.entity = null;
		bodies.remove( body );
		if ( sm != null )
			sm.sysPhysic.space.removeBody( body );
	}
	
	public function removeController( cont:Controller ):Void
	{
		cont.entity = null;
		controllers.remove( cont );
		if ( sm != null )
			sm.sysController.removeController( cont );
	}
}