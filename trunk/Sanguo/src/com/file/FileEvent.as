package com.file
{
	import flash.events.Event;

	public class FileEvent extends Event
	{
		public var data:Object;
		public var filetype:String;
		public var url:String;
		public function FileEvent(type:String, filetype:String = '',url:String = '',data:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data = data;
			this.filetype = filetype;
			this.url = url;
			super(type, bubbles, cancelable);
		}
		
		public static const OPEN:String = "whh_fileevent_open";
		
		public static const SAVE:String = 'whh_fileevent_save'
		
	}
}