package com.map
{
	import flash.events.EventDispatcher;

	public class MapRenderBase extends EventDispatcher
	{
		protected var mapdata:MapDataBase
		public function MapRenderBase()
		{
			
		}
		
		protected function createMap():void{
			
		}
		public function setMapdata(mapdata:MapDataBase):void{
			var mapRenderdata:Array = mapdata.maprenderdata
		}
		
		public function render():void{
			
		}
		
		
	}
}