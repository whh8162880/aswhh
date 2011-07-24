package com.components
{
	import com.components.machine.TestRadiobuttonRenderMachine;
	
	import flash.display.Sprite;
	
	import rfcomponents.radiobutton.RadioButton;
	import rfcomponents.zother.rendermachine.RenderMachine;
	
	public class TestRadioButton extends RadioButton
	{
		public function TestRadioButton(w:int,h:int,group:String = null)
		{
			super(null,null,new TestRadiobuttonRenderMachine());
			create(w,h);
			if(group){
				this.group = group;
			}
		}
		
		override protected function textResize():void{
			super.textResize();
			textField.x = 22;
		}
	}
}