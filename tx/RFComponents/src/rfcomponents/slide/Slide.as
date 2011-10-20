package rfcomponents.slide
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import rfcomponents.SkinBase;
	import rfcomponents.zother.DragHelp;
	
	public class Slide extends SkinBase
	{
		public function Slide()
		{
			super();
		}
		
		protected var bg:Sprite;
		protected var slider:Sprite;
		protected var drag:DragHelp;
		public function bindBg(bg:Sprite):void{
			this.bg = bg;
			bg.addEventListener(MouseEvent.CLICK,bgClickHandler);
		}
		
		public function bindSlider(slider:Sprite):void{
			this.slider = slider;
			drag = new DragHelp(slider);
			drag.bindDragTarget(slider);
			drag.ylock = true;
			drag.addEventListener(Event.CHANGE,chageHandler);
			if(bg){
				drag.setDragRect(getDragRect());
			}
		}
		
		
		protected var hSlider:Number;
		protected function getDragRect():Rectangle{
			hSlider = slider.width/2;
			return new Rectangle(0,0,bg.width,0);
		}
		
		
		protected function bgClickHandler(event:MouseEvent):void{
			var dx:Number = bg.mouseX - hSlider;
			ceilPercent(dx);
		}
		
		private function chageHandler(event:Event):void{
			ceilPercent(slider.x,true);
		}
		
		protected function ceilPercent(dx:Number,moveFlag:Boolean = false):void{
			dx = dx < 0 ? 0 : dx;
			dx = dx > (bg.width - hSlider*2) ? (bg.width - hSlider*2) : dx;
			currentPercent =  dx /(bg.width-hSlider*2);
			slider.x = currentPercent * (bg.width - hSlider*2);
			this.dispatchEvent(new Event(moveFlag ? Event.CHANGE : (MouseEvent.CLICK + Event.CHANGE)));
		}
		
		protected var currentPercent:Number;
		public function setPercent(value:Number,dispatch:Boolean = true):void{
			value = value < 0 ? 0 : value;
			value = value > 1 ? 1 : value;
			currentPercent = value;
			slider.x = currentPercent * (bg.width - hSlider*2);
			if(dispatch){
				this.dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		public function get percent():Number{
			return currentPercent;
		}
	}
}