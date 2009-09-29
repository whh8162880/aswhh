package com.map
{
	import flash.geom.Point;
	
	public class MapDataVO
	{
		public function MapDataVO(x:int,y:int,width:int,height:int,eachLength:Number)
		{
			this.x = x;
			this.y = y;
			this.width = width;
			this.height	= height;
			this.eachLength = eachLength;
		}
		
		public var eachLength:Number
		public var x:int;
		public var y:int;
		public var width:int;
		public var height:int;
		
		
		public function checkInThis(_x:int,_y:int):Boolean{
			if(_x<x-1) return false;
			if(_y<y-1) return false;
			if(_x > x+width) return false;
			if(_y > y+height) return false;
			return true;
		}
	}
}