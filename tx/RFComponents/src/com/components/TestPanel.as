package com.components
{
	import com.components.test.TestSlide;
	import com.utils.UILocator;
	import com.utils.key.KeyboardManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	import rfcomponents.button.Button;
	import rfcomponents.checkbox.CheckBox;
	import rfcomponents.panel.Panel;
	import rfcomponents.radiobutton.RadioButton;
	import rfcomponents.slide.Slide;
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
		
		public function createTextFiled(x:int,y:int,w:int,h:int,input:Boolean = false,defaultlable:String = '',color:int=0xF8F8F8,bgcolor:int = 0xFFFFFF,alpha:Number = 0):Text{
			var text:Text = new Text();
			text.create(w,h,bgcolor,false,alpha);
			text.x = x;
			text.y = y;
			text.getTextField().textColor = color;
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
		
		public function createSlide(x:int,y:int,w:int,h:int,color:int = 0xFF5D00):Slide{
			var slide:Slide = new TestSlide();
			slide.create(w,h,color);
			slide.x = x;
			slide.y = y;
			addChild(slide.skin);
			return slide;
		}
		
		public function addChildByPoint(child:DisplayObject,x:int,y:int):void{
			child.x = x;
			child.y = y;
			addChild(child);
		}
		
		
	}
}