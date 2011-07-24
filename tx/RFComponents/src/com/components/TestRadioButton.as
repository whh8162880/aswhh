package com.components
{
	import com.components.machine.TestRadiobuttonRenderMachine;
	
	import flash.display.Sprite;
	
	import rfcomponents.radiobutton.RadioButton;
	import rfcomponents.zother.rendermachine.RenderMachine;
	
	public class TestRadioButton extends RadioButton
	{
		public function TestRadioButton(group:String = null)
		{
			super(null,group,new TestRadiobuttonRenderMachine());
		}
		
		override protected function textResize():void{
			super.textResize();
			textField.x = 22;
		}
	}
}