import h3d.prim.Cube;
import h3d.scene.Mesh;
import hxd.Math;

class Main extends hxd.App {

	var time : Float = 0.;
	var spheres : Array<h3d.scene.Object>;
	var dir : h3d.scene.DirLight;
	var shadow : h3d.pass.ShadowMap;

	override function init() {

		/*var crown = hxd.Res.Model.toHmd();
		var obj = crown.makeObject();
		s3d.addChild(obj);*/
		
		
		var floor = new h3d.prim.Cube(20, 20, 0.1);
		floor.addNormals();
		floor.translate( -10, -10, -0.1);
		var m = new h3d.scene.Mesh(floor, s3d);
		m.material.color.set( 0.5, 0.5, 0.5 );
		m.material.mainPass.enableLights = true;
		m.material.shadows = true;

		var sphere = new h3d.prim.Sphere(32,24);
		var cube = new h3d.prim.Cube(1, 1, 1 );
		
		sphere.addNormals();
		cube.addNormals();
		spheres  = [];
		for ( i in 0...200 ) {
			var isCube = Std.random(2) > 0;
			var p = ( !isCube ) ? new h3d.scene.Mesh(sphere, s3d) : new h3d.scene.Mesh(cube, s3d);
			p.scale(0.2 + Math.random() * 0.5);
			p.x = Math.srand(6);
			p.y = Math.srand(6);
			//p.z = Math.random() * p.scaleX;
			p.z = ( !isCube ) ? p.scaleZ : 0;
			p.material.mainPass.enableLights = true;
			p.material.shadows = true;
			p.material.color.setColor(0xFC4B4E/*Std.random(0x1000000)*/);
		}
		s3d.camera.zNear = 2;
		s3d.camera.zFar = 15;
		s3d.lightSystem.ambientLight.set(0.5, 0.5, 0.5);

		dir = new h3d.scene.DirLight(new h3d.Vector(-0.3, -0.2, -1), s3d);

		shadow = cast(s3d.renderer.getPass("shadow"), h3d.pass.ShadowMap);
		shadow.lightDirection = dir.direction;
		shadow.blur.count = 3;//3;
	}

	override function update( dt : Float ) {
		//s3d.camera.pos.set(6, 6, 3);
		s3d.camera.pos.set( 6 * Math.cos(time*0.3), 6 * Math.sin(time*0.3), 3 );
		time += dt * 0.01;
		dir.direction.set(Math.cos(time), Math.sin(time) * 2, -1);
	}

	public static var inst : Main;
	static function main() {
		inst = new Main();
	}

}
