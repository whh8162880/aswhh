package com.display.event
{
	import flash.events.Event;

	public class LayoutEvent extends Event
	{
		public var data:Object
		public function LayoutEvent(type:String, data:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data = data;
			super(type, bubbles, cancelable);
		}
		
		public static const BUILD:String = "whh_layout_build";
		
	}
}