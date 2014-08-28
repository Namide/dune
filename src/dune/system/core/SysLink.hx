package dune.system.core;
import dune.compBasic.CompTransform;
import dune.system.core.SysLink.Link;

class Link
{
	public var type(default, default):UInt;
	public var parent(default, default):CompTransform;
	public var child(default, default):CompTransform;
	
	public function new( parent:CompTransform, child:CompTransform, type:UInt ) 
	{
		this.type = type;
		this.parent = parent;
		this.child = child;
	}
	
}

/**
 * ...
 * @author Namide
 */
class SysLink
{
	public static inline var TYPE_TOP:UInt = 0;
	public static inline var TYPE_BOTTOM:UInt = 1;
	public static inline var TYPE_LEFT:UInt = 2;
	public static inline var TYPE_RIGHT:UInt = 3;
	public static inline var TYPE_RELATIVE:UInt = 4;
	public static inline var TYPE_ABSOLUTE:UInt = 5;
	
	var _links:Array<Link>;
	
	public function new() 
	{
		_links = [];
	}
	
	public inline function add( parent:CompTransform, child:CompTransform, type:UInt ):Void
	{
		_links.push( new Link( parent, child, type ) );
	}
	
	private inline function getChilds( parent:CompTransform ):List<Link>
	{
		return Lambda.filter( _links, function(l:Link):Bool { return (l.parent == parent); } );
	}
	
	private inline function getParents( child:CompTransform ):List<Link>
	{
		return Lambda.filter( _links, function(l:Link):Bool { return (l.child == child); } );
	}
	
	public inline function has( parent:CompTransform, child:CompTransform ):Bool
	{
		return Lambda.exists(_links, function(l:Link):Bool { return (l.parent == parent && l.child == child ); } );
	}
	
	public inline function hasChild( parent:CompTransform ):Bool
	{
		return Lambda.exists(_links, function(l:Link):Bool { return (l.parent == parent); } );
	}
	
	public inline function hasParent( child:CompTransform ):Bool
	{
		return Lambda.exists(_links, function(l:Link):Bool { return (l.child == child); } );
	}
	
	public function remove( parent:CompTransform, child:CompTransform ):Void
	{
		var o:Link = Lambda.find( _links, function(l:Link):Bool { return (l.parent == parent && l.child == child ); } );
		if ( o != null ) _links.remove( o );
	}
	
	public function removeParent( parent:CompTransform ):Void
	{
		var o:Link = Lambda.find( _links, function(l:Link):Bool { return (l.parent == parent); } );
		if ( o != null ) _links.remove( o );
	}
	
	public function removeChild( child:CompTransform ):Void
	{
		var o:Link = Lambda.find( _links, function(l:Link):Bool { return (l.child == child); } );
		if ( o != null ) _links.remove( o );
	}
	
	public function getAbsVel( child:CompTransform ):Array<Float>
	{
		var pos:Array<Float> = [ child.vX, child.vY ];
		if ( hasParent(child) )
		{
			for ( l in getParents(child) )
			{
				pos[0] += l.parent.vX;
				pos[1] += l.parent.vY;
			}
		}
		return pos;
	}
	
	/*public function refresh():Void
	{
		throw "todo";
		if ( parent.entity.attachedTo.indexOf( body.entity ) < 0 )
		{
			parent.entity.attachedTo.push( body.entity );
		}
		
		if ( parent.entity.transform.vY > body.entity.transform.vY )
		{
			parent.entity.transform.vY = body.entity.transform.vY;
		}
	}*/
	
}