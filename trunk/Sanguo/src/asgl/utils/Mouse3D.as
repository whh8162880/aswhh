package asgl.utils {
	import __AS3__.vec.Vector;
	
	import asgl.cameras.Camera3D;
	import asgl.math.Vertex3D;
	import asgl.mesh.TriangleFace;
	
	import flash.geom.Rectangle;
	public class Mouse3D {
		private static const POSITIVE_INFINITY:Number = Number.POSITIVE_INFINITY;
		public var isPerspective:Boolean = false;
		public var camera:Camera3D;
		public var faces:Vector.<TriangleFace>;
		private var _rect:Rectangle = new Rectangle();
		public function Mouse3D(camera:Camera3D=null, faces:Vector.<TriangleFace>=null):void {
			this.camera = camera;
			this.faces = faces;
		}
		public function clear():void {
			camera = null;
			faces = null;
		}
		public function click(x:Number, y:Number, clickVertex:Vertex3D=null):TriangleFace {
			if (camera == null || faces == null) return null;
			var clickFace:TriangleFace;
			_rect.width = camera.width;
			_rect.height = camera.height;
			if (!_rect.contains(x, y)) return null;
			y = -y;
			var zList:Array = [];
			var length:int = faces.length;
			var v1x:Number;
			var v1y:Number;
			var v2x:Number;
			var v2y:Number;
			var u:Number;
			var v:Number;
			var fsdx:Number;
			var fsdy:Number;
			var fsdz:Number;
			var fldx:Number;
			var fldy:Number;
			var fldz:Number;
			var vz:Number;
			var i:int;
			var face:TriangleFace;
			var v0:Vertex3D;
			var v1:Vertex3D;
			var v2:Vertex3D;
			var v0cx:Number;
			var v0cy:Number;
			var v0sx:Number;
			var v0sy:Number;
			var v0sz:Number;
			var v1sx:Number;
			var v1sy:Number;
			var v2sx:Number;
			var v2sy:Number;
			var minZ:Number;
			if (isPerspective) {
				var cx:Number = camera.screenX;
				var cy:Number = camera.screenY;
				var cz:Number = camera.screenZ;
				var pc:Number = camera.perspectiveCoefficient;
				for (i = 0; i<length; i++) {
					face = faces[i];
					v0 = face.vertex0;
					v1 = face.vertex1;
					v2 = face.vertex2;
					v0cx = v0.cameraX;
					v0cy = v0.cameraY;
					v1x = v1.cameraX-v0cx;
					v1y = v1.cameraY-v0cy;
					v2x = v2.cameraX-v0cx;
					v2y = v2.cameraY-v0cy;
					u = (x*v2y-y*v2x-v0cx*v2y+v0cy*v2x)/(v1x*v2y-v1y*v2x);
					if (isNaN(u) || u<0) continue;
					if (v2x == 0) {
						if (v2y == 0) {
							continue;
						} else {
							v = (y-v0cy-u*v1y)/v2y;
							if (v<0) continue;
						}
					} else {
						v = (y-v0cy-u*v1y)/v2y;
						if (v<0) continue;
					}
					if (isNaN(v) || u+v>1) continue;
					v0sx = v0.screenX;
					v0sy = v0.screenY;
					v0sz = v0.screenZ;
					fsdx = v1.screenX-v0sx;
					fsdy = v1.screenY-v0sy;
					fsdz = v1.screenZ-v0sz;
					fldx = v2.screenX-v0sx;
					fldy = v2.screenY-v0sy;
					fldz = v2.screenZ-v0sz;
					vz = fsdx*fldy-fsdy*fldx;
					var vx:Number = fsdy*fldz-fsdz*fldy;
					var vy:Number = fsdz*fldx-fsdx*fldz;
					zList.push(-pc/(cz+((vx*v0sx+vy*v0sy+vz*v0sz-vx*cx-vy*cy-vz*cz)/(vx*(x-cx)+vy*(y-cy)+vz*pc))*pc), face);
				}
				length = zList.length;
				if (length == 0) return null;
				minZ = POSITIVE_INFINITY;
				for (i = 0; i<length; i+=2) {
					if (minZ>zList[i]) {
						minZ = zList[i];
						clickFace = zList[i+1];
					}
				}
				if (clickVertex != null) {
					clickVertex.cameraX = x;
					clickVertex.cameraY = y;
					clickVertex.cameraZ = minZ;
				}
				return clickFace;
			} else {
				for (i = 0; i<length; i++) {
					face = faces[i];
					v0 = face.vertex0;
					v1 = face.vertex1;
					v2 = face.vertex2;
					v0sx = v0.screenX;
					v0sy = v0.screenY;
					v0sz = v0.screenZ;
					v1sx = v1.screenX;
					v1sy = v1.screenY;
					v2sx = v2.screenX;
					v2sy = v2.screenY;
					v1x = v1sx-v0sx;
					v1y = v1sy-v0sy;
					v2x = v2sx-v0sx;
					v2y = v2sy-v0sy;
					u = (x*v2y-y*v2x-v0sx*v2y+v0sy*v2x)/(v1x*v2y-v1y*v2x);
					if (isNaN(u) || u<0) continue;
					if (v2x == 0) {
						if (v2y == 0) {
							continue;
						} else {
							v = (y-v0sy-u*v1y)/v2y;
							if (v<0) continue;
						}
					} else {
						v = (y-v0sy-u*v1y)/v2y;
						if (v<0) continue;
					}
					if (isNaN(v) || u+v>1) continue;
					fsdx = v1sx-v0sx;
					fsdy = v1sy-v0sy;
					fsdz = v1.screenZ-v0sz;
					fldx = v2sx-v0sx;
					fldy = v2sy-v0sy;
					fldz = v2.screenZ-v0sz;
					vz = fsdx*fldy-fsdy*fldx;
					zList.push(((fsdy*fldz-fsdz*fldy)*(v0sx-x)+(fsdz*fldx-fsdx*fldz)*(v0sy-y)+vz*v0sz)/vz, face);
				}
				length = zList.length;
				if (length == 0) return null;
				minZ = POSITIVE_INFINITY;
				for (i = 0; i<length; i+=2) {
					if (minZ>zList[i]) {
						minZ = zList[i];
						clickFace = zList[i+1];
					}
				}
				if (clickVertex != null) {
					clickVertex.screenX = x;
					clickVertex.screenY = y;
					clickVertex.screenZ = minZ;
				}
				return clickFace;
			}
		}
	}
}