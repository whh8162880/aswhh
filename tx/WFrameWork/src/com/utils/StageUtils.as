package com.utils
{
	import com.utils.key.KeyboardManager;
	import com.utils.work.Work;
	
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.getTimer;

	public class StageUtils
	{
		public function StageUtils()
		{
		}
	
		public static var stage:Stage;
		public static const STAGE_RENDER:String = 'stage_render';
		public static function initStage(sg:Stage):void{
			stage =  sg;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			Work.bindStage(sg);
			KeyboardManager.setStage(stage);
		}
		
		public static function check(b:Boolean):void{
			if(b){
				stage.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
				stage.addEventListener(Event.EXIT_FRAME,renderHandler);
			}else{
				stage.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
				stage.removeEventListener(Event.EXIT_FRAME,renderHandler);
			}
		}
		
		private static var t:int;
		private static function enterFrameHandler(event:Event):void{
			t = getTimer();
		}
		private static function renderHandler(event:Event):void{
			InsertFunction.doInsertFunction(STAGE_RENDER,(getTimer()-t));
		}
	}
}