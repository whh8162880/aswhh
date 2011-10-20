package com.utils
{
	import com.utils.timer.TimerCore;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import rfcomponents.text.Text;

	public class ProfileUitls
	{
		private var text:Text;
		private var timer:Timer = new Timer(20);
		private var startTime:int;
		public function ProfileUitls(stage:Stage,text:Text)
		{
			this.text = text;
			stage.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
			stage.addEventListener(Event.EXIT_FRAME,exitFrameHandler);
			timer.addEventListener(TimerEvent.TIMER,timerHandler);
			timer.start();
			startTime = getTimer();
		}
		
		private var t:int;
		private function enterFrameHandler(event:Event):void{
			t = getTimer();
			fpscount++;
		}
		
		private function exitFrameHandler(event:Event):void{
			text.label = 'render '+(getTimer() - t) +" fps: "+fps.toFixed(1);
		}
		
		private var fpscount:int;
		private var fps:Number = 30;
		private function timerHandler(event:Event):void{
			var s:int = getTimer();
			if(s - startTime > 999){
				startTime = s;
				fps = fpscount;
				fpscount = 0;
			}
		}
		
		
	}
}