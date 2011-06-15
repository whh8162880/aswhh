package com.event
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	/**
	 * EventDispatcher
	 * 实现功能
	 *    记录所有监听
	 *    可删除所有监听
	 *    可根据类型 删除所有监听
	 * @author whh
	 * 
	 */	

	public class RFEventDispatcher extends EventDispatcher
	{
		private var eventList:Dictionary
		public function RFEventDispatcher(target:IEventDispatcher=null)
		{
			eventList = new Dictionary();
			super(target);
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
			var vo:EventDictpatcherVo = eventList[type];
			if(!vo){
				vo = new EventDictpatcherVo(type)
				eventList[type] = vo;
			}
			vo.addEvent(listener,useCapture,priority,useWeakReference);
			super.addEventListener(type,listener,useCapture,priority,useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void{
			var vo:EventDictpatcherVo = eventList[type];
			if(vo){
				vo.removeEvent(listener,useCapture);
				if(!vo.count){
					eventList[type] = null
					delete eventList[type];
				}
			}
			super.removeEventListener(type,listener,useCapture);
		}
		
		public function removeAllListenerByType(type:String):void{
			var vo:EventDictpatcherVo = eventList[type]
			if(vo){
				removeListener(vo.getAllEvent());
			}
		}
		
		public function removeAllListener():void{
			removeListener(getAllListener())
		}
		
		public function getAllListener():Array{
			var arr:Array = []
			for each(var vo:EventDictpatcherVo in eventList){
				arr = arr.concat(vo.getAllEvent());
			}
			return arr;
		}
		
		private function removeListener(arr:Array):void{
			for each(var vo:EventVO in arr){
				removeEventListener(vo.type,vo.listener,vo.useCapture);
			}
		}
	}
}
	import flash.utils.Dictionary;
	

class EventDictpatcherVo{
	public var events:Dictionary
	public function EventDictpatcherVo(type:String):void{
		events = new Dictionary()
		this.type = type;
		count = 0
	}
	public var count:int;
	public var type:String;
	public function addEvent(listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
		var vo:EventVO = events[listener] 
		if(!vo){
			count ++;
			vo = new EventVO(type,listener,useCapture,priority,useWeakReference)
			events[listener] = vo;
		}else{
			return;
		}
	}
	
	public function removeEvent(listener:Function, useCapture:Boolean=false):void{
		var vo:EventVO = events[listener] 
		if(vo){
			count --;
			events[listener] = null;
			delete events[listener]
		}
	}
	
	public function removeAllEvent():void{
		for each(var vo:EventVO in events){
			removeEvent(vo.listener,vo.useCapture);
		}
	}
	
	public function getAllEvent():Array{
		var arr:Array = []
		for each(var vo:EventVO in events){
			arr.push(vo);
		}
		return arr;
	}
	
}

class EventVO{
	public function EventVO(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false){
		this.type = type;
		this.listener = listener;
		this.useCapture = useCapture;
		this.priority = priority;
		this.useWeakRdference = useWeakReference;
	}
	
	public var type:String;
	public var listener:Function;
	public var useCapture:Boolean;
	public var priority:int;
	public var useWeakRdference:Boolean;
}