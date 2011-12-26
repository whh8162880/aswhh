package com.utils
{
	import flash.display.DisplayObject;
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
			target.x = int((stage.stageWidth - target.width)/2);
			target.y = int((stage.stageHeight - target.height)/2);
		}
		
		public static function center2(target:DisplayObject,parent:DisplayObjectContainer = null,offsetx:int = 0,offsety:int = 0):void{
			var w:int;
			var h:int;
			if(!parent){
				w = stage.stageWidth;
				h = stage.stageHeight;
			}else{
				w = parent.width;
				h = parent.height;
			}
			
			target.x = (w - target.width >> 1) + offsetx;
			target.y = (h - target.height >> 1) + offsety;
		}
		
		public static function getCenterPoint(target:Sprite):Array{
			return [int((stage.stageWidth - target.width)/2),int((stage.stageHeight - target.height)/2)]
		}
		
		public static function clearpop():void{
			while(pop.numChildren){
				pop.removeChildAt(0);
			}
		}
	}
}