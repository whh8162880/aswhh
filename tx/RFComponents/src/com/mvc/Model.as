package com.mvc
{
	import com.event.RFEventDispatcher;
	
	import flash.events.IEventDispatcher;
	
	public class Model extends RFEventDispatcher
	{
		public function Model(target:IEventDispatcher=null)
		{
			super(target)
		}
		
		public function dispose():void{
			this.removeAllListener();
		}
	}
}