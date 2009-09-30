package asgl.math {
	import flash.geom.Vector3D;
	
	public class Line3D {
		public var point0:Vector3D;
		public var point1:Vector3D;
		public function Line3D(v0:Vector3D, v1:Vector3D):void {
			point0 = v0;
			point1 = v1;
		}
		/**
		 * return a new vector3D, the vector3D is not normalize.
		 */
		public function get vector():Vector3D {
			if (point0 == null || point1 == null) return null;
			return new Vector3D(point1.x-point0.x, point1.y-point0.y, point1.z-point0.z);
		}
	}
}