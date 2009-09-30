package
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	public class LoaderList extends EventDispatcher
	{
		public function LoaderList()
		{
			
		}
		
		private var loadedImages:Array
		private var _imgurls:Array;
		public function loadImgs(imgurls:Array):void{
		   _imgurls = imgurls;
		}
		
		public function getLoadedImages():Array{
			return loadedImages;
		}
		
		public function load():void{
			if(_imgurls && _imgurls.length < 1){
				this.dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			var url:String = _imgurls.pop();
			var loader:Loader = new Loader()
			var request = new URLRequest(url);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loaderComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loaderfailed);
			loader.load(request);
		}
		
		private function loaderComplete(event:Event):void{
			var loader:Loader = (event.target as LoaderInfo).loader
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,loaderComplete);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,loaderfailed);
			if(loadedImages == null){
				loadedImages = []
			}
			loadedImages.push(loader.content);
			//todo
			
			load();
		}
		
		private function loaderfailed(event:Event):void{
			if(loadedImages == null){
				loadedImages = []
			}
			load();
		}
		
		
		

	}
}