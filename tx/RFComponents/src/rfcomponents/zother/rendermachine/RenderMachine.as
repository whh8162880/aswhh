package rfcomponents.zother.rendermachine
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import rfcomponents.SkinBase;
	/**
	 * 渲染机器
	 * @author wang
	 * 
	 */
	public class RenderMachine
	{
		public function RenderMachine()
		{
			
		}
		
		public function render(target:SkinBase,_width:int,_height:int,_mouse:Boolean,_roll:Boolean,_enabled:Boolean,_selected:Boolean):void{
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
			
			var g:Graphics = target.skin.graphics;
			g.clear();
			g.beginFill(c);
			g.drawRoundRect(0,0,_width,_height,5,5);
			g.endFill();

		}
	}
}