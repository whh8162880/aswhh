package com.net.request
{
	import com.net.request.event.RemoteOperationEvent;
	
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
			if(!isStart){
				doRequest();
			}
		}
		
		private var isStart:Boolean;
		private function doRequest():void{
			if(!queuelist.length) {
				this.dispatchEvent(new Event(Event.COMPLETE));
				return;
			};
			isStart = true;
			var q:Queue = Queue(queuelist.shift());
			_currentReuestItem = q;
			var token:EventDispatcher = q.load.load();
			token.addEventListener(ProgressEvent.PROGRESS,wrapedHandler);
			token.addEventListener(RemoteOperationEvent.REMOTE_OPERATION_DATA_FAILED,wrapedHandler);
			token.addEventListener(RemoteOperationEvent.REMOTE_OPERATION_FAULT,wrapedHandler);
			token.addEventListener(RemoteOperationEvent.REMOTE_OPERATION_SUCCESED,wrapedHandler);
		}
		
		private function wrapedHandler(event:Event):void
		{
			var token:EventDispatcher = EventDispatcher(event.currentTarget);
			token.removeEventListener(ProgressEvent.PROGRESS,wrapedHandler);
			token.removeEventListener(RemoteOperationEvent.REMOTE_OPERATION_DATA_FAILED,wrapedHandler);
			token.removeEventListener(RemoteOperationEvent.REMOTE_OPERATION_FAULT,wrapedHandler);
			token.removeEventListener(RemoteOperationEvent.REMOTE_OPERATION_SUCCESED,wrapedHandler);
			
			if((_currentReuestItem.tokenHandler!=null)&&(event is RemoteOperationEvent))
				_currentReuestItem.tokenHandler.call(this,event);
			
			
			_currentReuestItem = null
			isStart = false;
			doRequest();
		}
		
	}
}
	import com.net.request.IQueueLoadItem;
	

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