package com.tween
{
	import com.utils.timer.ITimer;
	import com.utils.timer.TimerCore;
	
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class Tweener extends ITimer
	{
		public function Tweener()
		{
			ease = defaultEasingFunction;
			onUpdata = updata;
		}
		
		
		public var ease:Function;
		public var onUpdata:Function;
		public var onComplete:Function;
		
		/**
		 * 初始值 
		 */		
		public var startValues:Array = [];
		
		/**
		 * 结果 
		 */		
		public var endValues:Array = [];
		
		/**
		 * 当前运算结果 
		 */		
		public var resultValues:Array = [];
		
		/**
		 * 持续时间 
		 */		
		public var duration:int;
		
		/**
		 * 计算个数 
		 */		
		protected var n:int;
		
		/**
		 * 是否在播放 
		 */		
		public var isPlaying:Boolean;
		
		/**
		 * 开始 添加任务
		 * @return 
		 */		
		public function addTask(start:Number,end:Number):void{
			startValues.push(start);
			endValues.push(end-start);
			n++;
		}
		
		/**
		 * 播放 
		 */		
		public function play(duration:int):void{
			if(!n){
				return;
			}
			
			this.duration = duration;
			
			if(duration==0){
				this.updata(endValues);
				return;
			}
			TimerCore.insetance.addTimerItem(this);
			//Tween.addTween(this);
			isPlaying = true;
		}
		
		/**
		 * 停止 
		 */		
		override public function stop():void{
			if(onComplete != null){
				onComplete();
			}
			end(false);
		}
		
		/**
		 * 手动结束
		 */		
		public function end(remove:Boolean = true):void{
			n = 0;
			startValues.length = 0;
			endValues.length = 0;
			resultValues.length = 0;
			ease = defaultEasingFunction;
			onUpdata = updata;
			onComplete = null;
			isPlaying = false;
			TimerCore.insetance.removeTimerItem(this);
			//Tween.removeTween(this);
		}
		
		/**
		 * 刷新数据
		 * @param currentTime
		 */		
		override public function refreshCurrentValue(currentTime:int):Boolean{
			currentTime = currentTime>duration ? duration : currentTime;
			var i:int = n;
			while(--i>-1){
				resultValues[i] = ease(currentTime,startValues[i],endValues[i],duration);
			}
			onUpdata(resultValues);
			return currentTime>=duration;
		}
		
		protected function defaultEasingFunction(t:Number,b:Number,c:Number,d:Number):Number{
			return c * t / d + b;
		}
		
		/**
		 * 更新 override
		 * @param value
		 */		
		public function updata(value:Array):void{
			
		}
		
	}
}