package asgl.utils {
	import flash.display.Graphics;
	
	public class GraphicsUtil {
		public var graphics:Graphics;
		public function GraphicsUtil(g:Graphics):void {
			graphics = g;
		}
		public function drawFan(x:Number, y:Number, angle0:Number, angle1:Number, radius:Number):void {
			if (graphics != null) {
				graphics.moveTo(x, y);
				var sx:Number = Math.cos(angle0)*radius+x;
				var sy:Number = Math.sin(angle0)*radius+y;
				graphics.lineTo(sx, sy);
				var ex:Number = Math.cos(angle1)*radius+x;
				var ey:Number = Math.sin(angle1)*radius+y;
				var func:Function = function (x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number):Array {
					var a1:Number = x1-x0;
					var b1:Number = y1-y0;
					var c1:Number = -x1*x1+x0*x1+y0*sy-sy*sy;
					var a2:Number = x2-x0;
					var b2:Number = y2-y0;
					var c2:Number = -x2*x2+x0*x2+y0*y2-y2*y2;
					var cy:Number = (a1*c2-a2*c1)/(a2*b1-a1*b2);
					if (a1 == 0) {
						return [-(c2+b2*cy)/a2, cy];
					} else {
						return [-(c1+b1*cy)/a1, cy];
					}
				}
				var unitAngle:Number = Math.PI/3;
				var angle:Number = angle1-angle0;
				var k:int = angle/unitAngle;
				var k2:Number = angle%unitAngle;
				angle = angle0;
				var list:Array;
				for (var i:int = 0; i<k; i++) {
					angle += unitAngle;
					var cx:Number = Math.cos(angle)*radius+x;
					var cy:Number = Math.sin(angle)*radius+y;
					list = func(x, y, sx, sy, cx, cy);
					graphics.curveTo(list[0], list[1], cx, cy);
					sx = cx;
					sy = cy;
				}
				if (k2 != 0) {
					list = func(x, y, sx, sy, ex, ey); 
					graphics.curveTo(list[0], list[1], ex, ey);
				}
				graphics.lineTo(x, y);
			}
		}
	}
}