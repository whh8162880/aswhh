package asgl.handlers {
	import __AS3__.vec.Vector;
	
	import asgl.cameras.Camera3D;
	import asgl.drivers.AbstractRenderDriver;
	import asgl.math.UV;
	import asgl.math.Vertex3D;
	import asgl.mesh.TriangleFace;

	public class MaterialFacesClip implements IHandler {
		public function handle(driver:AbstractRenderDriver, faces:Vector.<TriangleFace>, completeFucntion:Function):void {
			var near:Number = driver.camera.nearClipDistance;
			var nv0:Vertex3D;
			var nv1:Vertex3D;
			var nv2:Vertex3D;
			var nv3:Vertex3D;
			var nuv0:UV;
			var nuv1:UV;
			var nuv2:UV;
			var nuv3:UV;
			var k:Number;
			var out:Vector.<TriangleFace> = new Vector.<TriangleFace>();
			var length:int = faces.length;
			for (var i:int = 0; i<length; i++) {
				var face:TriangleFace = faces[i];
				var v0:Vertex3D = face.vertex0;
				var v1:Vertex3D = face.vertex1;
				var v2:Vertex3D = face.vertex2;
				var v1X:Number = v0.screenX;
				var v1Y:Number = v0.screenY;
				var v1Z:Number = v0.screenZ;
				var v2X:Number = v1.screenX;
				var v2Y:Number = v1.screenY;
				var v2Z:Number = v1.screenZ;
				var v3X:Number = v2.screenX;
				var v3Y:Number = v2.screenY;
				var v3Z:Number = v2.screenZ;
				var v2D:Number = near-v2Z;
				var v3D:Number = near-v3Z;
				var uv0:UV = face.uv0;
				var uv1:UV = face.uv1;
				var uv2:UV = face.uv2;
				var uv1X:Number = uv0.u;
				var uv1Y:Number = uv0.v;
				var uv2X:Number = uv1.u;
				var uv2Y:Number = uv1.v;
				var uv3X:Number = uv2.u;
				var uv3Y:Number = uv2.v;
				if (v1Z<near) {
					var v1D:Number = near-v1Z;
					if (v2Z<near) {
						if (v3Z<near) {
							//
						} else {
							nv0 = new Vertex3D();
							k = v1D/(v3Z-v1Z);
							nv0.screenX = v1X+k*(v3X-v1X);
							nv0.screenY = v1Y+k*(v3Y-v1Y);
							nv0.screenZ = near;
							k = v2D/(v3Z-v2Z);
							nv1 = new Vertex3D();
							nv1.screenX = v2X+k*(v3X-v2X);
							nv1.screenY = v2Y+k*(v3Y-v2Y);
							nv1.screenZ = near;
							out.push(face.getNewTriangleFace(nv0, nv1, v2, true, face.material, new UV(uv1X+k*(uv3X-uv1X), uv1Y+k*(uv3Y-uv1Y)), new UV(uv2X+k*(uv3X-uv2X), uv2Y+k*(uv3Y-uv2Y)), uv2));
						}
					} else {
						nv0 = new Vertex3D();
						k = v1D/(v2Z-v1Z);
						nv0.screenX = v1X+k*(v2X-v1X);
						nv0.screenY = v1Y+k*(v2Y-v1Y);
						nv0.screenZ = near;
						nuv0 = new UV(uv1X+k*(uv2X-uv1X), uv1Y+k*(uv2Y-uv1Y));
						if (v3Z<near) {
							nv2 = new Vertex3D();
							k = v3D/(v2Z-v3Z);
							nv2.screenX = v3X+k*(v2X-v3X);
							nv2.screenY = v3Y+k*(v2Y-v3Y);
							nv2.screenZ = near;
							out.push(face.getNewTriangleFace(nv0, v1, nv2, true, face.material, nuv0, uv1, new UV(uv3X+k*(uv2X-uv3X), uv3Y+k*(uv2Y-uv3Y))));
						} else {
							nv3 = new Vertex3D();
							k = v1D/(v3Z-v1Z);
							nv3.screenX = v1X+k*(v3X-v1X);
							nv3.screenY = v1Y+k*(v3Y-v1Y);
							nv3.screenZ = near;
							out.push(face.getNewTriangleFace(nv0, v1, v2, true, face.material, nuv0, uv1, uv2), face.getNewTriangleFace(nv0, v2, nv3, true, face.material, nuv0, uv2, new UV(uv1X+k*(uv3X-uv1X), uv1Y+k*(uv3Y-uv1Y))));
						}
					}
				} else {
					if (v2Z<near) {
						nv1 = new Vertex3D();
						k = v2D/(v1Z-v2Z);
						nv1.screenX = v2X+k*(v1X-v2X);
						nv1.screenY = v2Y+k*(v1Y-v2Y);
						nv1.screenZ = near;
						nuv1 = new UV(uv2X+k*(uv1X-uv2X), uv2Y+k*(uv1Y-uv2Y));
						if (v3Z<near) {
							nv2 = new Vertex3D();
							k = v3D/(v1Z-v3Z);
							nv2.screenX = v3X+k*(v1X-v3X);
							nv2.screenY = v3Y+k*(v1Y-v3Y);
							nv2.screenZ = near;
							out.push(face.getNewTriangleFace(v0, nv1, nv2, true, face.material, uv0, nuv1, new UV(uv3X+k*(uv1X-uv3X), uv3Y+k*(uv1Y-uv3Y))));
						} else {
							nv2 = new Vertex3D();
							k = v2D/(v3Z-v2Z);
							nv2.screenX = v2X+k*(v3X-v2X);
							nv2.screenY = v2Y+k*(v3Y-v2Y);
							nv2.screenZ = near;
							nuv2 = new UV(uv2X+k*(uv3X-uv2X), uv2Y+k*(uv3Y-uv2Y));
							out.push(face.getNewTriangleFace(v0, nv1, nv2, true, face.material, uv0, nuv1, nuv2), face.getNewTriangleFace(v0, nv2, v2, true, face.material, uv0, nuv2, uv2));
						}
					} else {
						if (v3Z<near) {
							nv2 = new Vertex3D();
							k = v3D/(v2Z-v3Z);
							nv2.screenX = v3X+k*(v2X-v3X);
							nv2.screenY = v3Y+k*(v2Y-v3Y);
							nv2.screenZ = near;
							nuv2 = new UV(uv3X+k*(uv2X-uv3X), uv3Y+k*(uv2Y-uv3Y));
							nv3 = new Vertex3D();
							k = v3D/(v1Z-v3Z);
							nv3.screenX = v3X+k*(v1X-v3X);
							nv3.screenY = v3Y+k*(v1Y-v3Y);
							nv3.screenZ = near;
							out.push(face.getNewTriangleFace(v0, v1, nv2, true, face.material, uv0, uv1, nuv2), face.getNewTriangleFace(v0, nv2, nv3, true, face.material, uv0, nuv2, new UV(uv3X+k*(uv1X-uv3X), uv3Y+k*(uv1Y-uv3Y))));
						} else {
							out.push(face);
						}
					}
				}
			}
			completeFucntion(out);
		}
	}
}