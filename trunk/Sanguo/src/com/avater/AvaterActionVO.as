package com.avater
{
	import flash.display.BitmapData;
	
	public class AvaterActionVO
	{
		public function AvaterActionVO(actionName:String,direction:int,frame:int,bitmapData:BitmapData,nextAction:String = null)
		{
			this.direction = direction;
			this.actionName = actionName;
			this.bitmapData = bitmapData;
			this.frame = frame;
			this.nextAction = nextAction;
		}
		
		public var actionName:String;
		public var bitmapData:BitmapData;
		public var nextAction:String;
		public var direction:int
		public var frame:int

	}
}