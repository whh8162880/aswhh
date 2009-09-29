package com.map
{
	import flash.events.Event;

	public class MapDataEvent extends Event
	{
		public var data:Object
		public function MapDataEvent(type:String, data:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data = data
			super(type, bubbles, cancelable);
		}
		
		public static const UP_DATA:String = "up_data";
		
		public static const MAP_CLICK:String = "map_click"
		
	}
}