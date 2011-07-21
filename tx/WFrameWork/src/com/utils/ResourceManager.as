package com.utils
{
	import com.net.request.BaseAsyncRequest;
	import com.net.request.RequestQueueLoader;
	import com.net.request.SWFAsynRequest;
	import com.net.request.StreamAsyncRequest;
	import com.net.request.URLAsyncRequest;
	import com.net.request.event.RemoteOperationEvent;
	import com.net.request.utils.LoaderType;
	
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.Dictionary;

	public class ResourceManager
	{
		public function ResourceManager()
		{
		}
		
		private static var resourceDict:Dictionary = new Dictionary();
		private static var queue:RequestQueueLoader = new RequestQueueLoader();
		private static var requestDict:Dictionary = new Dictionary();
		public static function setResource(id:String,data:*):void{
			resourceDict[id] = data;
		}
		public static function getResource(id:String):*{
			return resourceDict[id]
		}
		
		public static function requestAsyncResource(id:String,url:String,type:int,loadHandler:Function = null):Object{
			return requesAsyncURLRequestResource(id,url,null,type,loadHandler);
		}
		
		public static function requesAsyncURLRequestResource(id:String,url:String,value:URLVariables,type:int,loadHandler:Function = null):Object{
			var o:Object = resourceDict[id]
			if(o){
				if(loadHandler!=null){
					loadHandler(id,o)
				}
				return o;
			}
			
			var vo:RequestVO = requestDict[id];
			if(!vo){
				vo = new RequestVO(id);
				vo.addHandler(loadHandler);
				requestDict[id] = vo;
			}else{
				vo.addHandler(loadHandler);
				return null;
			}
			
			
			var loader:BaseAsyncRequest;
			switch(type){
				case LoaderType.STREAM:
					loader = new StreamAsyncRequest(url,id,value);
					break;
				case LoaderType.URL:
					loader = new URLAsyncRequest(url,id,value);
					break;
				case LoaderType.SWF:
					loader = new SWFAsynRequest(url,id,value);
					break;
				case LoaderType.SOUND:
					return null;
					break;
			}
			
			
			
			queue.push(loader,queueLoadhandler,"");
			queue.start();
			
			return null
		}
		
		private static function queueLoadhandler(event:RemoteOperationEvent):void{
			var id:String = event.id;
			var vo:RequestVO = requestDict[id];
			if(vo){
				vo.doHandler(event.data);
				removeAllAsyncRequestResourceById(id);
			}
			resourceDict[id] = event.data;
		}
		
		
		public static function removeAsyncRequestResource(id:String,handler:Function):void{
			var vo:RequestVO = requestDict[id];
			if(vo && !vo.removeHandler(handler)){
				requestDict[id] = null;
				delete requestDict[id];
			}
		}
		
		public static function removeAllAsyncRequestResourceById(id:String):void{
			var vo:RequestVO = requestDict[id];
			if(vo){
				vo.clear();
				requestDict[id] = null;
				delete requestDict[id];
			}
		}
	}
}
class RequestVO{
	public function RequestVO(id:String){
		this.id = id;
		this.handlers = [];
	}
	
	public var id:String;
	
	public var handlers:Array;
	public function addHandler(handler:Function):void{
		if(handlers.indexOf(handler)==-1){
			handlers.push(handler);
		}
	}
	
	public function removeHandler(handler:Function):Boolean{
		var i:int = handlers.indexOf(handler);
		if(i>-1){
			handlers.splice(i,1);
		}
		return handlers.length > 0;
	}
	
	public function doHandler(data:Object):void{
		for each(var f:Function in handlers){
			f(id,data);
		}
	}
	
	public function clear():void{
		handlers.length = 0;
	}
	
	
}