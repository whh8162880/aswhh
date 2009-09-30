package asgl.math {
	import flash.geom.Vector3D;
	
	public class Triangle3D extends Plane3D {
		public function Triangle3D(p0:Vector3D, p1:Vector3D, p2:Vector3D):void {
			super(p0, p1, p2);
		}
		public override function containsPoint(point:Vector3D):Boolean {
			var b:Boolean = super.containsPoint(point);
			if (!b) return false;
			var d1:Number = Vector3D.distance(point0, point1);
			var d2:Number = Vector3D.distance(point0, point2);
			var d3:Number = Vector3D.distance(point1, point2);
			var c1:Number = Vector3D.distance(point, point0);
			var c2:Number = Vector3D.distance(point, point1);
			var c3:Number = Vector3D.distance(point, point2);
			var areaD:Number = area(d1, d2, d3);
			var area1:Number = area(c1, c2, d1);
			var area2:Number = area(c1, c3, d2);
			var area3:Number = area(c2, c3, d3);
			var s:Number = area1+area2+area3-areaD;
			if (s<0) s = -s;
			return s<=0.0001;
		}
		public override function getContainsPointValue(point:Vector3D, valueType:String):Number {
			var value:Number = super.getContainsPointValue(point, valueType);
			if (isNaN(value)) {
				return NaN;
			} else {
				var p:Vector3D = point.clone();
				if (valueType == 'x') {
					p.x = value;
				} else if (valueType == 'y') {
					p.y = value;
				} else {
					p.z = value;
				}
				if (containsPoint(p)) {
					return value;
				} else {
					return NaN;
				}
			}
		}
		public override function line3DIntersectPoint(line:Line3D):Vector3D {
			var p:Vector3D = super.line3DIntersectPoint(line);
			if (p == null) return null;
			var d1:Number = Vector3D.distance(point0, point1);
			var d2:Number = Vector3D.distance(point0, point2);
			var d3:Number = Vector3D.distance(point1, point2);
			var c1:Number = Vector3D.distance(p, point0);
			var c2:Number = Vector3D.distance(p, point1);
			var c3:Number = Vector3D.distance(p, point2);
			var areaD:Number = area(d1, d2, d3);
			var area1:Number = area(c1, c2, d1);
			var area2:Number = area(c1, c3, d2);
			var area3:Number = area(c2, c3, d3);
			var s:Number = area1+area2+area3-areaD;
			if (s<0) s = -s;
			if (s>0.0001) return null;
			return p;
		}
		/**
		 * a,b,c is concat of three lines.
		 */
		public static function area(a:Number, b:Number, c:Number):Number {
			var s:Number = (a+b+c)/2;
			return Math.sqrt(s*(s-a)*(s-b)*(s-c));
		}
	}
}