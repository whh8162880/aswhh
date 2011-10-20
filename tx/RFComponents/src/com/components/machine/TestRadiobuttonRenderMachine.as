package com.components.machine
{
	import com.utils.ColorUtils;
	
	import flash.display.Graphics;
	
	import rfcomponents.SkinBase;
	import rfcomponents.text.Text;
	import rfcomponents.zother.rendermachine.ColorRenderMachine;
	
	public class TestRadiobuttonRenderMachine extends ColorRenderMachine
	{
		public function TestRadiobuttonRenderMachine()
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
			g.beginFill(c,0);
			g.drawRect(0,0,_width,_height);
			g.endFill();
			
			if(_selected){
				g.beginFill(0);
				g.drawCircle(12,_height/2,2);
				g.endFill()
			}
			
			g.lineStyle(2);
			g.drawCircle(12,_height/2,6);
		}
	}
}