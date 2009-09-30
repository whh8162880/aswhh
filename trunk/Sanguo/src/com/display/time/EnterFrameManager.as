package com.display.time
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class EnterFrameManager
	{
		public function EnterFrameManager()
		{
		}
		
		private static var dic:Dictionary;
		private static var inited:Boolean = false;
		private static var count:int;
		private static var d:DisplayObject = new Sprite();
		private static function init():void{
			dic = new Dictionary();
			inited = true;
		}
		
		private static function timeHandler(event:Event):void{
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
				d.removeEventListener(Event.ENTER_FRAME,timeHandler)
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
				d.addEventListener(Event.ENTER_FRAME,timeHandler)
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