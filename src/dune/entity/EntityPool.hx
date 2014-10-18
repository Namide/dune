package dune.entity ;
import dune.entity.Entity;

/**
 * @author Namide
 */
class EntityPool
{
	private var _pool:Array<Entity>;
	
	public function new( initialize:Void->Entity, length:UInt = 30 ) 
	{
		_pool = [];
		initEntity = initialize;
		
		var i:UInt;
		var e:Entity;
		
        for ( i in 0...length )
		{
            e = initEntity();
            _pool.push( e );
		}
	}
	
	public dynamic function initEntity():Entity
	{
		return new Entity();
	}
   
    public function free( e:Entity ):Void
	{
		_pool.push( e );
	}
   
    public function get():Entity
	{
        if ( _pool.length > 0 )
		{
			return _pool.shift();
		}
        else
		{
            _pool.push( initEntity() );
            return get();
		}
	}
	
	public function dispose():Void
	{
		for ( e in _pool )
		{
			e.clear();
		}
		_pool = [];
	}
	
}