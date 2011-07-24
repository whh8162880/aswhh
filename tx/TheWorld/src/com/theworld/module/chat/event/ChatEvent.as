package com.theworld.module.chat.event
{
	import flash.events.Event;
	
	public class ChatEvent extends Event
	{
		public var data:Object;
		public function ChatEvent(type:String, data:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data = data;
			super(type, bubbles, cancelable);
		}
		
		public static const ADD_MESSAGE:String = 'chat_add_message';
		
		public static const CLEAR:String = 'chat_clear';
		
		public static const SEND_MESSAGE:String = 'chat_send_message';
	}
}