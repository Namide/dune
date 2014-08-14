package dune.helpers.pool;
import dune.entities.Entity;

/**
 * @author Namide
 */
class EntityPool
{
	private var _pool:Array<Entity>;
	
	public function new( length:UInt = 30 ) 
	{
		_pool = [];
		
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
            var item:Entity = initEntity();
			_pool.push( item );
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