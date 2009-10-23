package com.display.panel
{
	import com.display.Container;
	import com.display.keyboard.KeyboardManager;
	import com.display.managers.CreateItemManager;
	import com.youbt.manager.RFSystemManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;

	public class PanelBase extends Container
	{
		protected var _enterButton:IEventDispatcher
		protected var _escButton:IEventDispatcher
		protected var _keyboardManager:KeyboardManager
		protected var started:Boolean = false;
		protected var _enterCloseFlag:Boolean = false;
		protected var _escCloseFlag:Boolean = false;
		protected var parentPanel:PanelBase
		protected var _panelMoveArea:PanelMoveArea;
		public function PanelBase(_skin:DisplayObjectContainer=null)
		{
			_keyboardManager = new KeyboardManager();
			_keyboardManager.init(this);
			_panelMoveArea = new PanelMoveArea(this);
			super(_skin);
		}
		
		override protected function addToStage():void{
			_keyboardManager.start();
			if(started == false){
				start();
				started = true;
			}
		}
		
		override protected function removeFromStage():void{
			_keyboardManager.sleep();
			if(started == true){
				sleep();
				started = false
			}
		}
		
		public function set enterKeyboardEnabled(value:Boolean):void{
			if(value){
				_keyboardManager.regFunction(enter,false,false,false,Keyboard.ENTER);
			}else{
				_keyboardManager.removeFunctionByKeyFunction(enter);
			}
		}
		
		public function set escKeyboardEnabled(value:Boolean):void{
			if(value){
				_keyboardManager.regFunction(esc,false,false,false,Keyboard.ESCAPE);
			}else{
				_keyboardManager.removeFunctionByKeyFunction(esc);
			}
		}
		
		public function set enterButton(button:IEventDispatcher):void{
			_enterButton = button
		}
		
		public function get enterButton():IEventDispatcher{
			return _enterButton;
		}
		
		public function set escButton(button:IEventDispatcher):void{
			_escButton = button
		}
		
		public function get escButton():IEventDispatcher{
			return _escButton;
		}
		
		public function set enterClose(value:Boolean):void{
			_enterCloseFlag = value
		}
		
		public function set escClose(value:Boolean):void{
			_escCloseFlag = value;
		}
		
		public function getChildContainer():DisplayObjectContainer{
			return this;
		}
		
		public function start():void{
			
		}
		
		public function sleep():void{
			
		}
		
		public function close():void{
			CreateItemManager.removeItem(this);
		}
		
		public function show(target:DisplayObjectContainer = null):void{
			if(target == null){
				target = RFSystemManager.getInstance().stage;
				if(!target){
					return;
				}
			}
			if(target is PanelBase){
				parentPanel = PanelBase(target) ;
				target = PanelBase(target).getChildContainer();
			}
		}
		
		public function enter():void{
			trace("enter")
			if(_enterButton){
				_enterButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			if(_enterCloseFlag){
				close();
			}
		}
		
		public function esc():void{
			trace("esc")
			if(_escButton){
				_escButton.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
			}
			if(_escCloseFlag){
				close();
			}
		}
	}
}