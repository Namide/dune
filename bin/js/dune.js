// https://developer.mozilla.org/fr/docs/Web/Guide/API/Gamepad
// https://github.com/luser/gamepadtest/blob/master/gamepadtest.js

/*
 * Gamepad API Test
 * Written in 2013 by Ted Mielczarek <ted@mielczarek.org>
 *
 * To the extent possible under law, the author(s) have dedicated all copyright and related and neighboring rights to this software to the public domain worldwide. This software is distributed without any warranty.
 *
 * You should have received a copy of the CC0 Public Domain Dedication along with this software. If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.
 */
var haveEvents = 'GamepadEvent' in window;
var controllers = {};
var rAF = window.mozRequestAnimationFrame ||
		window.webkitRequestAnimationFrame ||
		window.requestAnimationFrame;

function connecthandler(e) {
	addgamepad(e.gamepad);
}
function addgamepad(gamepad) {
	controllers[gamepad.index] = gamepad;
	/*var d = document.createElement("div");
	d.setAttribute("id", "controller" + gamepad.index);
	var t = document.createElement("h1");
	t.appendChild(document.createTextNode("gamepad: " + gamepad.id));
	d.appendChild(t);
	var b = document.createElement("div");
	b.className = "buttons";
	for (var i = 0; i < gamepad.buttons.length; i++) {
		var e = document.createElement("span");
		e.className = "button";
//e.id = "b" + i;
		e.innerHTML = i;
		b.appendChild(e);
	}
	d.appendChild(b);
	var a = document.createElement("div");
	a.className = "axes";
	for (i = 0; i < gamepad.axes.length; i++) {
		e = document.createElement("progress");
		e.className = "axis";
//e.id = "a" + i;
		e.setAttribute("max", "2");
		e.setAttribute("value", "1");
		e.innerHTML = i;
		a.appendChild(e);
	}
	d.appendChild(a);
	document.getElementById("start").style.display = "none";
	document.body.appendChild(d);*/
	rAF(updateStatus);
}
function disconnecthandler(e) {
	removegamepad(e.gamepad);
}
function removegamepad(gamepad) {
	var d = document.getElementById("controller" + gamepad.index);
	document.body.removeChild(d);
	delete controllers[gamepad.index];
}
function updateStatus() {
	scangamepads();
	for (j in controllers) {
		var controller = controllers[j];
		//var d = document.getElementById("controller" + j);
		//var buttons = d.getElementsByClassName("button");
		for (var i = 0; i < controller.buttons.length; i++) {
			var b = buttons[i];
			var val = controller.buttons[i];
			var pressed = val == 1.0;
			if (typeof (val) == "object") {
				pressed = val.pressed;
				val = val.value;
			}
			/*var pct = Math.round(val * 100) + "%";
			b.style.backgroundSize = pct + " " + pct;
			if (pressed) {
				b.className = "button pressed";
			} else {
				b.className = "button";
			}*/
		}
		/*var axes = d.getElementsByClassName("axis");
		for (var i = 0; i < controller.axes.length; i++) {
			var a = axes[i];
			a.innerHTML = i + ": " + controller.axes[i].toFixed(4);
			a.setAttribute("value", controller.axes[i] + 1);
		}*/
	}
	rAF(updateStatus);
}
function scangamepads() {
	var gamepads = navigator.getGamepads ? navigator.getGamepads() : (navigator.webkitGetGamepads ? navigator.webkitGetGamepads() : []);
	for (var i = 0; i < gamepads.length; i++) {
		if (gamepads[i]) {
			if (!(gamepads[i].index in controllers)) {
				addgamepad(gamepads[i]);
			} else {
				controllers[gamepads[i].index] = gamepads[i];
			}
		}
	}
}
if (haveEvents) {
	window.addEventListener("gamepadconnected", connecthandler);
	window.addEventListener("gamepaddisconnected", disconnecthandler);
} else {
	setInterval(scangamepads, 500);
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
