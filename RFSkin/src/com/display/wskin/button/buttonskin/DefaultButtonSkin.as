package com.display.wskin.button.buttonskin
{
	import com.display.skin.SkinInteractiveBase;
	
	import flash.display.DisplayObject;

	public class DefaultButtonSkin extends SkinInteractiveBase
	{
		[Embed(source="assets/skin/Button_defaultImage.png", scaleGridTop="11", scaleGridBottom="12", 
			scaleGridLeft="5", scaleGridRight="75")]
		private var Button_defaultImage:Class;
		
		[Embed(source="assets/skin/Button_pressedImage.png", scaleGridTop="11", scaleGridBottom="12", 
			scaleGridLeft="5", scaleGridRight="75")]
		private var Button_pressedImage:Class;
		
		[Embed(source="assets/skin/Button_rolloverImage.png", scaleGridTop="11", scaleGridBottom="12", 
			scaleGridLeft="5", scaleGridRight="75")]
		private var Button_rolloverImage:Class;
		
		[Embed(source="assets/skin/Button_disabledImage.png", scaleGridTop="11", scaleGridBottom="12", 
			scaleGridLeft="5", scaleGridRight="75")]
		private var Button_disabledImage:Class;
		
		[Embed(source="assets/skin/Button_DefaultButton_defaultImage.png", scaleGridTop="11", scaleGridBottom="12", 
			scaleGridLeft="5", scaleGridRight="75")]
		private var Button_DefaultButton_defaultImage:Class;
		
		public function DefaultButtonSkin()
		{
			var p:DisplayObject = new Button_pressedImage()
			skin = [new Button_defaultImage(),new Button_rolloverImage(),p,p,
			new Button_disabledImage(),null,null,null]
			super(skin, null);
		}
		
	}
}