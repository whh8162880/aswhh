package com.request
{
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import com.request.token.RemoteToken;
	
	public class URLAsyncRequest extends BaseAsyncRequest
	{
		private var loader:URLLoader
		private var urlRequest:URLRequest
		private var handler:Function
		private var progressFunction:Function
		public function URLAsyncRequest(url:String,value:URLVariables=null,useService:Boolean = false)
		{
			if(useService){
				url = ""
			}
			
			urlRequest = new URLRequest(url)
			urlRequest.data = value
			
			loader = new URLLoader()
			
		}
		
		override public function invoke(handler:Function = null,progressFunction:Function = null):RemoteToken{
			this.handler = handler;
			this.progressFunction = progressFunction;
			loader.addEventListener(Event.COMPLETE,loaderHandler)
			loader.addEventListener(IOErrorEvent.IO_ERROR,ioHandler)
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpHandler)
//			loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,httpHandler)
			loader.addEventListener(ProgressEvent.PROGRESS,progresshandler)
			loader.load(urlRequest)
			
			return token;
		}
		
		private function disponse():void{
			loader.removeEventListener(Event.COMPLETE,loaderHandler)
			loader.removeEventListener(IOErrorEvent.IO_ERROR,ioHandler)
			loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,httpHandler)
//			loader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,httpHandler)
			loader.removeEventListener(ProgressEvent.PROGRESS,progresshandler)
			loader = null
			urlRequest = null;
			token = null
		}
		
		
		private function loaderHandler(event:Event):void{
			
			if(status.toString() != "200" && status.toString() != "0"){
				token.dispatchFailed(status.toString(),null);
				if(handler!=null){
					handler(null)
				}
			}else{
				token.dispatchSuccessed(status.toString(),event.target.data);
				if(handler!=null){
					handler(event.target.data)
				}
			}
			
			
			
			disponse()
		}
		
		private function ioHandler(event:IOErrorEvent):void{
			token.dispatchFault(status.toString(),event)
			if(handler!=null){
				handler(null)
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
				progressFunction(event)
			}
		}
		
		override public function close():void{
			try{
				loader.close();
			}catch(e:Error){
				
			}
			disponse();
			token.dispatchFault()
		}

	}
}