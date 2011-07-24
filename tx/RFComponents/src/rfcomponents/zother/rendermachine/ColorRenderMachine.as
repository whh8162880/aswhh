package rfcomponents.zother.rendermachine
{
	import com.utils.ColorUtils;
	
	import flash.display.Graphics;
	
	import rfcomponents.SkinBase;

	public class ColorRenderMachine extends RenderMachine
	{
		public function ColorRenderMachine()
		{
			super();
			color = 0xFFFFFF;
		}
		
		protected var c_default:uint;
		
		protected var c_roll:uint;
		
		protected var c_mouse:uint;
		
		protected var c_selected:uint;
		
		protected var c_e_default:uint;
		
		protected var c_e_roll:uint;
		
		protected var c_e_mouse:uint;
		
		protected var c_e_selected:uint;
		
		public function set color(value:uint):void{
			c_default = value;
			c_roll = ColorUtils.adjustBrightness(value,-20);
			c_mouse = ColorUtils.adjustBrightness(value,-100);
			c_selected = ColorUtils.adjustBrightness(value,-50);
			c_e_default = c_e_roll = c_e_mouse = c_e_selected = 0xCCCCCC;
		}
		
		protected function getColor(_mouse:Boolean, _roll:Boolean, _enabled:Boolean, _selected:Boolean):uint{
			if(_enabled){
				if(_mouse){
					return c_mouse;
				}else if(_roll){
					return c_roll;
				}else if(_selected){
					return c_selected;
				}else{
					return c_default;
				}
			}else{
				if(_mouse){
					return c_e_mouse;
				}else if(_roll){
					return c_e_roll;
				}else if(_selected){
					return c_e_selected;
				}else{
					return c_e_default;
				}
			}
		}
		
		override public function render(target:SkinBase, _width:int, _height:int, _mouse:Boolean, _roll:Boolean, _enabled:Boolean, _selected:Boolean):void{
			var c:int = getColor(_mouse,_roll,_enabled,_selected);
			var g:Graphics = target.skin.graphics;
			g.clear();
			g.beginFill(c);
			g.drawRoundRect(0,0,_width,_height,5,5);
			g.endFill();
		}
	}
}