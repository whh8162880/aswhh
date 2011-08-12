package com.utils.box
{
	public class BoxUtils
	{
		public function BoxUtils()
		{
		}
		
		public function start(arr:Array):void{
			arr = arr.sortOn("area");
		}
		
	}
}