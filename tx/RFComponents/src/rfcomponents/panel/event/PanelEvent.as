package rfcomponents.panel.event
{
	import flash.events.Event;
	
	public class PanelEvent extends Event
	{
		public function PanelEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		public static const SHOW:String = 'panelevent_show';
		public static const HIDE:String = 'panelevent_hide';
	}
}