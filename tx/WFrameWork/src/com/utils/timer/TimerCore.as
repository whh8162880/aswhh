package com.utils.timer
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class TimerCore extends Timer
	{
		public static var insetance:TimerCore = new TimerCore();
		public function TimerCore()
		{
			super(30);
			addEventListener(TimerEvent.TIMER,timerHandler);
		}
		
		public var scale:Number = 1;
		
		private var timers:Array = [];
		
		private var completes:Array = [];
		/**
		 * 
		 * @param event
		 * 
		 */		
		protected function timerHandler(event:TimerEvent):void{
			var t:int = getTimer();
			for each(var item:ITimer in timers){
				var b:Boolean = item.refreshCurrentValue(item.currentTime += (item.scale*(t - item.preCelcTime)*scale));
				if(b){
					completes.push(item);
					item.stop();
				}else{
					item.preCelcTime  = t;
				}
			}
			
			while(completes.length){
				removeTimerItem(completes.pop());
			}
			
			//阿弥陀佛 不要怪我
			//event.updateAfterEvent();
		}
		
		/**
		 * 
		 * @param item
		 * 
		 */		
		public function addTimerItem(item:ITimer):void{
			if(!item){
				return;
			}
			if(timers.indexOf(item)==-1){
				timers.push(item);
				item.currentTime = 0;
				item.preCelcTime = getTimer();
			}
			if(!running){
				start();
			}
		}
		
		/**
		 * 
		 * @param item
		 * 
		 */		
		public function removeTimerItem(item:ITimer):void{
			if(!item){
				return;
			}
			var i:int = timers.indexOf(item);
			if(i!=-1){
				timers.splice(i,1);
			}
			
			if(!timers.length){
				stop();
			}
		}
	}
}