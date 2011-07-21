package com.components
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import rfcomponents.button.Button;
	
	public class TestButton extends Button
	{
		public function TestButton(w:int,h:int)
		{
			create(w,h,0xCCCCCC,false);
		}
		
		override protected function renderFace():void{
			var c:int = 0xCCCCCC;
			if(_enabled){
				if(_mouse){
					c = 0x888888;
				}else if(_roll){
					c = 0xDDDDDD;
				}
			}else{
				c = 0xCCCCCC;
			}
			
			var g:Graphics = _skin.graphics;
			g.clear();
			g.beginFill(c);
			g.drawRoundRect(0,0,_width,_height,5,5);
			g.endFill();
		}
	}
}