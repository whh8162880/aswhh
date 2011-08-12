package com.tween
{
	import flash.utils.getTimer;

	public class Tweener
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
		 * 开始时间 
		 */		
		public var startTime:int;
		
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
			startTime = getTimer();
			Tween.addTween(this);
			isPlaying = true;
		}
		
		/**
		 * 停止 
		 */		
		public function stop():void{
			if(onComplete != null){
				onComplete();
			}
			end();
		}
		
		/**
		 * 手动结束
		 */		
		public function end():void{
			n = 0;
			startValues.length = 0;
			endValues.length = 0;
			resultValues.length = 0;
			ease = defaultEasingFunction;
			onUpdata = updata;
			onComplete = null;
		}
		
		/**
		 * 刷新数据
		 * @param currentTime
		 */		
		public function refreshCurrentValue(currentTime:int):Boolean{
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