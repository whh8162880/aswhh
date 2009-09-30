package com.avater
{
	import com.avater.image.AvaterImage;
	import com.avater.vo.UserVO;
	import com.display.Box;
	import com.display.LayoutType;
	import com.display.time.TimeManager;
	import com.display.utils.ObjectUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	public class AvaterBase extends EventDispatcher
	{
		protected var actionDict:Dictionary
		protected var _defaultAction:String;
		protected var bitmap:Bitmap
		protected var container:Box
		protected var avaterTitle:AvaterTitle
		protected var currentActionVO:AvaterActionVO;
		protected var currentDelay:int;
		protected var image:AvaterImage
		protected var inited:Boolean;
		protected var _userVO:UserVO;
		public function AvaterBase()
		{
			actionDict = new Dictionary();
			bitmap = new Bitmap()
			container = new Box(LayoutType.VERTICAL,false);
			avaterTitle = new AvaterTitle;
			avaterTitle.hAlign = LayoutType.CENTER 
			container.hAlign = LayoutType.CENTER 
			container.addChild(avaterTitle);
			container.addChild(bitmap);
			container.addEventListener(Event.ADDED_TO_STAGE,toStageHandler);
			container.addEventListener(Event.REMOVED_FROM_STAGE,toStageHandler);
			
			container.addEventListener(MouseEvent.ROLL_OVER,rollHandler);
			container.addEventListener(MouseEvent.ROLL_OUT,rollHandler);
			container.addEventListener(MouseEvent.CLICK,clickHandler);
			
		}
		
		protected function createComplete():void{
			showAction(defaultAction,true,currentDelay)
			inited = true
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function set defaultAction(value:String):void{
			_defaultAction = value;
//			if(bitmap.bitmapData == null){
//				var avateractionvo:AvaterActionVO = actionDict[value];
//				doShowAction(avateractionvo)
//			}
			
		}
		
		public function get defaultAction():String{
			return _defaultAction
		}
		
		public function regActions2(value:Array):void{
			currentDelay = value[0]
			regActions(value[1])
		}
		
		public function regActions(actions:Array):void{
			for each(var action:AvaterActionVO in actions){
				regAction(action);
			}
		}
		
		public function regAction(avateractionvo:AvaterActionVO):void{
			actionDict[avateractionvo.actionName] = avateractionvo;
			if(defaultAction == null){
				defaultAction = avateractionvo.actionName;
			}
		} 
		
		protected var isShowNext:Boolean
		public function showAction(actionName:String,showNext:Boolean = false,delay:int = 5):void{
			var aav:AvaterActionVO = getAvaterActionVO(actionName);
			if(aav == null){
				aav = getAvaterActionVO(defaultAction);
			}
			
			if(aav.direction != currentDirection){
				var o:AvaterActionVO = getAvaterActionVO(image.m + currentDirection + aav.frame)
				if(o){
					aav = o;
				}
			}
			doShowAction(aav);
			isShowNext = showNext;
			if(showNext == true && addToStaged){
				currentDelay = delay;
				TimeManager.regFunction(timeToNextFrame,delay);
			}
		}
		
		private function timeToNextFrame():Boolean{
			if(!currentActionVO)return false;
			var next:String = currentActionVO.nextAction;
			if(next == null){
				return false;
			}
			var aav:AvaterActionVO = getAvaterActionVO(next);
			if(aav == null){
				return false;
			}
			doShowAction(aav);
			return true;
		}
		
		private function doShowAction(action:AvaterActionVO):void{
			currentActionVO = action
			if(action == null){
				return ;
			}
			var b:BitmapData = bitmap.bitmapData
			var b2:BitmapData = action.bitmapData
			
			bitmap.bitmapData = action.bitmapData;
			
			if(b && b2 && (b.width != b2.width || b.height != b2.height))
			{
				container.refresh();
			}
		}
		
		public function getView():DisplayObject{
			return container
		}
		
		public function getAvaterActionVO(actionName:String):AvaterActionVO{
			return actionDict[actionName];
		}
		
		public function set userVO(value:UserVO):void{
			_userVO = value;
			if(_userVO){
				doData();
			}
		}
		
		public function get userVO():UserVO{
			return _userVO;
		}
		
		protected function doData():void{
			var o:Object = ObjectUtils.getObjectPropertys(_userVO);
			var arr:Array = container.getChildrens();
			for each(var item:Object in arr){
				if(item.hasOwnProperty("data")){
					item["data"] = o;
				}
			}
		}
		
		private var currentDirection:int
		public function set direction(value:int):void{
			if(inited){
				showAction(image.m + value + currentActionVO.frame)
			}
			currentDirection = value;
		}
		
		public function get direction():int{
			return currentActionVO.direction;
		}
		
		protected var currentState:String = ""
		public function run():void{
			if(currentState == "run"){
				return;
			}
			var direction:int = currentActionVO.direction;
			var frame:int = currentActionVO.frame;
			reset()
			regActions2(image.getRunActions());
			showAction(image.m + direction + frame,true,currentDelay)
			currentState = "run"
		}
		
		public function walk():void{
			if(currentState == "walk"){
				return;
			}
			var direction:int = currentActionVO.direction;
			var frame:int = currentActionVO.frame;
			reset()
			regActions2(image.getWalkActions());
			showAction(image.m + direction + frame,true,currentDelay)
			currentState = "walk"
		}
		
		public function defaulted():void{
			if(currentState == "defaulted"){
				return;
			}
			var direction:int = currentActionVO.direction;
			var frame:int = currentActionVO.frame;
			reset()
			regActions2(image.getDefaultActions());
			showAction(image.m + direction + frame,true,currentDelay)
			currentState = "defaulted"
		}
		
		public function DefaultedStop(direction:int = -1):void{
			direction == -1 ? currentActionVO.direction : direction;
			TimeManager.removeFunction(timeToNextFrame);
			showAction(image.m + direction + "0",false)
		}
		
		protected function reset():void{
			currentActionVO = null;
			_defaultAction = null;
			TimeManager.removeFunction(timeToNextFrame);
		}
		
		protected var addToStaged:Boolean
		protected function toStageHandler(event:Event):void{
			if(event.type == Event.ADDED_TO_STAGE){
				addToStaged = true
				if(_defaultAction)
					showAction(_defaultAction,isShowNext);
//				addToStage()
			}else{
				addToStaged = false
				showAction(_defaultAction,false);
//				removeFromStage();
			}
		}
		
		
		private function rollHandler(event:MouseEvent):void{
			if(event.type == MouseEvent.ROLL_OVER){
				rollOver()
			}else{
				rollOut();
			}
		}
		
		protected var _selected:Boolean
		private function clickHandler(event:MouseEvent):void{
			_selected = !_selected
			_selected ? doSelected() : unSelected()
			this.dispatchEvent(new AvaterEvent(AvaterEvent.SELECTED,_selected));
			click();
		}
		
		public function set selected(value:Boolean):void{
			_selected = value;
			_selected ? doSelected() : unSelected()
		}
		
		public function get selected():Boolean{
			return _selected
		}
		
		
		protected function rollOver():void{
			
		}
		
		protected function rollOut():void{
			
		}
		
		protected function click():void{
			
		}
		
		protected function doSelected():void{
		}
		
		protected function unSelected():void{
			
		}

	}
}