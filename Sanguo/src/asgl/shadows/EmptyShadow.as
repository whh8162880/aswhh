package asgl.shadows {
	import asgl.math.Vertex3D;
	
	public class EmptyShadow extends AbstractShadow {
		public override function shadowTest(pixelScreenVertex:Vertex3D):void {
			light.hasShadow = false;
		}
	}
}