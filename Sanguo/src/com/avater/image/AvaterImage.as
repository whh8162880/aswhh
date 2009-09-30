package com.avater.image
{
	import com.display.image.ImageBase;

	public class AvaterImage extends ImageBase
	{
		protected var defaultActions:Array;
		protected var walkActions:Array;
		protected var runActions:Array;
		protected var fightActions:Array;
		protected var _m:String
		public function AvaterImage()
		{
			_m = "m"
			super();
		}
		
		public function getDefaultActions():Array{
			return defaultActions
		}
		
		public function getWalkActions():Array{
			return walkActions
		}
		
		public function getRunActions():Array{
			return runActions
		}
		
		public function getFightActions():Array{
			return fightActions
		}
		
		public function get m():String{
			return _m
		}
		
		
	}
}