package com.map
{
	import com.event.RFEventDispatcher;
	import com.map.event.MapEvent;
	import com.mvc.Model;
	import com.theworld.core.CoreGlobal;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;

	/**
	 * 无限地图 
	 * @author whh
	 * 
	 */	
	public class MapModel extends Model
	{
		public function MapModel()
		{
			renderDict = new Dictionary();
			mapresDict = new Dictionary();
			init();
		}
		
		public function init():void{
			w = 40;
			h = 40;
			pw = w*100;
			ph = h*100;
		}
		
		public function setMapres(value:Array):void{
			mapres = value;
		}
		
		public var w:int;
		public var h:int;
		public var ez:int = 1;
		public var mapres:Array = [];
		public var currentZoom:Number;
		public var topx:int;
		public var topy:int;
		
		public var renderDict:Dictionary;
		
		public function render(x:int,y:int,irender:IMapRender):void{
			var type:String = x+"_"+y;
			var renderItem:MapResource = renderDict[type];
			if(!renderItem){
				renderItem = new MapResource(mapres);
				renderDict[type] = renderItem;
			//	renderItem.render(type,x,y,ez);
			}
			renderItem.addMapRender(irender);
			renderItem.addEventListener(Event.COMPLETE,renderItemCompleteHandler);
		}
		
		public function cancelRender(x:int,y:int,irender:IMapRender):void{
			var type:String = x+"_"+y;
			var renderItem:MapResource = renderDict[type];
			if(renderItem){
				renderItem.clearRender(irender);
			}
		}
		
		public function checkInArea(x:int,y:int):Boolean{
			return x>=0 && x<w && y>=0 && y<h;
		}
		
		private var pw:int;
		private var ph:int;
		public function checkinArea2(x:int,y:int):Boolean{
			return x>=0 && x<pw && y>=0 && y<ph;
		}
		
		protected function renderItemCompleteHandler(event:Event):void{
			var item:MapResource = MapResource(event.currentTarget)
			item.removeAllListener();
			var type:String = item.type;
			renderDict[type] = null;
			delete renderDict[type];
		}
		
		public function getXYItemRenderColor(x:int,y:int):uint{
			if(!checkinArea2(x,y)){
				return 0x00FF00;
			}
			var i:int = x/100;
			var j:int = y/100;
			x = x%100;
			y = y%100;
			var res:MapResource = getMaprenderdata(i,j);
			return res.getColor(x,y);
		}
		
		private function completeHandler(event:Event):void{
			var res:MapResource = event.currentTarget as MapResource;
			if(res.readly){
				var i:int = completeList.indexOf(res.id);
				if(i!=-1){
					completeList.splice(i,1);
				}
				if(!completeList.length){
					this.dispatchEvent(new Event(Event.COMPLETE));
				}
			}
			
			
			
			this.dispatchEvent(new MapEvent(MapEvent.RES_LOAD_COMPLETE,event.currentTarget));
		}
		
		protected var mapresDict:Dictionary;
		protected function getMaprenderdata(x:int,y:int):MapResource{
			if(!checkInArea(x,y)){
				return null;
			}
			var id:String = "map"+ x +"_"+ y+".dat";
			var res:MapResource = mapresDict[id];
			if(!res){
				res = new MapResource(mapres);
				mapresDict[id] = res;
				res.id = id;
			}
			if(!res.readly){
				res.getResource(id,x,y);
				res.addEventListener(Event.COMPLETE,completeHandler);
			}
			return res;
		}
		
		private var rounds:Array = [ [0,0],
									[-1,-1],[0,-1],[1,-1],
									[-1,0],        [1,0],
									[-1,1], [0,1], [1,1]
									];
		private var completeList:Array;
		public function initHero(x:int,y:int):EventDispatcher{
			x /= 100;
			y /= 100;
			completeList = [];
			var i:int;
			var j:int;
			for each(var arr:Array in rounds){
				i = x+arr[0];
				j = y+arr[1];
				if(!checkInArea(i,j)){
					continue;
				}
				var res:MapResource = getMaprenderdata(i,j);
				if(!res.readly && completeList.indexOf(res.id)==-1){
					completeList.push(res.id);
				}
			}
			
			if(!completeList.length){
				setTimeout(dispatchEvent,100,new Event(Event.COMPLETE));
			}
			
			return this;
		}
	}		
}
		