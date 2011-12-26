package com.tween.tweens
{
	import com.tween.Tweener;
	
	public class PropertyTweener extends Tweener
	{
		public function PropertyTweener()
		{
			super();
			propertys = [];
		}
		
		public var target:Object;
		
		private var propertys:Array;
		
		public function form(obj:Object,duration:int):void{
			if(isPlaying){
				stop();
			}
			propertys.length = 0;
			for (var p:String in obj){
				if(target.hasOwnProperty(p) && (target[p] is Number) && target[p] != obj[p]){
					propertys.push(p);
					addTask(obj[p],target[p]);
				}
			}
			play(duration);
		}
		
		public function to(obj:Object,duration:int):void{
			if(isPlaying){
				stop();
			}
			propertys.length = 0;
			for (var p:String in obj){
				if(target.hasOwnProperty(p) && (target[p] is Number) && target[p] != obj[p]){
					propertys.push(p);
					addTask(target[p],obj[p]);
				}
			}
			play(duration);
		}
		
		
		override public function updata(value:Array):void{
			for (var i:int = 0;i<n;i++){
				target[propertys[i]] = value[i];
			}
		}
	}
}