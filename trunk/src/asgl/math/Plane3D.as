package asgl.math {
	import flash.geom.Vector3D;
	
	public class Plane3D {
		public var point0:Vector3D;
		public var point1:Vector3D;
		public var point2:Vector3D;
		public function Plane3D(p0:Vector3D, p1:Vector3D, p2:Vector3D):void {
			point0 = p0;
			point1 = p1;
			point2 = p2;
		}
		/**
		 * return a new vector3D, the vector3D is not normalize.
		 */
		public function get vector():Vector3D {
			if (point0 == null || point1 == null || point2 == null) return null;
			var v0X:Number = point0.x;
			var v0Y:Number = point0.y;
			var v0Z:Number = point0.z;
			var abX:Number = point1.x-v0X;
			var abY:Number = point1.y-v0Y;
			var abZ:Number = point1.z-v0Z;
			var acX:Number = point2.x-v0X;
			var acY:Number = point2.y-v0Y;
			var acZ:Number = point2.z-v0Z;
			return new Vector3D(abY*acZ-abZ*acY, abZ*acX-abX*acZ, abX*acY-abY*acX);
		}
		public function containsPoint(point:Vector3D):Boolean {
			if (point == null) return false;
			var v:Vector3D = this.vector;
			if (v == null) return false;
			v.normalize();
			return v.x*(point.x-point0.x)+v.y*(point.y-point0.y)+v.z*(point.z-point0.z) == 0;
		}
		public function getContainsPointValue(point:Vector3D, valueType:String):Number {
			var v:Vector3D = this.vector;
			if (v == null) return NaN;
			var k:Number = v.x*point0.x+v.y*point0.y+v.z*point0.z
			if (valueType == 'x') {
				return (k-v.y*point.y-v.z*point.z)/v.x;
			} else if (valueType == 'y') {
				return (k-v.x*point.x-v.z*point.z)/v.y;
			} else if (valueType == 'z') {
				return (k-v.x*point.x-v.y*point.y)/v.z;
			} else {
				return NaN;
			}
		}
		public function line3DIntersectPoint(line:Line3D):Vector3D {
			var v1:Vector3D = this.vector;
			if (v1 == null) return null;
			var v2:Vector3D = line.vector;
			if (v2 == null) return null;
			var k:Number = v1.x*v2.x+v1.y*v2.y+v1.z*v2.z;
			if (k == 0) return null;
			var p:Vector3D = line.point1;
			var t:Number = -(v1.x*p.x+v1.y*p.y+v1.z*p.z-v1.x*point0.x-v1.y*point0.y-v1.z*point0.z)/k;
			return new Vector3D(v2.x*t+p.x, v2.y*t+p.y, v2.z*t+p.z);
		}
	}
}