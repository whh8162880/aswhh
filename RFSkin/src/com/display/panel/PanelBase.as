package com.display.panel
{
	import com.display.Container;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;

	public class PanelBase extends Container
	{
		protected var _enterButton:IEventDispatcher
		protected var _escButton:IEventDispatcher
		public function PanelBase(_skin:DisplayObjectContainer=null)
		{
			super(_skin);
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
		public function start():void{
			
		}
		
		public function sleep():void{
			
		}
		
		public function close():void{
			
		}
		
		public function open():void{
			
		}
		
	}
}