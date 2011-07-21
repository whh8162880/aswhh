package com.theworld.components.panel
{
	import com.components.TestButton;
	import com.theworld.utils.UILocator;
	import com.utils.key.KeyboardManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import rfcomponents.button.Button;
	import rfcomponents.panel.Panel;
	import rfcomponents.text.Text;
	
	public class TXPanel extends Panel
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
		
		public function createTextFiled(x:int,y:int,w:int,h:int,input:Boolean = false,defaultlable:String = ''):Text{
			var text:Text = new Text();
			text.create(w,h);
			text.x = x;
			text.y = y;
			text.label = defaultlable;
			text.editable = input;
			addChild(text.skin);
			return text;
		}
		
		public function createButton(x:int,y:int,w:int,h:int,defaultlabel:String='',handler:Function=null):Button{
			var button:TestButton = new TestButton(w,h);
			button.label = defaultlabel;
			button.x = x;
			button.y = y;
			if(handler!=null){
				button.addEventListener(MouseEvent.CLICK,handler);
			}
			addChild(button.skin);
			return button;
		}
		
	}
}