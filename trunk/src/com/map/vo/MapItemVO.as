package com.map.vo
{
	import flash.display.DisplayObject;
	
	public class MapItemVO{
		public function MapItemVO(item:DisplayObject,x:int,y:int,width:int = 1,height:int = 1){
			this.item = item;
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
		}
		
		public var item:DisplayObject;
		public var x:int;
		public var y:int;
		public var width:int;
		public var height:int;
	}
}