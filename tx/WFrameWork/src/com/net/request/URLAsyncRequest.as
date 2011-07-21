package com.net.request
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	public class URLAsyncRequest extends BaseAsyncRequest
	{
		private var loader:URLLoader
		private var urlRequest:URLRequest
		public function URLAsyncRequest(url:String,id:String = null,value:URLVariables=null,useService:Boolean = false)
		{
			if(useService){
				url = ""
			}
			
			urlRequest = new URLRequest(url)
			urlRequest.data = value
			loader = new URLLoader();
			if(!id){
				id = url;
			}
			super(id);
			
		}
		
		override public function load():EventDispatcher{
			loader.addEventListener(Event.COMPLETE,loaderHandler)
			loader.addEventListener(IOErrorEvent.IO_ERROR,ioHandler)
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpHandler)
			//			loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,httpHandler)
			loader.addEventListener(ProgressEvent.PROGRESS,progresshandler)
			loader.load(urlRequest);
			return super.load();
		}
		
		private function disponse():void{
			loader.removeEventListener(Event.COMPLETE,loaderHandler)
			loader.removeEventListener(IOErrorEvent.IO_ERROR,ioHandler)
			loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,httpHandler)
//			loader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,httpHandler)
			loader.removeEventListener(ProgressEvent.PROGRESS,progresshandler)
			loader = null
			urlRequest = null;
		}
		
		
		private function loaderHandler(event:Event):void{
			if(pageCompleteStates.indexOf(status.toString())==-1){
				dispatchFault(null);
				if(handler!=null){
					handler(id,null)
				}
			}else{
				dispatchSuccess(event.target.data);
				if(handler!=null){
					handler(id,event.target.data)
				}
			}
			disponse();
		}
		
		private function ioHandler(event:IOErrorEvent):void{
			dispatchIOError(event)
			if(handler!=null){
				handler(id,null)
			}
			disponse()
		}
		
		private var status:Object 
		private function httpHandler(event:HTTPStatusEvent):void{
			status = event.status
		}
		
		private function progresshandler(event:ProgressEvent):void{
			if(progressFunction!=null)
			{
				progressFunction(id,event)
			}
		}
		
		override public function close():void{
			try{
				loader.close();
			}catch(e:Error){
				
			}
			dispatchFault(null)
			disponse();
		}

	}
}