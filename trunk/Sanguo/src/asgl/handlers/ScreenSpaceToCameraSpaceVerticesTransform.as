package asgl.handlers {
	import __AS3__.vec.Vector;
	
	import asgl.cameras.Camera3D;
	import asgl.drivers.AbstractRenderDriver;
	import asgl.math.Vertex3D;
	import asgl.mesh.TriangleFace;

	public class ScreenSpaceToCameraSpaceVerticesTransform implements IHandler {
		public function handle(driver:AbstractRenderDriver, faces:Vector.<TriangleFace>, completeFucntion:Function):void {
			var camera:Camera3D = driver.camera;
			var pc:Number = camera.perspectiveCoefficient;
			var halfWidth:Number = camera.width/2;
			var halfHeight:Number = camera.height/2;
			for (var i:int = faces.length-1; i>=0; i--) {
				var face:TriangleFace = faces[i];
				var v:Vertex3D = face.vertex0;
				var k:Number = pc/v.screenZ;
				//use Vertex transformCameraSpace method
				v.cameraX = k*(v.screenX-halfWidth)+halfWidth;
				v.cameraY = k*(v.screenY+halfHeight)-halfHeight;
				v.cameraZ = -k;
				//
				v = face.vertex1;
				k = pc/v.screenZ;
				//use Vertex transformCameraSpace method
				v.cameraX = k*(v.screenX-halfWidth)+halfWidth;
				v.cameraY = k*(v.screenY+halfHeight)-halfHeight;
				v.cameraZ = -k;
				//
				v = face.vertex2;
				k = pc/v.screenZ;
				//use Vertex transformCameraSpace method
				v.cameraX = k*(v.screenX-halfWidth)+halfWidth;
				v.cameraY = k*(v.screenY+halfHeight)-halfHeight;
				v.cameraZ = -k;
			}
			completeFucntion(faces);
		}
	}
}