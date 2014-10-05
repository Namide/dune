package dune.inputs.core;

/**
 * @author Namide
 */

interface IInput 
{
	public function getX():Float;
	public function getY():Float;
	
	public function getB1():Float;
	public function getB2():Float;
	
	public function getStart():Bool;
	public function getSelect():Bool;
	
	//public static function getInstance():IInput;
}