package rfcomponents.box
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	public class Box extends Sprite
	{
		protected var w:int;
		
		protected var h:int;
		public function Box()
		{
			super();
		}
		
		protected var _gap:int = 5;
		public function get gap():int{
			return _gap;
		}
		
		public function set gap(value:int):void{
			_gap = value;
			refreshPoint();
		}
		
		override public function addChild(child:DisplayObject):DisplayObject{
			child.addEventListener(Event.REMOVED,removeHandler);
			super.addChild(child);
			refreshPoint();
			return child;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject{
			child.addEventListener(Event.REMOVED,removeHandler);
			super.addChildAt(child,index);
			refreshPoint();
			return child;
		}
		
		protected function removeHandler(event:Event):void{
			IEventDispatcher(event.currentTarget).removeEventListener(Event.REMOVED,removeHandler);
			refreshPoint();
		}
		
		protected function refreshPoint():void{
			
		}
		
		override public function get width():Number{
			return w;
		}
		
		override public function get height():Number{
			return h;
		}
	}
}