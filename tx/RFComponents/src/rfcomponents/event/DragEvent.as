package rfcomponents.event
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	public class DragEvent extends Event
	{
		public var dragTarget:IEventDispatcher
		public function DragEvent(type:String, target:IEventDispatcher,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.dragTarget = target;
			super(type, bubbles, cancelable);
		}
		
		/**
		 * 推拽开始 
		 */		
		public static const DRAG_START:String = 'drag_start';
		
		/**
		 * 推拽结束
		 */		
		public static const DRAG_STOP:String = 'drag_stop';
	}
}