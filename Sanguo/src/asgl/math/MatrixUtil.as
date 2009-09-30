package asgl.math {
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class MatrixUtil {
		public static function getProjectionMatrix(srcWidth:Number, srcHeight:Number, p0:Point, p1:Point, p2:Point):Matrix {
			var x0:Number = p0.x;
			var y0:Number = p0.y;
			var dx1:Number = p1.x-x0;
			var dy1:Number = p1.y-y0;
			var dx2:Number = p2.x-x0;
			var dy2:Number = p2.y-y0;
			var a1:Number = Math.atan2(dy1, dx1);
			var a2:Number = Math.atan2(dy2, dx2);
			var sx:Number = Math.sqrt(dx1*dx1+dy1*dy1)/srcWidth;
			var sy:Number = Math.sqrt(dx2*dx2+dy2*dy2)/srcHeight;
			return new Matrix(sx*Math.cos(a1), sx*Math.sin(a1), sy*Math.cos(a2), sy*Math.sin(a2), x0, y0);
		}
	}
}