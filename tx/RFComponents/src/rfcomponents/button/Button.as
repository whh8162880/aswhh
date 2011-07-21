package rfcomponents.button
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import rfcomponents.text.Text;
	
	public class Button extends Text
	{
		public function Button(skin:Sprite = null)
		{
			super();
			if(skin){
				this.skin = skin;
			}
		}
		
		protected var _roll:Boolean;
		protected var _mouse:Boolean;
		override public function set skin(skin:Sprite):void{
			super.skin = skin;
			addEventListener(MouseEvent.ROLL_OVER,rollHandler);
			addEventListener(MouseEvent.ROLL_OUT,rollHandler);
			addEventListener(MouseEvent.MOUSE_DOWN,mouseHandler);
		}
		
		protected function mouseHandler(event:MouseEvent):void{
			_mouse = event.type == MouseEvent.MOUSE_DOWN;
			if(_mouse){
				stage.addEventListener(MouseEvent.MOUSE_UP,mouseHandler);
			}else{
				stage.removeEventListener(MouseEvent.MOUSE_UP,mouseHandler);
			}
			renderFace();
		}
		
		protected function rollHandler(event:MouseEvent):void{
			_roll = event.type == MouseEvent.ROLL_OVER;
			renderFace();
		}
		
		protected function renderFace():void{
			
		}
		
		override public function set enabled(value:Boolean):void{
			super.enabled = value;
			renderFace(); 
		}
		
	}
}