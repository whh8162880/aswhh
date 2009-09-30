package com.avater
{
	import com.avater.vo.UserVO;
	import com.managers.CreateItemManager;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	public class AvaterController extends EventDispatcher
	{
		public function AvaterController(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		private var _avatersDict:Dictionary
		private var _currentSelectedAvater:AvaterBase
		
		public function get avaterDict():Dictionary{
			return _avatersDict
		}
		
		private static var _instance:AvaterController;
		public static function getInstance():AvaterController{
			return _instance ||= new AvaterController();
		}
//		
		public static function getAvater(guid:String):AvaterBase{
			var avatersDict:Dictionary = getInstance().avaterDict;
			if(avatersDict == null){
				avatersDict = new Dictionary();
			}
			return avatersDict[guid]
		}
		
//		public static function getSelf():AvaterBase{
//			
//		}
		
		public function regAvater(avater:AvaterBase):void{
			if(!_avatersDict){
				_avatersDict = new Dictionary();
			}
			
			avater.addEventListener(AvaterEvent.SELECTED,avaterSelectedHandelr);
			
			_avatersDict[avater.userVO.guid] = avater;
		}
		
		public function removeAvater(guid:String):void{
			if(_avatersDict == null){
				_avatersDict = new Dictionary();
			}
			var vo:AvaterBase = _avatersDict[guid]
			if(vo){
				_avatersDict[guid] = null
				delete _avatersDict[guid];
				if(vo.getView().parent){
					vo.getView().parent.removeChild(vo.getView());
				}
			}
		}
		
		public function getAvaterBase(uservo:UserVO,factoryClass:Class = null):AvaterBase{
			if(factoryClass == null){
				factoryClass = AvaterBase;
			}
			var avater:AvaterBase = CreateItemManager.getItem(factoryClass) as AvaterBase
			avater.userVO = uservo;
			regAvater(avater);
			return avater;
		}
		
		public function set currentSelectedAvater(value:AvaterBase):void{
			_currentSelectedAvater = value;
		}
		
		public function get currentSelectedAvater():AvaterBase{
			return _currentSelectedAvater;
		}
		
		private function avaterSelectedHandelr(event:AvaterEvent):void{
			doSelected(event.currentTarget as AvaterBase,event.data as Boolean)
		}
		
		protected function doSelected(item:AvaterBase,value:Boolean):void{
			if(value){
				if(_currentSelectedAvater){
					_currentSelectedAvater.selected = false;
				}
				_currentSelectedAvater = item;
			}else{
				_currentSelectedAvater = null
			}
		}
		
	}
}