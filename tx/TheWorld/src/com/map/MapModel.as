package com.map
{
	import com.event.RFEventDispatcher;
	import com.mvc.Model;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Point;
	import flash.utils.Dictionary;

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
			init();
		}
		
		public function init():void{
			
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
				renderItem.render(type,x,y,ez);
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
		
		protected function renderItemCompleteHandler(event:Event):void{
			var item:MapResource = MapResource(event.currentTarget)
			item.removeAllListener();
			var type:String = item.type;
			renderDict[type] = null;
			delete renderDict[type];
		}
		
		
		
	}
}