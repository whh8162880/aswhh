package com.net.request
{
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	public class SWFAsynRequest extends BaseAsyncRequest
	{
		
		private var loader:Loader
		private var urlRequest:URLRequest
		
		public function SWFAsynRequest(url:String=null,id:String= null,value:URLVariables=null,useService:Boolean = false,targetLoader:Loader = null)
		{
			resetInfo(url,id,value,useService,targetLoader);
		}
		
		public function resetInfo(url:String = null,id:String= null,value:URLVariables=null,useService:Boolean = false,targetLoader:Loader = null):void
		{
			if(useService){
				//				url = ""
			}
			urlRequest = new URLRequest(url)
			urlRequest.data = value;
			if(!targetLoader) {
				targetLoader = new Loader();
			}else{
				targetLoader.unloadAndStop();
			}
			loader = targetLoader;
			
			if(!id){
				this.id = id;
			}
		}
		
		override public function load():EventDispatcher{
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaderHandler)
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ioHandler)
			loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpHandler)
			if(progressFunction != null)
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,progresshandler);
			//			loader.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,httpHandler)
			loader.load(urlRequest);
			return super.load();
		}
		
		private function disponse():void{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loaderHandler)
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,ioHandler)
			loader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS,httpHandler)
			loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,progresshandler);
//			loader.removeEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,httpHandler)
			loader = null
			urlRequest = null;
		}
		
		
		private function loaderHandler(event:Event):void{
			
			if(!loader.content){
				dispatchFault(null);
				if(handler!=null){
					handler(id,null)
				}
			}else{
				dispatchSuccess(loader);
				if(handler!=null){
					handler(id,loader)
				}
			}
			
			
			
			disponse()
		}
		
		private function ioHandler(event:IOErrorEvent):void{
			dispatchIOError(event);
			if(handler!=null){
				handler(id,null)
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
				progressFunction(id,event)
			}
		}
		
		override public function close():void{
			try{
				loader.close();
			}catch(e:Error){
				
			}
			dispatchFault(null);
			disponse();
		}
		
	}
}