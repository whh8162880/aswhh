package rfcomponents.tab
{
	import flash.events.Event;
	
	import rfcomponents.tab.render.TabItem;
	
	public class TabEvent extends Event
	{
		public var tabItem:TabItem;
		public function TabEvent(type:String,tabItem:TabItem =null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.tabItem = tabItem;
			super(type, bubbles, cancelable);
		}
		
		public static const CHANGE:String = "TAB_EVENT_CHANGE":
		
		public static const SELECT:String = 'TAB_EVENT_SELECT';
		
		public static const ADD_ITEM:String = 'TAB_EVENT_ADD_ITEM';
		
		public static const REMOVE_ITEM:String = 'TAB_EVENT_REMOVE_ITEM';
		
	}
}