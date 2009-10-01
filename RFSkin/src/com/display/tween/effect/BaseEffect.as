package com.display.tween.effect
{
	import com.display.tween.Tween;
	
	public class BaseEffect extends Tween
	{
		public function BaseEffect()
		{
			super()
		}
		
		public function startEffect(_form:Number,_to:Number,duration:int,autoPlay:Boolean = true):void{
			formArray = [_form];
			toArray = [_to];
			this.duration = duration;
			if(autoPlay == true){
				play();
			}
		}
		
		override protected function formatReturnData():Object{
			return currentArray[0]
		}
		
		
	}
}