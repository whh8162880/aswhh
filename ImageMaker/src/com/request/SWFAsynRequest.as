package com.request
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import com.request.token.RemoteToken;
	
	public class SWFAsynRequest extends BaseAsyncRequest
	{
		
		private var loader:Loader
		private var urlRequest:URLRequest
		private var handler:Function
		private var progressFunction:Function
		
		public function SWFAsynRequest(url:String,value:URLVariables=null,useService:Boolean = false,targetLoader:Loader = null)
		{
			if(useService){
//				url = ""
			}
			
			urlRequest = new URLRequest(url)
			urlRequest.data = value;
			if(!targetLoader) {
				targetLoader = new Loader();
			}
			loader = targetLoader;
			loader.unloadAndStop();
		}
		
		override public function invoke(handler:Function = null,progressFunction:Function = null):RemoteToken{
			this.handler = handler;
			this.progressFunction = progressFunction;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaderHandler)
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioHandler)
			loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpHandler)
			if(progressFunction != null)
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progresshandler);
//			loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,httpHandler)
			loader.load(urlRequest)
			
			return token;
		}
		
		private function disponse():void{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loaderHandler)
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioHandler)
			loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS,httpHandler)
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,progresshandler);
//			loader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,httpHandler)
			loader = null
			urlRequest = null;
			token = null
		}
		
		
		private function loaderHandler(event:Event):void{
			
			if(!loader.content){
				token.dispatchFailed(status.toString(),null);
				if(handler!=null){
					handler(null)
				}
			}else{
				token.dispatchSuccessed(status.toString(),loader);
				if(handler!=null){
					handler(loader)
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
		
		public var status:Object 
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