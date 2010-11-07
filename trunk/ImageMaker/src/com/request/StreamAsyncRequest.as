package com.request
{
	import com.request.token.RemoteToken;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;
	import flash.net.URLVariables;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	public class StreamAsyncRequest extends BaseAsyncRequest
	{
		private var loader:URLStream;
		private var urlRequest:URLRequest;
		private var handler:Function;
		private var progressFunction:Function;
		public var swfHandler:Function;
		public function StreamAsyncRequest(url:String,value:URLVariables=null,useService:Boolean = false)
		{
			if(useService){
//				url = ""
			}
			
			urlRequest = new URLRequest(url)
			urlRequest.data = value
			
			loader = new URLStream()
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
			
			if(status.toString() != "200" && status.toString() != "0" && status.toString() != "304"){
				token.dispatchFailed(status.toString(),null);
				if(handler!=null){
					handler(null)
				}
			}else{
				
					
				var sa:ByteArray=new ByteArray()
				if(!loader){
					return
				}
				if(loader.bytesAvailable>0)
				{
					loader.readBytes(sa)
					sa.position = 0;
				}
				if(handler!=null){	
					handler(sa)
				}
				
				sa.position = 0;
				if(swfHandler != null ){
					getSwf(sa);
				}
				token.dispatchSuccessed(status.toString(),sa);
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
		
		public var appdomain:ApplicationDomain
		public var useCurrentDomain:Boolean = true;
		private function getSwf(ba:ByteArray):void{
			var result:Loader = new Loader()
			result.contentLoaderInfo.addEventListener(Event.COMPLETE,dispatchSuccess)
			if(useCurrentDomain){
				if(!appdomain){
					appdomain=new ApplicationDomain(ApplicationDomain.currentDomain)
				}
				
				var context:LoaderContext = new LoaderContext(false,appdomain );
				if(context.hasOwnProperty('allowLoadBytesCodeExecution')){
					context['allowLoadBytesCodeExecution']=true
				}
				result.loadBytes(ba,context)
			}else{
				result.loadBytes(ba)
			}
		}
		
		private function dispatchSuccess(event:Event):void{
			var li:LoaderInfo = LoaderInfo(event.currentTarget);
			li.removeEventListener(Event.COMPLETE,dispatchSuccess);
			if(swfHandler!=null)
				swfHandler(li.loader);
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