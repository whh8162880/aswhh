package com.map.event
{
	import flash.events.Event;
	
	public class MapEvent extends Event
	{
		public var data:Object
		public function MapEvent(type:String,data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data = data;
			super(type, bubbles, cancelable);
		}
		
		public static const RES_LOAD_COMPLETE:String = 'res_load_complete';
	}
}