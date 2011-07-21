package rfcomponents.list.itemrender
{
	import flash.display.Sprite;
	
	import rfcomponents.button.Button;
	
	public class ListItemRender extends Button
	{
		public function ListItemRender(skin:Sprite=null)
		{
			super(skin);
		}
		
		override protected function textResize():void{
			var _textHeight:int;
			_textHeight = int(textField.defaultTextFormat.size)+2;
			textField.x = 0;
			textField.y = (_height - _textHeight-6)/2;
		}
	}
}