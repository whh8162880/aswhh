package asgl.mesh {
	import __AS3__.vec.Vector;
	
	import asgl.math.BoundBox;
	import asgl.math.BoundSphere;
	import asgl.math.SpaceType;
	import asgl.math.Vertex3D;
	
	public class VertexModifier {
		private static const POSITIVE_INFINITY:Number = Number.POSITIVE_INFINITY;
		private static const NEGATIVE_INFINITY:Number = Number.NEGATIVE_INFINITY;
		public var vertices:Vector.<Vertex3D>;
		public function VertexModifier(vertices:Vector.<Vertex3D>=null):void {
			this.vertices = vertices;
		}
		public function set localScale(value:Number):void {
			if (vertices == null) return;
			var length:int = vertices.length;
			for (var i:int = 0; i<length; i++) {
				var v:Vertex3D = vertices[i];
				v.localX *= value;
				v.localY *= value;
				v.localZ *= value;
			}
		}
		public function get totalVertices():int {
			if (vertices == null) return 0;
			return vertices.length;
		}
		public function  getBoundBox(spaceType:String, boundBox:BoundBox=null):BoundBox {
			var bound:BoundBox = boundBox == null ? new BoundBox() : boundBox;
			bound.reset();
			if (vertices == null || vertices.length == 0) return bound;
			var x:Number;
			var y:Number;
			var z:Number;
			var minX:Number = POSITIVE_INFINITY;
			var maxX:Number = NEGATIVE_INFINITY;
			var minY:Number = POSITIVE_INFINITY;
			var maxY:Number = NEGATIVE_INFINITY;
			var minZ:Number = POSITIVE_INFINITY;
			var maxZ:Number = NEGATIVE_INFINITY;
			var i:int;
			var v:Vertex3D;
			if (spaceType == SpaceType.LOCAL_SPACE) {
				for (i = vertices.length-1; i>=0; i--) {
					v = vertices[i];
					x = v.localX;
					y = v.localY;
					z = v.localZ;
					if (minX>x) minX = x;
					if (maxX<x) maxX = x;
					if (minY>y) minY = y;
					if (maxY<y) maxY = y;
					if (minZ>z) minZ = z;
					if (maxZ<z) maxZ = z;
				}
			} else if (spaceType == SpaceType.WORLD_SPACE) {
				for (i = vertices.length-1; i>=0; i--) {
					v = vertices[i];
					x = v.worldX;
					y = v.worldY;
					z = v.worldZ;
					if (minX>x) minX = x;
					if (maxX<x) maxX = x;
					if (minY>y) minY = y;
					if (maxY<y) maxY = y;
					if (minZ>z) minZ = z;
					if (maxZ<z) maxZ = z;
				}
			} else if (spaceType == SpaceType.SCREEN_SPACE) {
				for (i = vertices.length-1; i>=0; i--) {
					v = vertices[i];
					x = v.screenX;
					y = v.screenY;
					z = v.screenZ;
					if (minX>x) minX = x;
					if (maxX<x) maxX = x;
					if (minY>y) minY = y;
					if (maxY<y) maxY = y;
					if (minZ>z) minZ = z;
					if (maxZ<z) maxZ = z;
				}
			} else {
				return bound;
			}
			bound.minX = minX;
			bound.maxX = maxX;
			bound.minY = minY;
			bound.maxY = maxY;
			bound.minZ = minZ;
			bound.maxZ = maxZ;
			return bound;
		}
		public function getBoundSphere(spaceType:String, boundSphere:BoundSphere=null):BoundSphere {
			var bs:BoundSphere = boundSphere == null ? new BoundSphere() : boundSphere;
			bs.setValueFromBoundBox(getBoundBox(spaceType));
			return bs;
		}
		public function localTranslate(x:Number = 0, y:Number = 0, z:Number = 0):void {
			if (vertices == null) return;
			for (var i:int = vertices.length-1; i>=0; i--) {
				var v:Vertex3D = vertices[i];
				v.localX += x;
				v.localY += y;
				v.localZ += z;
			}
		}
		public function resize(spaceType:String, newBoundBox:BoundBox, srcBoundBox:BoundBox, equalProportion:Boolean=true):void {
			if (vertices == null || newBoundBox == null || srcBoundBox == null) return;
			var length:int = vertices.length;
			var dnx:Number = newBoundBox.originX;
			var dny:Number = newBoundBox.originY;
			var dnz:Number = newBoundBox.originZ;
			var dsx:Number = srcBoundBox.originX;
			var dsy:Number = srcBoundBox.originY;
			var dsz:Number = srcBoundBox.originZ;
			var kx:Number = (newBoundBox.maxX-newBoundBox.minX)/(srcBoundBox.maxX-srcBoundBox.minX);
			var ky:Number = (newBoundBox.maxY-newBoundBox.minY)/(srcBoundBox.maxY-srcBoundBox.minY);
			var kz:Number = (newBoundBox.maxZ-newBoundBox.minZ)/(srcBoundBox.maxZ-srcBoundBox.minZ);
			if (equalProportion) {
				var k:Number = kx;
				if (k>ky) k = ky;
				if (k>kz) k = kz;
				kx = k;
				ky = k;
				kz = k;
			}
			var i:int;
			var v:Vertex3D;
			if (spaceType == SpaceType.LOCAL_SPACE) {
				for (i = 0; i<length; i++) {
					v = vertices[i];
					v.localX -= dsx;
					v.localY -= dsy;
					v.localZ -= dsz;
					v.localX *= kx;
					v.localY *= ky;
					v.localZ *= kz;
					v.localX += dnx;
					v.localY += dny;
					v.localZ += dnz;
				}
			} else if (spaceType == SpaceType.WORLD_SPACE) {
				for (i = 0; i<length; i++) {
					v = vertices[i];
					v.worldX -= dsx;
					v.worldY -= dsy;
					v.worldZ -= dsz;
					v.worldX *= kx;
					v.worldY *= ky;
					v.worldZ *= kz;
					v.worldX += dnx;
					v.worldY += dny;
					v.worldZ += dnz;
				}
			} else if (spaceType == SpaceType.SCREEN_SPACE) {
				for (i = 0; i<length; i++) {
					v = vertices[i];
					v.screenX -= dsx;
					v.screenY -= dsy;
					v.screenZ -= dsz;
					v.screenX *= kx;
					v.screenY *= ky;
					v.screenZ *= kz;
					v.screenX += dnx;
					v.screenY += dny;
					v.screenZ += dnz;
				}
			}
		}
	}
}