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
		public var id:String;
		public function MapResource(mapres:Array)
		{
			this.mapres = mapres;
			renders = [];
		}
		
		public var readly:Boolean
		public var type:String;
		public var renders:Array;
		public var x:int;
		public var y:int;
		public var ez:int;
		
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
		
		public function getResource(path:String,x:int,y:int):void{
			//ResourceManager.requestAsyncResource(path,CoreGlobal.mappath+path,LoaderType.STREAM,resourceGet);
			
//			new StreamAsyncRequest(StringUtils.substitute(CoreGlobal.mappath+path),path).invoke(resourceGet);
			readly = false;
			this.x = x;
			this.y = y;
			CoreGlobal.resourceSocket.streamAsyncRequest(CoreGlobal.mappath+path,resourceGet);
		}
		
		private var data:ByteArray;
		protected function resourceGet(id:String,data:Array):void{
			this.data = data[2];
			if(!this.data){
				return;
			}
			this.data.inflate();
			readly = true;
			complete();
		}
		
		protected function complete():void{
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function getColor(x:int,y:int):uint{
			if(!data){
				return 0x00FF00;
			}
			return mapres[data[y*100+x]];
		}
		
	}
}