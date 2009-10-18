package com.display.foucs
{
	import flash.events.EventDispatcher;
	import flash.events.FocusEvent;
	import flash.events.IEventDispatcher;

	public class FoucsManager extends EventDispatcher
	{
		private var target:IEventDispatcher
		public function FoucsManager(target:IEventDispatcher=null)
		{
			super(target);
		}
		
	}
}