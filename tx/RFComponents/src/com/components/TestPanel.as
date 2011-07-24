package com.components
{
	import com.utils.UILocator;
	import com.utils.key.KeyboardManager;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import rfcomponents.button.Button;
	import rfcomponents.checkbox.CheckBox;
	import rfcomponents.panel.Panel;
	import rfcomponents.radiobutton.RadioButton;
	import rfcomponents.text.Text;
	
	public class TestPanel extends Panel
	{
		public function TestPanel()
		{
			super();
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
		
		public function createRadioButton(x:int,y:int,w:int,h:int,group:String,defaultlabel:String='',data:Object = null):RadioButton{
			var button:RadioButton = new TestRadioButton(w,h,group);
			button.label = defaultlabel;
			button.x = x;
			button.y = y;
			button.data = data;
			addChild(button.skin);
			return button;
		}
		
		public function createCheckBox(x:int,y:int,w:int,h:int,defaultlabel:String='',data:Object = null):CheckBox{
			var button:CheckBox = new TestCheckBox(w,h);
			button.label = defaultlabel;
			button.x = x;
			button.y = y;
			button.data = data;
			addChild(button.skin);
			return button;
		}
		
	}
}