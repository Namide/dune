/*
 * Gamepad API Test
 * Written in 2013 by Ted Mielczarek <ted@mielczarek.org>
 *
 * To the extent possible under law, the author(s) have dedicated all copyright and related and neighboring rights to this software to the public domain worldwide. This software is distributed without any warranty.
 *
 * You should have received a copy of the CC0 Public Domain Dedication along with this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
 */

// https://developer.mozilla.org/fr/docs/Web/Guide/API/Gamepad
// https://github.com/luser/gamepadtest/blob/master/gamepadtest.js


var duneGamepad = new DuneGamepad();
function DuneGamepad()
{
	this.haveEvents = 'GamepadEvent' in window;
	this.controllers = {};
	this.rAF =	window.mozRequestAnimationFrame ||
				window.webkitRequestAnimationFrame ||
				window.requestAnimationFrame;
	
	this.init = function()
	{
		if( window.dgp === undefined ) window.dgp = this;
		var dgp = window.dgp;
		
		if (dgp.haveEvents)
		{
			//window.addEventListener("gamepadconnected", this.connecthandler);
			window.addEventListener("gamepadconnected", dgp.connecthandler);
			window.addEventListener("gamepaddisconnected", dgp.disconnecthandler);
		}
		else
		{
			setInterval( dgp.scangamepads, 500 );
		}
	};
	
	this.connecthandler = function(e)
	{
		var dgp = window.dgp;
		dgp.addgamepad( e.gamepad );
	};
	
	this.addgamepad = function(gamepad)
	{
		var dgp = window.dgp;
		dgp.controllers[gamepad.index] = gamepad;
		
		var rAF =	window.mozRequestAnimationFrame ||
				window.webkitRequestAnimationFrame ||
				window.requestAnimationFrame;
		rAF( dgp.updateStatus );
	};
	
	this.disconnecthandler = function(e)
	{
		var dgp = window.dgp;
		dgp.removegamepad(e.gamepad);
	};
	
	this.removegamepad = function(gamepad)
	{
		var dgp = window.dgp;
		var d = document.getElementById("controller" + gamepad.index);
		document.body.removeChild(d);
		delete dgp.controllers[gamepad.index];
	};

	this.updateStatus = function()
	{
		var dgp = window.dgp;
		dgp.scangamepads();
		var c = document.getElementById("testZone");
		c.innerHTML = "";

		for (j in dgp.controllers)
		{
			var controller = dgp.controllers[j];
			
			for (var i = 0; i < controller.buttons.length; i++)
			{

				var val = controller.buttons[i];
				var pressed = val == 1.0;
				if (typeof (val) == "object")
				{
					pressed = val.pressed;
					val = val.value;
				}

				if ( val > 0.1 )
				{
					var c = document.getElementById("testZone");
					c.innerHTML += "<br>" + i + ":" + val;
				}
			}

			for (var i = 0; i < controller.axes.length; i++)
			{

				var val = controller.axes[i];
				if ( val < 0.2 && val > -0.2 ) val = 0;

				if ( val !== 0 )
				{
					var c = document.getElementById("testZone");
					c.innerHTML += "<br>" + i + ":" + val;
				}
			}
		}
		var rAF =	window.mozRequestAnimationFrame ||
				window.webkitRequestAnimationFrame ||
				window.requestAnimationFrame;
		rAF(dgp.updateStatus);
	};
	
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



// -----------------------------------------
/*
var CONTROLLER_TYPES = {
	XBOX: 0,
	PS3: 1,
	LOGITECH: 2
};
var XBOX_AXES = {
	LEFT_STICK_X: 0,
	LEFT_STICK_Y: 1,
	RIGHT_STICK_X: 2,
	RIGHT_STICK_Y: 3
};
var XBOX_BUTTONS = {
	A: 0,
	B: 1,
	X: 2,
	Y: 3,
	LB: 4,
	RB: 5,
	LEFT_STICK: 6,
	RIGHT_STICK: 7,
	START: 8,
	BACK: 9,
	HOME: 10,
	DPAD_UP: 11,
	DPAD_DOWN: 12,
	DPAD_LEFT: 13,
	DPAD_RIGHT: 14
};
var LOGITECH_AXES = {
	LEFT_STICK_X: 1,
	LEFT_STICK_Y: 2,
	RIGHT_STICK_X: 3,
	RIGHT_STICK_Y: 4
};
var LOGITECH_AXES_CHROME = {
	LEFT_STICK_X: 0,
	LEFT_STICK_Y: 1,
	RIGHT_STICK_X: 2,
	RIGHT_STICK_Y: 5
};
var LOGITECH_BUTTONS = {
	A: 1,
	B: 2,
	X: 0,
	Y: 3,
	LB: 4,
	RB: 5,
	LEFT_STICK: 10,
	RIGHT_STICK: 11,
	START: 9,
	BACK: 8,
//HOME: 10,
	DPAD_UP: 11,
	DPAD_DOWN: 12,
	DPAD_LEFT: 13,
	DPAD_RIGHT: 14
};
var PS3_AXES = {
	LEFT_STICK_X: 0,
	LEFT_STICK_Y: 1,
	RIGHT_STICK_X: 2,
	RIGHT_STICK_Y: 3
};
var PS3_BUTTONS = {
	CROSS: 14,
	CIRCLE: 13,
	SQUARE: 15,
	TRIANGLE: 12,
	LB1: 10,
	RB1: 11,
	LEFT_STICK: 1,
	RIGHT_STICK: 2,
	START: 3,
	SELECT: 0,
	HOME: 16,
	DPAD_UP: 4,
	DPAD_DOWN: 6,
	DPAD_LEFT: 7,
	DPAD_RIGHT: 5
};
var PS3_BUTTONS_CHROME = {
	CROSS: 0,
	CIRCLE: 1,
	SQUARE: 2,
	TRIANGLE: 3,
	LB1: 4,
	RB1: 5,
	LEFT_STICK: 10,
	RIGHT_STICK: 11,
	START: 9,
	SELECT: 8,
	HOME: 16,
	DPAD_UP: 12,
	DPAD_DOWN: 13,
	DPAD_LEFT: 14,
	DPAD_RIGHT: 15
};
*/
