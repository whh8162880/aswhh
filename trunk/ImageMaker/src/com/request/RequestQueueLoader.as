package com.clay.rpc
{
	import com.request.event.RemoteOperationEvent;
	import com.request.token.RemoteToken;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;

	public class RequestQueueLoader extends EventDispatcher
	{
		
		private var queuelist:Array;
		private var _currentReuestItem:Queue;
//		private var complteCount:int;
//		private var faultCount:int;
		public function RequestQueueLoader()
		{
			queuelist = []
		}
		
		public function push(load:IQueueLoadItem,tokenHandler:Function,displayLabel:String):void{
			queuelist.push(new Queue(load,tokenHandler,displayLabel));
		}
		
		public function start():void{
			doRequest();
		}
		
		private function doRequest():void{
			if(!queuelist.length) return;
			var q:Queue = Queue(queuelist.shift());
			_currentReuestItem = q;
			trace(q.displayLabel + " loading")
			var token:RemoteToken = q.load.load();
			token.addEventListener(ProgressEvent.PROGRESS,wrapedHandler);
			token.addEventListener(RemoteOperationEvent.REMOTE_OPERATION_DATA_FAILED,wrapedHandler);
			token.addEventListener(RemoteOperationEvent.REMOTE_OPERATION_FAULT,wrapedHandler);
			token.addEventListener(RemoteOperationEvent.REMOTE_OPERATION_SUCCESED,wrapedHandler);
		}
		
		private function wrapedHandler(event:Event):void
		{
			var token:RemoteToken = RemoteToken(event.target);
			token.removeEventListener(ProgressEvent.PROGRESS,wrapedHandler);
			token.removeEventListener(RemoteOperationEvent.REMOTE_OPERATION_DATA_FAILED,wrapedHandler);
			token.removeEventListener(RemoteOperationEvent.REMOTE_OPERATION_FAULT,wrapedHandler);
			token.removeEventListener(RemoteOperationEvent.REMOTE_OPERATION_SUCCESED,wrapedHandler);
			
			if((_currentReuestItem.tokenHandler!=null)&&(event is RemoteOperationEvent))
				_currentReuestItem.tokenHandler.call(this,event);
			
			
			_currentReuestItem = null
//			switch(event.type)
//			{
//				case RemoteOperationEvent.REMOTE_OPERATION_DATA_FAILED:
//				case RemoteOperationEvent.REMOTE_OPERATION_FAULT:
//				case RemoteOperationEvent.REMOTE_OPERATION_SUCCESED:
////				LoadingPopupManager.getInstance().hide('async_queue');
//				break;
//			}
			doRequest();
		}
		
	}
}
	import com.clay.rpc.IQueueLoadItem;
	

class Queue{
	public function Queue(load:IQueueLoadItem,tokenHandler:Function,displayLabel:String){
		this.load = load;
		this.tokenHandler = tokenHandler;
		this.displayLabel = displayLabel;
	}
	
	public var load:IQueueLoadItem;
	public var tokenHandler:Function;
	public var displayLabel:String;
}