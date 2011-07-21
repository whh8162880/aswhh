package com.map
{
	import com.event.RFEventDispatcher;
	import com.net.request.StreamAsyncRequest;
	import com.net.request.utils.LoaderType;
	import com.theworld.core.CoreGlobal;
	import com.utils.ResourceManager;
	import com.utils.StringUtils;
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import mx.utils.StringUtil;
	
	public class MapResource extends RFEventDispatcher
	{
		private var mapres:Array;
		public function MapResource(mapres:Array)
		{
			this.mapres = mapres;
			renders = [];
		}
		
		public var type:String;
		public var renders:Array;
		public var x:int;
		public var y:int;
		public var ez:int;
		public function render(type:String,x:int,y:int,ez:int):void{
			this.type = type;
			getResource(x,y);
		}
		
		public function addMapRender(irender:IMapRender):void{
			if(renders.indexOf(irender) == -1){
				renders.push(irender);
			}
		}
		
		public function clearRender(irender:IMapRender):void{
			var i:int = renders.indexOf(irender);
			if(i!=-1){
				renders.splice(i,1);
			}
			if(!renders.length){
				complete();
			}
		}
		
		protected function getResource(x:int,y:int):void{
			var path:String = StringUtil.substitute("map{0}_{1}.dat",x,y);
			ResourceManager.requestAsyncResource(path,CoreGlobal.mappath+path,LoaderType.STREAM,resourceGet);
			
//			new StreamAsyncRequest(StringUtils.substitute(CoreGlobal.mappath+path),path).invoke(resourceGet);
		}
		
		protected function resourceGet(id:String,data:ByteArray):void{
			if(!data){
				return;
			}
			for each(var irender:IMapRender in renders){
				
			}
		}
		
		protected function complete():void{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
}