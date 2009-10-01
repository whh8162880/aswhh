package com.display.time
{
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	public class TimeManager
	{
		// --------------------
		//		1 delay = 100ms
		//---------------------
		private static var dic:Dictionary;
		private static var inited:Boolean = false;
		private static var time:Timer
		private static var count:int;
		private static function init():void{
			dic = new Dictionary();
			time = new Timer(100);
			time.addEventListener(TimerEvent.TIMER,timeHandler);
			inited = true;
		}
		
		private static function timeHandler(event:TimerEvent):void{
			for each(var vo:VO in dic){
				if(vo.currentDelay >= vo.delay){
					var b:Boolean = vo.fun();
					vo.currentDelay = 0
					if(b == false){
						removeFunction(vo.fun);
					}
					
				}
				vo.currentDelay++;
			}
			event.updateAfterEvent()
		}
		
		public static function removeFunction(fun:Function):void{
			var vo:VO = dic[fun]
			if(vo){
				vo = null
			}else{
				return;
			}
			dic[fun] = null
			delete dic[fun];
			
			count--
			
			if(count == 0){
				time.stop();
			}
		}
		
		public static function regFunction(fun:Function,delay:int):void{
			if(delay<1){
				delay = 1;
			}
			
			if(inited == false){
				init();
			}
			
			var vo:VO = dic[fun]
			if(vo){
				vo.delay = delay;
				return;
			}
			
			vo = new VO(fun,delay);
			
			dic[fun] = vo;
			
			if(count == 0){
				time.start();
			}
			
			count++;
		}
		
	}
}

class VO{
	public function VO(fun:Function,delay:int){
		this.fun = fun;
		this.delay = delay;
	}
	
	public var fun:Function;
	public var delay:int;
	public var currentDelay:int;
}