package asgl.lights {
	import asgl.drivers.AbstractRenderDriver;
	import asgl.math.Vertex3D;
	
	import flash.geom.Vector3D;
	
	public class EmptyLight extends AbstractLight {
		public function EmptyLight():void {
			strengthRatio = 0;
		}
		public override function init(driver:AbstractRenderDriver):void {
			super.init(driver);
			strengthRatio = 0;
		}
		public override function lightingTest(pixelScreenVertex:Vertex3D, pixelScreenVector:Vector3D):void {
		}
	}
}