package com.components
{
	import com.components.machine.TestCheckBoxRenderMachine;
	
	import flash.display.Sprite;
	
	import rfcomponents.checkbox.CheckBox;
	import rfcomponents.zother.rendermachine.RenderMachine;
	
	public class TestCheckBox extends CheckBox
	{
		public function TestCheckBox(w:int,h:int)
		{
			super(null, new TestCheckBoxRenderMachine());
			create(w,h,0);
		}
		
		override protected function textResize():void{
			super.textResize();
			textField.x = 22;
		}
	}
}