package com.display.wskin.button
{
	import com.display.LayoutType;
	import com.display.button.ButtonBase;
	import com.display.skin.SkinInteractiveBase;
	import com.display.wskin.button.buttonskin.DefaultButtonSkin;

	public class WButton extends ButtonBase
	{
		public function WButton(skin:SkinInteractiveBase = null,type:String=LayoutType.HORIZONTAL, directionFlag:Boolean=false)
		{
			if(skin == null){
				skin = new DefaultButtonSkin();
			}
			super(skin, type, directionFlag);
			addListener();
		}
		
	}
}