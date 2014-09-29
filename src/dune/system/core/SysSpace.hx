package dune.system.core;

import dune.system.physic.components.CompBody;

/**
 * @author Namide
 */

interface SysSpace 
{
	public function hitTest():List<CompBody>;
	public function testSleeping():Void;
	
	public function removeBody( body:CompBody ):Void;
	public function addBody( body:CompBody ):Void;
}