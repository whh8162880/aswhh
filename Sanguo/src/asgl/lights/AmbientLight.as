package asgl.lights {
	import asgl.drivers.AbstractRenderDriver;
	import asgl.math.Vertex3D;
	
	import flash.geom.Vector3D;
	
	public class AmbientLight extends AbstractLight {
		public function AmbientLight(strength:Number=0.5, postion:Vertex3D=null):void {
			super(postion);
			this.strength = strength;
			strengthRatio = 1;
		}
		public override function init(driver:AbstractRenderDriver):void {
			super.init(driver);
			strengthRatio = 1;
		}
		public override function lightingTest(pixelScreenVertex:Vertex3D, pixelScreenVector:Vector3D):void {
		}
	}
}