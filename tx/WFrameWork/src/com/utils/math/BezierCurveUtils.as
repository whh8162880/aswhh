package com.utils.math
{
	public class BezierCurveUtils
	{
		public function BezierCurveUtils()
		{
		}
		
		/**
		 * 
		 * @param p0
		 * @param p1
		 * @param p2
		 * @param t (0<t<1)
		 * @return 
		 * 
		 */		
		public static function point2Bezier(p0:IntPoint,p1:IntPoint,p2:IntPoint,t:Number):IntPoint{
			var dt:Number = 1-t;
			var result:IntPoint = new IntPoint();
			result.x = dt*dt*p0.x + 2*t*dt*p1.x + t*t*p2.x;
			result.y = dt*dt*p1.y + 2*t*dt*p1.y + t*t*p2.y;
			return result;
		}
		
		public static function cmpute2Bezier(p0:IntPoint,p1:IntPoint,p2:IntPoint,count:int):Array{
			var dt:Number = 1/(count-1);
			var curve:Array = [];
			for(var i:int =0;i<count;i++){
				curve[i] = point2Bezier(p0,p1,p2,(i+1)*dt);
			}
			return curve;
		}
	}
}