package com.dock
{
	import com.dock.icon.DockIcon;
	import com.dock.icon.IDockIcon;
	import com.dock.view.DockView;
	import com.dock.view.IDockView;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	public class DockManager extends EventDispatcher
	{
		public function DockManager(st:Stage)
		{
			super();
			stage = st;
		}
		
		
		private static var dmDict:Dictionary = new Dictionary();
		/**
		 * 
		 * @param group
		 * @param stage
		 * 
		 */		
		public static function create(group:String,stage:Stage):DockManager{
			var dm:DockManager = new DockManager(stage);
			dmDict[group] = dm;
			return dm;
		}
		
		/**
		 * 
		 * @param group
		 * @return 
		 * 
		 */		
		public static function getInstance(group:String):DockManager{
			return dmDict[group];
		}
		
		
		public function startDargIcon(icon:IDockIcon):void{
			stage.addEventListener(MouseEvent.MOUSE_UP,DockIconMouseUpHandler);
			currentDargIcon = icon;
			currentDargIcon.mouseEnabled = false;
			var parent:DisplayObjectContainer = (currentDargIcon as DisplayObject).parent
			if(parent is DockView){
				IDockView(parent).preRemoveDockIcon(currentDargIcon);
				currentDargIcon.x = stage.mouseX - currentDargIcon.mouseX;
				currentDargIcon.y = stage.mouseY - currentDargIcon.mouseY;
				currentDargIcon.nextMoveIndex = -1;
				stage.addChild(currentDargIcon as DisplayObject);
				

				stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
				currentDockView = parent as DockView;
				
				outDockView = currentDockView;
			}
		}
		
		private function DockIconMouseUpHandler(event:MouseEvent):void{
			IEventDispatcher(event.currentTarget).removeEventListener(event.type,DockIconMouseUpHandler);
			currentDargIcon.mouseEnabled = true;
			if(currentDargIcon.nextMoveIndex == -1){
				emptyDockIcon(currentDargIcon);
			}
			//currentDargIcon = null;
		}
		
		public var currentDargIcon:IDockIcon;
		
		public var mainDockView:IDockView;
		public function emptyDockIcon(icon:IDockIcon):void{
			if(mainDockView){
				currentDargIcon.x -= mainDockView.x;
				currentDargIcon.y -= mainDockView.y;
				mainDockView.addDockIcon(icon);
			}
			currentDargIcon = null;
		}
		
		protected var stage:Stage;
		
		protected var currentDockView:IDockView;
		
		protected var outDockView:IDockView;
		
		protected var itemW:int;
		
		protected var itemH:int;
		
		protected var e:int;
		
		public function regDockView(view:DockView):void{
			view.addEventListener(MouseEvent.MOUSE_OVER,rollHandler);
			view.addEventListener(MouseEvent.MOUSE_OUT,rollHandler);
		}
		
		protected function rollHandler(event:MouseEvent):void{
			var view:DockView = DockView(event.currentTarget);
			if(event.type == MouseEvent.MOUSE_OVER){
				if(currentDargIcon){
					stage.addEventListener(MouseEvent.MOUSE_MOVE,iconDragChangeHandler);
					stage.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
					view.mouseChildren = false;
					currentDockView = view;
//					roll = true;
				}
			}else{
				if(currentDargIcon){
					stage.removeEventListener(MouseEvent.MOUSE_MOVE,iconDragChangeHandler);
					currentDargIcon.nextMoveIndex = -1;
					view.checkDock();
				}
				view.mouseChildren = true;
				if(currentDockView == view){
					currentDockView = null;
				}
//				roll = false;
			}
		}
		
		protected function mouseUpHandler(event:MouseEvent):void{
			if(currentDargIcon && currentDockView){
				currentDargIcon.x -= currentDockView.x;
				currentDargIcon.y -= currentDockView.y;
				currentDockView.intoDockIcon(currentDargIcon);
			}
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,iconDragChangeHandler);
			stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
			if(currentDockView){
				currentDockView.mouseChildren = true;
				currentDockView.checkDock();
				currentDockView= null;
			}
			currentDargIcon = null;
			
			if(outDockView && outDockView!=currentDockView){
				outDockView.checkDock();
				outDockView = null;
			}
		}
		
		protected function iconDragChangeHandler(event:MouseEvent):void{
			var px:int = currentDockView.x;
			var py:int = currentDockView.y;
//			var d:DisplayObject  = currentDargIcon as DisplayObject;
//			var dx:int = d.x - px;
//			var dy:int = d.y - py;
			var i:int = currentDockView.getIndex(currentDargIcon);
			var iconList:Array = currentDockView.getList();
			var len:int = iconList.length;
			
			currentDargIcon.nextMoveIndex = i;
			currentDargIcon.setName(currentDargIcon.nextMoveIndex.toString());
			var icon:DockIcon;
			var j:int;
			var moveindex:int;
			for(j = 0;j<len;j++){
				icon = iconList[j];
				if(j>=i){
					moveindex = j+1;
				}else{
					moveindex = j;
				}
				if(icon.nextMoveIndex != moveindex){
					icon.setName(icon.nextMoveIndex +"->" + moveindex);
					icon.nextMoveIndex = moveindex;
					currentDockView.tweenTo(icon,moveindex);
				}
			}
		}
	}
}