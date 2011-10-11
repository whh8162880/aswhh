package com.tween.effect
{
	import com.tween.tweens.DisplayObjectTweener;
	
	import flash.display.DisplayObject;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class DorError extends DisplayObjectTweener
	{
		public function DorError()
		{
			super();
		}
		
		private var prex:Number;
		public function doerror(target:DisplayObject):void{
			clearTimeout(t);
			if(!target){
				this.target = null;
				return;
			}
			
			this.target = target;
			prex = target.x;
			addTask(0,618*2);
			super.play(618*2);
			
			onNext = doOnNext;
		}
		
		override public function updata(value:Array):void{
			var p:Number = value[0]/duration;
			target.x = Math.sin(Math.PI * 6 * p) * 20*(1-p) + prex;
		}
		
		override public function stop(render:Boolean = false):void{
			target.x = prex;
			super.stop();
		}
		
		private var t:int;
		private function doOnNext():void{
			t = setTimeout(doerror,3000,target);
		}
	}
}