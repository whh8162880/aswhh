package com.socket.client.event
{
	import flash.events.Event;
	
	public class GroupEvent extends Event
	{
		public function GroupEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public static const ADD_GROUP:String = 'groupevent_add_group';
		
		public static const REMOVE_GROUP:String = 'groupevent_remove_group';
		
		public static const ADD_CLIENT:String = 'groupevent_add_client';
		
		public static const REMOVE_CLIENT:String = 'groupevent_remove_client';
	}
}