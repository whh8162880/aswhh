package com.display.panel
{
	import com.display.Box;
	import com.display.LayoutType;
	import com.display.button.ButtonBase;
	import com.display.utils.geom.IntRectangle;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;

	public class PanelMoveArea extends Box
	{
		protected var panel:DisplayObject;
		protected var stage:Stage;
		protected var offsetx:int;
		protected var offsety:int;
		public function PanelMoveArea(panel:DisplayObject = null, _skin:DisplayObjectContainer=null)
		{
			this.panel = panel;
			this._hAlign = LayoutType.RIGHT;
			this._vAlign = LayoutType.CENTER;
			super(LayoutType.HORIZONTAL, false , _skin);
		}
		
		public function addbutton(button:ButtonBase):void{
			if(button)
				this.addChild(button);
		}
		
		public function removeButton(button:ButtonBase):void{
			if(button){
				this.removeChild(button);
			}
		}
		
		public function addMoveArea(target:IEventDispatcher):void{
			target.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
		}
		
		protected function mouseDownHandler(event:MouseEvent):void{
			var d:DisplayObject = event.target as DisplayObject;
			var dispather:IEventDispatcher
			if(!stage && d){
				stage = d.stage;
			}
			if(panel != null){
				dispather = d ? stage : IEventDispatcher(event.target)
				dispather.addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
				dispather.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
				offsetx = panel.mouseX;
				offsety = panel.mouseY;
			}
		}
		
		protected function mouseMoveHandler(event:MouseEvent):void{
			if(panel){
				panel.x += (panel.mouseX - offsetx)
				panel.y += (panel.mouseY - offsetx)
				offsetx = panel.mouseX;
				offsety = panel.mouseY;
			}else{
				IEventDispatcher(event.target).removeEventListener(event.type,mouseMoveHandler);
			}
		}
		
		protected function mouseUpHandler(event:MouseEvent):void{
			IEventDispatcher(event.target).removeEventListener(event.type,mouseUpHandler);
		}
		
		public function setHandlerArea(w:int,h:int,color:int=0,alpha:Number=0):void{
			var g:Graphics = this.graphics;
			g.clear();
			g.beginFill(color,alpha);
			g.drawRect(0,0,w,h);
			g.endFill();
			if(!_intRectangle){
				_intRectangle = new IntRectangle(0,0,w,h);
			}else{
				_intRectangle.width = w;
				_intRectangle.height = h;
			}
			
			intRectangle = _intRectangle;
		}
		
	}
}