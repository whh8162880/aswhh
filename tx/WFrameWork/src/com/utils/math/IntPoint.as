package com.utils.math
{
	public class IntPoint
	{
		public function IntPoint(x:int=0,y:int=0)
		{
			this.x = x;
			this.y = y;
		}
		
		public var x:int;
		
		public var y:int;
		
		public function getLength(dx:int,dy:int):int{
			dx -= x;
			dy -= y;
			return Math.sqrt(dx*dx + dy*dy);
		}
	}
}