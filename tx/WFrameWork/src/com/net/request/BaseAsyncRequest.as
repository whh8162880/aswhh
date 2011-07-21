package com.net.request
{
	import com.event.RFEventDispatcher;
	import com.net.request.event.RemoteOperationEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	
	public class BaseAsyncRequest extends RFEventDispatcher implements IQueueLoadItem
	{
		public var id:String;
		protected var handler:Function;
		protected var progressFunction:Function;
		public function BaseAsyncRequest(id:String = null)
		{
			this.id = id;
		}
		
		public function close():void{
			
		}
		
		public function invoke(handler:Function = null,progressFunction:Function = null):void{
			this.handler  = handler;
			this.progressFunction = progressFunction;
			load();
		}
		
		public function load():EventDispatcher{
			return this
		}
		
		protected function dispatchIOError(event:IOErrorEvent):void{
			//this.dispatchEvent(event);
			dispatchFault();
		}
		
		protected function dispatchFault(data:* = null):void{
			this.dispatchEvent(new RemoteOperationEvent(RemoteOperationEvent.REMOTE_OPERATION_FAULT,id,data));
		}
		
		protected function dispatchSuccess(data:*):void{
			this.dispatchEvent(new RemoteOperationEvent(RemoteOperationEvent.REMOTE_OPERATION_SUCCESED,id,data));
		}
		
		protected var pageCompleteStates:Array = ["0","200","304"]

	}
}