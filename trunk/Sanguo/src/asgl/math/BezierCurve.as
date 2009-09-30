package asgl.math {
	import flash.geom.Point;
	
	public class BezierCurve {
		private var _a0:Point;
		private var _a1:Point;
		private var _c0:Point;
		private var _c1:Point;
		public function BezierCurve(anchor0:Point, control0:Point, control1:Point, anchor1:Point):void {
			_a0 = anchor0;
			_a1 = anchor1;
			_c0 = control0;
			_c1 = control1;
		}
		/**
		 * @param t the t value 0-1.
		 */
		public function getPoint(t:Number):Point {
			var b:Number = 1-t;
			var b2:Number = b*b;
			var b3:Number = b2*b;
			var t2:Number = t*t;
			var t3:Number = t2*t;
			return new Point(_a0.x*b3+3*_c0.x*b2*t+3*_c1.x*b*t2+_a1.x*t3, _a0.y*b3+3*_c0.y*b2*t+3*_c1.y*b*t2+_a1.y*t3);
		}
	}
}