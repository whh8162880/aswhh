package com.theworld.components.panel
{
	import com.components.TestButton;
	import com.components.TestPanel;
	import com.utils.UILocator;
	import com.utils.key.KeyboardManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import rfcomponents.button.Button;
	import rfcomponents.panel.Panel;
	import rfcomponents.radiobutton.RadioButton;
	import rfcomponents.text.Text;
	
	public class TXPanel extends TestPanel
	{
		public var panelName:String;
		protected var keyboard:KeyboardManager
		public function TXPanel()
		{
			super();
			keyboard = new KeyboardManager();
		}
		
		override public function show(locat:DisplayObjectContainer=null):void{
			super.show(UILocator.pop);
			UILocator.center(_skin);
		}
	}
}