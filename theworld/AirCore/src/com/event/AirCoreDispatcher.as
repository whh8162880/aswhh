package com.event
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class AirCoreDispatcher extends EventDispatcher
	{
		public function AirCoreDispatcher(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		
		public static var instance:AirCoreDispatcher = new AirCoreDispatcher;
		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
			instance.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void{
			instance.removeEventListener(type,listener,useCapture);
		}
		
		public static function dispatchEvent(type:String,data:*=null):Boolean{
			return instance.dispatchEvent(new AirCoreEvent(type,data));
		}
	}
}