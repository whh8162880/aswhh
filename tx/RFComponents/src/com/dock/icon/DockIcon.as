package com.dock.icon
{
	import com.dock.DockManager;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import rfcomponents.zother.DragHelp;
	
	public class DockIcon extends Sprite implements IDockIcon
	{
		private var t:TextField;
		public var drag:DragHelp;
		
		public var group:String = 'A';
		
		protected var _nextMoveIndex:int = -1;
		
		public function set nextMoveIndex(value:int):void{
			_nextMoveIndex = value;
		}
		
		public function get nextMoveIndex():int{
			return _nextMoveIndex
		}
		
		public function DockIcon()
		{
			super();
			drag = new DragHelp(this);
			drag.bindDragTarget(this);
			addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
		}
		
		public function setName(name:String):void{
			if(!t){
				t = new TextField();
				var textFormat:TextFormat = t.defaultTextFormat;
				textFormat.font = 'Tahoma';
				textFormat.size = 13;
				textFormat.color = 0xFFFFFF;
				t.defaultTextFormat = textFormat;
				t.mouseEnabled = false;
				t.selectable = false;
				t.filters = [new GlowFilter(0,100,2,2,3,1,false,false)];
			}
			
			t.htmlText = name;
			t.width = t.textWidth+5;
			t.height = t.textHeight+2;
			t.x = (width-t.width)/2;
			t.y = (height - t.height)/2-1;
			//addChild(t);
		}
		
		protected function mouseDownHandler(event:MouseEvent):void{
			this.parent.addChild(this);
			DockManager.getInstance(group).startDargIcon(this);
		}
		
		public function renderClass(cls:Class):void{
			var d:Bitmap = new cls();
			var sx:Number = 50/d.width;
			var sy:Number = 50/d.height;
			graphics.clear();
			graphics.beginBitmapFill(d.bitmapData,new Matrix(sx,0,0,sy,0,0),true,true);
			graphics.drawRect(0,0,50,50);
			graphics.endFill();
			
			
		}
	}
}