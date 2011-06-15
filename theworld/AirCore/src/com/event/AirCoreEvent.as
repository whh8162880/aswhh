package com.event
{
	import flash.events.Event;
	
	public class AirCoreEvent extends Event
	{
		public var data:*
		public function AirCoreEvent(type:String,data:*=null bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data = data;
			super(type, bubbles, cancelable);
		}
	}
}