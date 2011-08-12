package com.utils.box
{
	public class BoxVO
	{
		public function BoxVO()
		{
		}
		public var w:int;
		
		public var h:int;
		
		public var r:int;
		
		public function get area():int{
			return w*h;
		}
	}
}