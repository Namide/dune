package dune.input.core ;

/**
 * @author Namide
 */

interface IInput 
{
	public function getAxisX():Float;
	public function getAxisY():Float;
	
	public function getB1():Float;
	public function getB2():Float;
	
	public function getStart():Bool;
	public function getSelect():Bool;
	
	//public static function getInstance():IInput;
}