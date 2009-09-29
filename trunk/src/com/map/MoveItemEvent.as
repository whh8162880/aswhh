package com.map
{
	import flash.events.Event;
	import flash.geom.Point;

	public class MoveItemEvent extends Event
	{
		public var movePoint:Point;
		public var direction:int;
		public function MoveItemEvent(type:String,movePoint:Point,direction:int,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.movePoint = movePoint;
			this.direction = direction;
			super(type, bubbles, cancelable);
		}
		
		public static const MOVE_START:String = "whh_move_start";
		public static const MOVE_CHANGE:String = "whh_move_change";
		public static const MOVE_END:String = "whh_move_end";
		public static const MOVE_STOP:String = "whh_move_stop";
		
	}
}