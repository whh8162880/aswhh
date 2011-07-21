package rfcomponents.list.itemrender
{
	import flash.display.Sprite;
	
	import rfcomponents.button.Button;
	import rfcomponents.zother.rendermachine.RenderMachine;
	
	public class ListItemRender extends Button
	{
		public function ListItemRender(skin:Sprite=null,machine:RenderMachine=null)
		{
			super(skin,machine);
		}
		
		override protected function textResize():void{
			var _textHeight:int;
			_textHeight = int(textField.defaultTextFormat.size)+2;
			textField.x = 0;
			textField.y = (_height - _textHeight-6)/2;
		}
	}
}