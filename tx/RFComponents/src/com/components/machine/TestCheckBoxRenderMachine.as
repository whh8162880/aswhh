package com.components.machine
{
	import flash.display.Graphics;
	
	import rfcomponents.SkinBase;
	import rfcomponents.zother.rendermachine.ColorRenderMachine;
	
	public class TestCheckBoxRenderMachine extends ColorRenderMachine
	{
		public function TestCheckBoxRenderMachine()
		{
			super();
		}
		
		override public function set color(value:uint):void{
			super.color = value;
			c_selected = value;
		}
		
		override public function render(target:SkinBase, _width:int, _height:int, _mouse:Boolean, _roll:Boolean, _enabled:Boolean, _selected:Boolean):void{
			var c:int = getColor(_mouse,_roll,_enabled,_selected);
			var g:Graphics = target.skin.graphics;
			g.clear();
			g.beginFill(c);
			g.drawRect(0,0,_width,_height);
			g.endFill();
			
			if(_selected){
				g.beginFill(0);
				g.drawRect(10,_height/2-2,4,4);
				g.endFill()
			}
			
			g.lineStyle(2);
			g.drawRect(6,_height/2-6,12,12);
		}
	}
}