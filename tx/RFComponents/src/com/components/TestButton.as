package com.components
{
	import flash.display.Graphics;
	
	import rfcomponents.button.Button;
	
	public class TestButton extends Button
	{
		private var colors:Array;
		public function TestButton(w:int,h:int,colors:Array = null)
		{
			if(!colors){
				colors = [0xCCCCCC,0x888888,0xDDDDDD];
			}
			this.colors = colors;
			create(w,h,colors[0],false);
			textField.textColor = 0;
			textField.mouseEnabled = false;
			_skin.useHandCursor = true;
			_skin.buttonMode = true;
		}
		
		override protected function doRenderFace():void{
			var c:int = colors[0];
			if(_enabled){
				if(_mouse){
					c = colors[1];
				}else if(_roll){
					c = colors[2];
				}
			}
			
			var g:Graphics = _skin.graphics;
			g.clear();
			g.beginFill(c);
			g.drawRoundRect(0,0,_width,_height,5,5);
			g.endFill();
		}
	}
}