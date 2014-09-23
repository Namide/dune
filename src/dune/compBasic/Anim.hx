package dune.compBasic;

/**
 * @author Namide
 */

interface Anim
{
	public function setAnim( anim:UInt, loop:Bool = true ):Void;
	public function addAnim( anim:UInt, frameBegin:UInt, frameEnd:UInt ):Void;
	
}