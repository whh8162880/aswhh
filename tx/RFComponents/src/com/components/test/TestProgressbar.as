package com.components.test
{
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import rfcomponents.progressbar.ProgressBar;
	
	public class TestProgressbar extends ProgressBar
	{
		protected var bg:Shape;
		protected var bar:Shape;
		public function TestProgressbar()
		{
			var s:Sprite = new Sprite;
			bg = new Shape();
			var g:Graphics = bg.graphics;
			g.beginFill(0xf8cccd);
			g.drawRect(0,0,200,11);
			g.endFill();
			
			bar = new Shape();
			bar.y = 1;
			bar.x = 1;
			g = bar.graphics;
			g.beginFill(0x994140);
			g.drawRect(0,0,10,10);
			g.endFill();
			
			s.addChild(bg);
			s.addChild(bar);
			
			super(s);
			
			_width = 200;
			
			textField = createText();
			s.addChild(textField);
			textField = textField;
		}
		
		override protected function doSizeRender():void{
			bg.width = _width;
			doProgress();
		}
		
		override protected function doProgress():void{
			bar.width = current/totle * (_width-1);
		}
		
		override protected function textResize():void{
			textField.x = (_width - textField.textWidth-4)/2;
		}
		
		
	}
}