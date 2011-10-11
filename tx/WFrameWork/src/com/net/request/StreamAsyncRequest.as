package com.net.request
{
	import com.net.request.event.RemoteOperationEvent;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
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
		private var swfFlag:Boolean
		public function StreamAsyncRequest(url:String,id:String = null,value:URLVariables=null,useService:Boolean = false,swfFlag:Boolean=false)
		{
			if(useService){
//				url = ""
			}
			
			urlRequest = new URLRequest(url)
			urlRequest.data = value
			loader = new URLStream();
			this.swfFlag = swfFlag;
			if(!id){
				id = url;
			}
			
			super(id);
		}
		
		
		override public function load():EventDispatcher{
			loader.addEventListener(Event.COMPLETE,loaderHandler)
			loader.addEventListener(IOErrorEvent.IO_ERROR,ioHandler)
			loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpHandler)
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
			
			if(pageCompleteStates.indexOf( status.toString())==-1){
				dispatchFault(null);
				if(handler!=null){
					handler(id,null)
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
				
				
				sa.position = 0;
				result = sa;
				if(swfFlag){
					getSwf(sa);
				}else{
					if(handler!=null){	
						handler(id,sa)
					}
				}
				dispatchSuccess(sa);
			}
			
			
			
			disponse()
		}
		
		public var result:ByteArray;
		
		private function ioHandler(event:IOErrorEvent):void{
			dispatchIOError(event);
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
		
		public var appdomain:ApplicationDomain
		public var useCurrentDomain:Boolean = true;
		private function getSwf(ba:ByteArray):void{
			var result:Loader = new Loader()
			result.contentLoaderInfo.addEventListener(Event.COMPLETE,dispatchSuccessd)
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
		
		private function dispatchSuccessd(event:Event):void{
			var li:LoaderInfo = LoaderInfo(event.currentTarget);
			li.removeEventListener(Event.COMPLETE,dispatchSuccessd);
			this.dispatchEvent(new RemoteOperationEvent(RemoteOperationEvent.REMOTE_STEAM_LOADER_COMPLETE,id,li.loader));
			if(handler!=null)
				handler(id,result,li.loader);
		}
		
		
		override public function close():void{
			try{
				loader.close();
			}catch(e:Error){
				
			}
			disponse();
			dispatchFault(null);
		}

	}
}