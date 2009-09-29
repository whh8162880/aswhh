package asgl.math {
	import flash.geom.Point;
	public class Triangle2D {
		public var point1:Point;
		public var point2:Point;
		public var point3:Point;
		public function Triangle2D(p1:Point, p2:Point, p3:Point):void {
			point1 = p1;
			point2 = p2;
			point3 = p3;
		}
		public function containsPoint(point:Point):Boolean {
			if (point1 == null || point2 == null || point3 == null || point == null) return false;
			var v1x:Number = point2.x-point1.x;
			var v1y:Number = point2.y-point1.y;
			var v2x:Number = point3.x-point1.x;
			var v2y:Number = point3.y-point1.y;
			var u:Number = (point.x*v2y-point.y*v2x-point1.x*v2y+point1.y*v2x)/(v1x*v2y-v1y*v2x);
			if (isNaN(u) || u<0) return false;
			var v:Number;
			if (v2x == 0) {
				if (v2y == 0) {
					return false;
				} else {
					v = (point.y-point1.y-u*v1y)/v2y;
					if (v<0) return false;
				}
			} else {
				v = (point.x-point1.x-u*v1x)/v2x;
				if (v<0) return false;
			}
			if (isNaN(v)) return false;
			return u+v<=1;
		}
	}
}