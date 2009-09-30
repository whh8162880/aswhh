package com.map
{
	import com.avater.AvaterBase;
	import com.avater.AvaterController;
	import com.managers.CreateItemManager;
	
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class MapController extends EventDispatcher
	{
		public function MapController()
		{
			_tweenDict = new Dictionary()
		}
		
		private static var _instance:MapController;
		public static function getInstance():MapController{
			return _instance ||= new MapController()
		}
		
		protected var _map:MapBase;
		protected var _avaterController:AvaterController;
		protected var _tweenDict:Dictionary
		public var mapClickHandFlag:Boolean = true
		public function set map(map:MapBase):void{
			this._map = map;
			_map.addEventListener(MapDataEvent.MAP_CLICK,mapClickHandler);
		}
		public function get map():MapBase{
			return _map;
		}
		
		public function set avaterContaroller(value:AvaterController):void{
			_avaterController = value;
		}
		
		protected function mapClickHandler(event:MapDataEvent):void{
			var avater:AvaterBase =  _avaterController.currentSelectedAvater
			if(mapClickHandFlag ==false || _avaterController == null || avater== null){
				return;
			}
			var p:Point = event.data.mapPoint;
			var arr:Array = _map.find(avater.getView(),p.x,p.y);
			createTween(avater,avater.getView(),arr,event.data.el)
		}
		
		protected function createTween(data:Object,item:DisplayObject,path:Array,el:Number):void{
			var tween:MoveItemTween = _tweenDict[item]
			if(tween){
				tween .stop();
			}
			if(path && path.length>1){
				if(tween == null){
					tween = CreateItemManager.getItem(MoveItemTween) as MoveItemTween
				}
				tween.addEventListener(MoveItemEvent.MOVE_CHANGE,moveHandelr);
				tween.addEventListener(MoveItemEvent.MOVE_END,moveHandelr);
				tween.init(data,item,path,el);
				tween.start();
				_tweenDict[item] = tween;
			}
		}
		
		
		protected function removeTween(tween:MoveItemTween):void{
			CreateItemManager.removeItem(tween,false);
		}
		
		protected function moveHandelr(event:MoveItemEvent):void{
			var item:MoveItemTween = event.target as MoveItemTween
			var avater:AvaterBase = item.data as AvaterBase
			if(event.type == MoveItemEvent.MOVE_END){
				avater.defaulted();
				_tweenDict[item.item] = null
				delete _tweenDict[item.item]
				return;
			}
			var p:Point = event.movePoint;
			avater.direction = event.direction;
			avater.run();
			moveItem(item.item,p.x,p.y);
		}
		
		public function moveItem(item:DisplayObject,x:int,y:int):void{
			_map.resetItemXY(item,x,y);
		}
		
		

	}
}