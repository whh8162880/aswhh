package com.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.display.Stage;

	public class UILocator
	{
		public function UILocator()
		{
		}
		
		public static var tip:DisplayObjectContainer;
		public static var pop:DisplayObjectContainer;
		public static var follow:DisplayObjectContainer;
		public static var stage:Stage;
		public static function bindContianer(s:Stage,container:DisplayObjectContainer):void{
			stage = s;
			follow = new Sprite();
			pop = new Sprite();
			tip = new Sprite();
			container.addChild(follow);
			container.addChild(pop);
			container.addChild(tip);
		}
		
		public static function center(target:Sprite):void{
			target.x = (stage.stageWidth - target.width)/2;
			target.y = (stage.stageHeight - target.height)/2;
		}
		
		public static function clearpop():void{
			while(pop.numChildren){
				pop.removeChildAt(0);
			}
		}
	}
}