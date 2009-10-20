package com.display.wskin.button
{
	import com.display.Box;
	import com.display.LayoutType;
	import com.display.button.ButtonBase;
	import com.display.skin.SkinInteractiveBase;
	import com.display.text.Text;
	import com.display.wskin.button.buttonskin.DefaultButtonSkin;

	public class WButton extends ButtonBase
	{
		public function WButton(skin:SkinInteractiveBase = null,type:String=LayoutType.HORIZONTAL, directionFlag:Boolean=false)
		{
			if(skin == null){
				skin = new DefaultButtonSkin();
			}
			textField = new Text()
			_textField.text = "按钮2222"
			super(skin, type, directionFlag);
			this.hAlign = LayoutType.MIDDLE;
			this.vAlign = LayoutType.CENTER
			this.addChildToBoxLayer(_textField);
			addListener();
		}
		
		override protected function bulid():void{
			super.bulid();
		}
		
	}
}