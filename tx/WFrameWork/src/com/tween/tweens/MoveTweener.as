package com.tween.tweens
{
	import com.tween.Tweener;
	
	import flash.display.DisplayObject;
	
	public class MoveTweener extends Tweener
	{
		public static function to(target:Object,property:Object,duration:int,complete:Function = null,ease:Function = null):void{
			getInstance().to(target,property,duration,complete);
		}
		
		private static function getInstance():MoveTweener{
			return new MoveTweener();
		}
		
		public function MoveTweener()
		{
			super();
			properys = [];
		}
		
		
		private var properys:Array;
		private var target:Object;
		
		/**
		 *  
		 * @param target
		 * @param property
		 * @param duration
		 * @param complete
		 * 
		 */		
		public function to(target:Object,property:Object,duration:int,complete:Function = null,ease:Function = null):void{
			this.target = target;
			properys.length = 0;
			for (var type:String in property){
				if(target.hasOwnProperty(type)){
					properys.push(type);
					addTask(target[type],property[type]);
				}
			}
			if(complete!=null){
				onNext = complete;
			}
			
			if(ease!=null){
				this.ease = ease;
			}
			
			play(duration);
		}
		
		override public function updata(value:Array):void{
			for (var i:int = 0;i<n;i++){
				target[properys[i]] = value[i];
			}
		}
		
		override public function dispose():void{
			target = null;
		}
		
	}
}