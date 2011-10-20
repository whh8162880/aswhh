package com.components.test
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import rfcomponents.slide.Slide;
	
	public class TestSlide extends Slide
	{
		public function TestSlide()
		{
			super();
		}
		
		private var color:int;
		override public function create(width:int, height:int, color:int=0xFFFFFF, line:Boolean=true,alpha:Number = 0):void{
			this.color = color;
			var bg:Sprite = new Sprite();
			var g:Graphics = bg.graphics;
			g.beginFill(color);
			g.drawRect(0,height/4,width,height/2);
			g.endFill();
			
			var slider:Sprite = new Sprite();
			slider.buttonMode = slider.useHandCursor = true;
			g = slider.graphics;
			g.beginFill(color);
			g.moveTo(6,0);
			g.lineTo(12,height/4-2);
			g.lineTo(12,height);
			g.lineTo(0,height);
			g.lineTo(0,height/4-2);
			g.lineTo(6,0);
			
			bindBg(bg);
			bindSlider(slider);
			
			_skin = new Sprite();
			_width = width;
			_height = height;
		//	doSizeRender();
			
			slider.x = 0;
			addChild(bg);
			addChild(slider);
		}
		
		override protected function doSizeRender():void{
			var g:Graphics = bg.graphics;
			g.clear();
			g.beginFill(color);
			g.drawRect(0,_height/4,_width,_height/2);
			g.endFill();
			
			g = slider.graphics;
			g.clear();
			g.beginFill(color);
			g.moveTo(6,0);
			g.lineTo(12,_height/4-2);
			g.lineTo(12,_height);
			g.lineTo(0,_height);
			g.lineTo(0,_height/4-2);
			g.lineTo(6,0);
			
			drag.setDragRect(getDragRect());
		}
	}
}