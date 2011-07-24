package rfcomponents.checkbox
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import rfcomponents.button.Button;
	import rfcomponents.radiobutton.RadioButton;
	import rfcomponents.zother.rendermachine.RenderMachine;
	
	public class CheckBox extends Button
	{
		public function CheckBox(skin:Sprite=null, machine:RenderMachine=null)
		{
			super(skin, machine);
		}
		
		override public function set skin(skin:Sprite):void{
			super.skin = skin;
			addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		protected function clickHandler(event:MouseEvent):void{
			selected = !_selected
		}
		
		override protected function textResize():void{
			var _textHeight:int;
			if(!_editable){
				_textHeight = textField.textHeight;
			}else{
				_textHeight = int(textField.defaultTextFormat.size)+2;
			}
			textField.y = (_height - _textHeight-6)/2;
			if(machine){
				machine.render(this,_width,_height,_mouse,_roll,_enabled,_selected);
			}
		}
	}
}