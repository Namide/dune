
var duneGamepad = new DuneGamepad();
function DuneGamepad()
{
	this.haveEvents = 'GamepadEvent' in window;
	this.controllers = {};
	
	this.init = function()
	{
		if( window.dgp === undefined ) window.dgp = this;
		var dgp = window.dgp;
	};
	
	this.addgamepad = function(gamepad)
	{
		var dgp = window.dgp;
		dgp.controllers[gamepad.index] = gamepad;
	};
	
	this.removegamepad = function(gamepad)
	{
		var dgp = window.dgp;
		var d = document.getElementById("controller" + gamepad.index);
		document.body.removeChild(d);
		delete dgp.controllers[gamepad.index];
	};

	this.getList = function()
	{
		var dgp = window.dgp;
		dgp.scangamepads();
		
		var list = [];
		for (j in dgp.controllers)
		{
			list.push( {"id":dgp.controllers[j]["id"], "index":dgp.controllers[j]["index"]} );
		}
		return JSON.stringify( list );
	}

	this.getController = function(id)
	{
		var dgp = window.dgp;
		dgp.scangamepads();
		
		var controller = dgp.controllers[id];
		
		var obj = dgp.toObj( controller );
		return JSON.stringify( obj || "" );
	}
	
	this.toObj = function( data )
	{
		var dgp = window.dgp;
		var obj = {};
		for (var i in data)
		{
			obj[i] = ( (typeof data[i] == "object") && (data[i] !== null) ) ? dgp.toObj( data[i] ) : data[i];
		}
		return obj;
	}
	
	this.scangamepads = function()
	{
		var dgp = window.dgp;
		var gamepads = navigator.getGamepads ? navigator.getGamepads() : (navigator.webkitGetGamepads ? navigator.webkitGetGamepads() : []);
		for (var i = 0; i < gamepads.length; i++)
		{
			if (gamepads[i])
			{
				if (!(gamepads[i].index in dgp.controllers))
				{
					dgp.addgamepad(gamepads[i]);
				}
				else
				{
					dgp.controllers[gamepads[i].index] = gamepads[i];
				}
			}
		}
	};
	
	this.init();
}
