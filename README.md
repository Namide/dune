dune
===

Microframework for Haxe 2D games
[demo](http://games.namide.com/dune/)

Dependencies
---
* [Heaps](https://github.com/ncannasse/heaps), a high performance game framework by Nicolas Cannasse


Roadmap
---
* controller
	* 80% platform player
	* 80% platform movable
	* 20% items
	* 0% dangerous
* input
	* 0% mouse
	* 90% keyboard
	* 70% gamepad
	* 0% editable controls
* physic
	* 90% collisions
	* 0% faster object physic
* display 2D
	* 80% caracters from MovieClip (SWC or SWF)
->		* 0% detect bouding box not rescale
		* 0% generate tile sheet from MovieClip
	* 50% background
	* 0% shaders
->	* 0% limit proportions and zoom of the screen output
* display 3D
	* 0% decors
	* 0% characters (bones)
	* 0% background
* optimization
	* array <-> list
* fix
	* collision on platform after a jump
