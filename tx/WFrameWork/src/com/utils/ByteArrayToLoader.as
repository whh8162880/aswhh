package com.utils
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;

	public class ByteArrayToLoader
	{
		private var handler:Function
		public function ByteArrayToLoader(byteArray:ByteArray,handler:Function)
		{
			this.handler = handler;
			var result:Loader = new Loader()
			result.contentLoaderInfo.addEventListener(Event.COMPLETE,dispatchSuccessd)
		//	if(useCurrentDomain){
				//if(!appdomain){
				var appdomain:ApplicationDomain=new ApplicationDomain(ApplicationDomain.currentDomain)
				//}
				
				var context:LoaderContext = new LoaderContext(false,appdomain );
				if(context.hasOwnProperty('allowLoadBytesCodeExecution')){
					context['allowLoadBytesCodeExecution']=true
				}
				result.loadBytes(byteArray,context)
			//}else{
			//	result.loadBytes(ba)
			//}
		}
		
		private function dispatchSuccessd(event:Event):void{
			var li:LoaderInfo = LoaderInfo(event.currentTarget);
			li.removeEventListener(Event.COMPLETE,dispatchSuccessd);
			if(handler!=null)
				handler(li.loader);
		}
		
	}
}