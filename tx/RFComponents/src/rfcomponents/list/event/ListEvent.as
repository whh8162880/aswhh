package rfcomponents.list.event
{
	import flash.events.Event;
	
	public class ListEvent extends Event
	{
		public var data:Object;
		public function ListEvent(type:String, data:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data = data;
			super(type, bubbles, cancelable);
		}
		
		public static const LIST_ITEM_ROLL_OVER:String = 'list_item_roll_over';
		
		public static const LIST_ITEM_ROLL_OUT:String = 'list_item_roll_out';
		
		public static const LIST_ITEM_CLICK:String = 'list_item_click';
		
		public static const LIST_ITEM_DOUBLE_CLICK:String = 'list_item_double_click';
		
		public static const LIST_ITEM_SELETE:String = 'list_item_selete';
	}
}