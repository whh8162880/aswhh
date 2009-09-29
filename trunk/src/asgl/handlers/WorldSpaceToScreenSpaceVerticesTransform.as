package asgl.handlers {
	import __AS3__.vec.Vector;
	
	import asgl.drivers.AbstractRenderDriver;
	import asgl.lights.AbstractLight;
	import asgl.math.GLMatrix3D;
	import asgl.math.Vertex3D;
	import asgl.mesh.TriangleFace;

	public class WorldSpaceToScreenSpaceVerticesTransform implements IHandler {
		public var vertices:Vector.<Vertex3D>;
		public function WorldSpaceToScreenSpaceVerticesTransform(vertices:Vector.<Vertex3D>=null):void {
			this.vertices = vertices;
		}
		public function handle(driver:AbstractRenderDriver, faces:Vector.<TriangleFace>, completeFucntion:Function):void {
			var m:GLMatrix3D = driver.camera.screenMatrix;
			var i:int;
			if (vertices == null) {
				for (i = faces.length-1; i>=0; i--) {
					var face:TriangleFace = faces[i];
					face.vertex0.transformScreenSpace(m);
					face.vertex1.transformScreenSpace(m);
					face.vertex2.transformScreenSpace(m);
				}
			} else {
				for (i = vertices.length-1; i>=0; i--) {
					vertices[i].transformScreenSpace(m);
				}
			}
			var lights:Vector.<AbstractLight> = driver.lights;
			if (lights != null) {
				for (i = lights.length-1; i>=0; i--) {
					lights[i].transformScreenSpace(m);
				}
			}
			completeFucntion(faces);
		}
	}
}