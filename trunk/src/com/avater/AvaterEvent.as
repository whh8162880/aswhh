package com.avater
{
	import flash.events.Event;

	public class AvaterEvent extends Event
	{
		public var data:Object
		public function AvaterEvent(type:String, data:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data = data;
			super(type, bubbles, cancelable);
		}
		
		public static const CREATE_COMPLETE:String = "whh_avate_create_complete"
		public static const SELECTED:String = "whh_avate_selected"
		
	}
}