package com.display.panel
{
	import com.display.Box;
	import com.display.Container;
	import com.display.LayoutType;
	import com.display.button.ButtonBase;
	import com.display.utils.geom.IntRectangle;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;

	public class PanelMoveArea extends Container
	{
		protected var panel:DisplayObject;
		protected var _stage:Stage;
		protected var offsetx:int;
		protected var offsety:int;
		protected var _box:Box
		public function PanelMoveArea(panel:DisplayObject = null, _skin:DisplayObjectContainer=null)
		{
			this.panel = panel;
			this._hAlign = LayoutType.RIGHT;
			this._vAlign = LayoutType.CENTER;
			_box = new Box()
			super(_skin);
			addDisplayObjectToLayer("panel_move_box",_box,999);
		}
		
		public function addbutton(button:ButtonBase,index:int = 999):void{
			if(button)
				_box.addChild(button);
		}
		
		public function removeButton(button:ButtonBase):void{
			if(button){
				_box.removeChild(button);
			}
		}
		
		public function addMoveArea(target:IEventDispatcher):void{
			target.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
		}
		
		protected function mouseDownHandler(event:MouseEvent):void{
			var d:DisplayObject = event.target as DisplayObject;
			var dispather:IEventDispatcher
			if(!_stage && d){
				_stage = d.stage;
			}
			if(panel != null){
				dispather = d ? _stage : IEventDispatcher(event.target)
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