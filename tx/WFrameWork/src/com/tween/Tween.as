package com.tween
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class Tween
	{
		
		private static var timer:Timer = new Timer(10)
		
		private static var stage:Stage;
		public static function bindStage(sg:Stage):void{
			stage = sg;
		}
		
		private static var tweeners:Array = [];
		private static var completes:Array = [];
		public static function addTween(tweener:Tweener):void{
			if(!tweener){
				return;
			}
			if(tweeners.indexOf(tweener)==-1){
				tweeners.push(tweener);
			}
			timer.addEventListener(TimerEvent.TIMER,tweenEnterRameHandler);
			timer.start();
			//stage.addEventListener(Event.ENTER_FRAME,tweenEnterRameHandler);
			
		}
		
		public static function removeTween(tweener:Tweener):void{
			if(!tweener){
				return;
			}
			var i:int = tweeners.indexOf(tweener);
			if(i!=-1){
				tweeners.splice(i,1);
			}
			
			if(!tweeners.length){
				//stage.removeEventListener(Event.ENTER_FRAME,tweenEnterRameHandler);
				timer.removeEventListener(TimerEvent.TIMER,tweenEnterRameHandler);
				timer.stop();
			}
		}
		
		/**
		 * 嗯 心跳啊心跳 
		 * @param event
		 * 
		 */
		private static function tweenEnterRameHandler(event:TimerEvent):void{
			var t:int = getTimer();
			for each(var tweener:Tweener in tweeners){
				var b:Boolean = tweener.refreshCurrentValue(t-tweener.startTime);
				if(b){
					completes.push(tweener);
					tweener.stop();
				}
			}
			
			while(completes.length){
				removeTween(completes.pop());
			}
			
			//阿弥陀佛 不要怪我
			event.updateAfterEvent();
		}
		
	}
}