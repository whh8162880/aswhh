package com.display.image
{
	import com.youbt.events.RFLoaderEvent;
	import com.youbt.net.RFLoader;
	import com.youbt.net.RFStreamLoader;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	
	public class ImageBase extends EventDispatcher
	{
		public function ImageBase()
		{
		}
		
		protected var _images:Array 
		public function getImages():Array{
			return _images;
		}
		
		public function loadImage(url:String):void{
			var loader:RFLoader = getLoader(url);
			loader.url = url;
			loader.addEventListener(RFLoaderEvent.COMPLETE,loaderHandler);
			loader.addEventListener(RFLoaderEvent.PROGRESS,loaderProgressHandler);
			loader.addEventListener(RFLoaderEvent.FAILED,loaderHandler);
			loader.addEventListener(RFLoaderEvent.TIMEOUT,loaderHandler);
			loader.load();
		}
		
		protected function getLoader(url:String):RFLoader{
			return new RFStreamLoader(url);;
		}
		
		protected function loaderHandler(event:RFLoaderEvent):void{
			var loader:IEventDispatcher = event.currentTarget as IEventDispatcher
			loader.removeEventListener(RFLoaderEvent.COMPLETE,loaderHandler);
			loader.removeEventListener(RFLoaderEvent.PROGRESS,loaderProgressHandler);
			loader.removeEventListener(RFLoaderEvent.FAILED,loaderHandler);
			loader.removeEventListener(RFLoaderEvent.TIMEOUT,loaderHandler);
			
			switch(event.type){
				case RFLoaderEvent.COMPLETE:
					var b:ByteArray = event.arg as ByteArray;
					b.position = 0;
					doComplete(event.result,b);
					dispatchEvent(event);
				break;
				case RFLoaderEvent.FAILED:
					doFailed(event.result,event.arg);
				break;
				case RFLoaderEvent.TIMEOUT:
					doTimeout(event.result,event.arg);
				break;
			}
		}
		
		protected function loaderProgressHandler(event:RFLoaderEvent):void{
			
		}
		
		protected function doComplete(data:Object,arg:Object):void{
		}
		
		protected function doFailed(data:Object,arg:Object):void{
			
		}
		
		protected function doTimeout(data:Object,arg:Object):void{
			
		}
		

	}
}