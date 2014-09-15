package dune.helpers.keyboard;

import flash.display.Stage;
import flash.errors.Error;
import flash.events.KeyboardEvent;
import flash.Lib;

/**
 * Gestionnaire d'interaction avec le clavier.
 * Cette classe stocke les interactions
 * afin que des objets puissent récupérer l'état du clavier à des moments précis.
 * 
 * @author Namide
 */
class KeyboardHandler
{
	private static var _CAN_INSTANTIATE:Bool = false;
	private static var _INSTANCE:KeyboardHandler;
	
	private var _listKeyPressed:Array<UInt>;
	
	private var _listKeyCodeHandler:Array<UInt>;
	private var _listCallbackHandler:Array<Void->Void>;
	//private var _stage:Stage;
	
	public function new() 
	{
		if (_CAN_INSTANTIATE = false) throw new Error( "You can't instancies a singleton, you must use the static method getInstance()" );
		
		_listKeyPressed = [];
		_listKeyCodeHandler = [];
		_listCallbackHandler = [];
		
		
		Lib.current.stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDown );
		Lib.current.stage.addEventListener( KeyboardEvent.KEY_UP, keyUp );
	}
	
	public function addCallback( keyCode:UInt, pCallback:Void->Void ):Void
	{
		_listCallbackHandler.push(pCallback);
		_listKeyCodeHandler.push(keyCode);
	}
	
	public function getKeyPressed( keyCode:UInt ):Bool
	{
		return Lambda.has( _listKeyPressed, keyCode );
	}
	
	private function keyDown( e:KeyboardEvent ):Void
	{
		_listKeyPressed.push( e.keyCode );
	}
	
	private function keyUp( e:KeyboardEvent ):Void
	{
		if ( Lambda.has( _listKeyCodeHandler, e.keyCode ) )
		{
			var i:Int;
			for ( i in 0..._listKeyCodeHandler.length )
			{
				if ( _listKeyCodeHandler[i] == e.keyCode ) _listCallbackHandler[i]();
			}
		}
		
		while ( Lambda.has( _listKeyPressed, e.keyCode ) )
		{
			_listKeyPressed.splice( Lambda.indexOf( _listKeyPressed, e.keyCode ), 1 );
		}
	}
	
	public static function getInstance():KeyboardHandler
	{
        if (_INSTANCE == null)
		{
            _CAN_INSTANTIATE = true;
            _INSTANCE = new KeyboardHandler();
            _CAN_INSTANTIATE = false;
        }
        return _INSTANCE;
    }
	
	public function dispose():Void
	{
		Lib.current.stage.removeEventListener( KeyboardEvent.KEY_DOWN, keyDown );
		Lib.current.stage.removeEventListener( KeyboardEvent.KEY_UP, keyUp );
		
		_listKeyPressed = [];
		_listKeyCodeHandler = [];
		_listCallbackHandler = [];
	}
}