package asgl.handlers {
	import __AS3__.vec.Vector;
	
	import asgl.drivers.AbstractRenderDriver;
	import asgl.math.Vertex3D;
	import asgl.mesh.TriangleFace;
	
	import flash.geom.Vector3D;
	
	public class ScreenSpaceFacesNormal implements IHandler {
		public var normalizeEnabled:Boolean;
		public function ScreenSpaceFacesNormal(normalizeEnabled:Boolean=false):void {
			this.normalizeEnabled = normalizeEnabled;
		}
		public function handle(driver:AbstractRenderDriver, faces:Vector.<TriangleFace>, completeFucntion:Function):void {
			var i:int;
			var v0:Vertex3D;
			var v1:Vertex3D;
			var v2:Vertex3D;
			var face:TriangleFace;
			var v0X:Number;
			var v0Y:Number;
			var v0Z:Number;
			var abX:Number;
			var abY:Number;
			var abZ:Number;
			var acX:Number;
			var acY:Number;
			var acZ:Number;
			var vector:Vector3D;
			if (normalizeEnabled) {
				var vx:Number;
				var vy:Number;
				var vz:Number;
				for (i = faces.length-1; i>=0; i--) {
					face = faces[i];
					v0 = face.vertex0;
					v1 = face.vertex1;
					v2 = face.vertex2;
					v0X = v0.screenX;
					v0Y = v0.screenY;
					v0Z = v0.screenZ;
					abX = v1.screenX-v0X;
					abY = v1.screenY-v0Y;
					abZ = v1.screenZ-v0Z;
					acX = v2.screenX-v0X;
					acY = v2.screenY-v0Y;
					acZ = v2.screenZ-v0Z;
					vector = face.vector;
					vx = abY*acZ-abZ*acY;
					vy = abZ*acX-abX*acZ;
					vz = abX*acY-abY*acX;
					var k:Number = Math.sqrt(vx*vx+vy*vy+vz*vz);
					vector.x = vx/k;
					vector.y = vy/k;
					vector.z = vz/k;
				}
			} else {
				for (i = faces.length-1; i>=0; i--) {
					face = faces[i];
					v0 = face.vertex0;
					v1 = face.vertex1;
					v2 = face.vertex2;
					v0X = v0.screenX;
					v0Y = v0.screenY;
					v0Z = v0.screenZ;
					abX = v1.screenX-v0X;
					abY = v1.screenY-v0Y;
					abZ = v1.screenZ-v0Z;
					acX = v2.screenX-v0X;
					acY = v2.screenY-v0Y;
					acZ = v2.screenZ-v0Z;
					vector = face.vector;
					vector.x = abY*acZ-abZ*acY;
					vector.y = abZ*acX-abX*acZ;
					vector.z = abX*acY-abY*acX;
				}
			}
			completeFucntion(faces);
		}
	}
}