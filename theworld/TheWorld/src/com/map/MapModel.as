package com.map
{
	import com.event.RFEventDispatcher;
	
	import flash.geom.Point;

	/**
	 * 无限地图 
	 * @author whh
	 * 
	 */	
	public class MapModel extends RFEventDispatcher
	{
		public function MapModel()
		{
			init();
		}
		
		public var ew:int = 10;
		public var eh:int = 10;
		
		public var maxw:int;
		public var maxh:int;
		
		public var w:int = 3000;
		public var h:int = 3000;
		
		public var dw:int = 100;
		public var dh:int = 100;
		public function init():void{
			maxw = w*ew;
			maxh = h*eh;
		}
		
		public var currentZoom:Number;
		
		public function setScene(center:Point,width:int,height:int,zoom:Number):void{
			var l:int;
			var r:int;
			var t:int;
			var u:int;
		}
	}
}