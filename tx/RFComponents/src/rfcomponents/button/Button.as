package rfcomponents.button
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import rfcomponents.text.Text;
	import rfcomponents.zother.rendermachine.RenderMachine;
	
	public class Button extends Text
	{
		public function Button(skin:Sprite = null,machine:RenderMachine = null)
		{
			super();
			if(skin){
				this.skin = skin;
			}
			if(machine){
				this._machine = machine;
			}
		}
		/**
		 * 渲染器 
		 */		
		protected var _machine:RenderMachine;
		public function set machine(machine:RenderMachine):void{
			this._machine = machine;
			renderHelp.addRender("renderFace",renderFace);
			doMachine();
		}
		public function get machine():RenderMachine{
			return _machine;
		}
		protected function doMachine():void{
			
		}
		
		protected var _roll:Boolean;
		protected var _mouse:Boolean;
		override public function set skin(skin:Sprite):void{
			super.skin = skin;
			addEventListener(MouseEvent.ROLL_OVER,rollHandler);
			addEventListener(MouseEvent.ROLL_OUT,rollHandler);
			addEventListener(MouseEvent.MOUSE_DOWN,mouseHandler);
			renderFace();
		}
		
		protected function renderFace():void{
			renderHelp.addRender("renderFace",doRenderFace);
		}
		
		protected function mouseHandler(event:MouseEvent):void{
			_mouse = event.type == MouseEvent.MOUSE_DOWN;
			if(_mouse){
				stage.addEventListener(MouseEvent.MOUSE_UP,mouseHandler);
			}else{
				stage.removeEventListener(MouseEvent.MOUSE_UP,mouseHandler);
			}
			doRenderFace();
		}
		
		protected function rollHandler(event:MouseEvent):void{
			_roll = event.type == MouseEvent.ROLL_OVER;
			doRenderFace();
		}
		
		protected function doRenderFace():void{
			if(_machine){
				_machine.render(this,_width,_height,_mouse,_roll,_enabled,_selected);
			}
		}
		
		override public function set enabled(value:Boolean):void{
			super.enabled = value;
			renderFace(); 
		}
		
		override public function set selected(value:Boolean):void{
			super.selected = value;
			renderFace();
		}
		
		public function bindClick(func:Function):void{
			addEventListener(MouseEvent.CLICK,func);
		}
		
	}
}