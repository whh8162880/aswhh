package com.utils.timer
{
	public class ITimer
	{
		/**
		 * 嗯 这是一个很神奇的东西 可以改变播放速度 1 不变 0<scale<1 速度变慢  >1播放速度变快  
		 */		
		public var scale:Number = 1;
		
		/**
		 * 上次计算时间 
		 */		
		public var preCelcTime:int;
		
		/**
		 * 当前时间 
		 */		
		public var currentTime:int;
		
		public function refreshCurrentValue(value:int):Boolean{
			return true;
		}
		
		public function stop():void{
			
		}
	}
}