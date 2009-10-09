package com.display.text
{
	import com.display.event.LayoutEvent;
	
	import flash.filters.GlowFilter;
	import flash.text.TextField;

	public class Text extends TextField
	{
		public function Text(w:Number=100,h:Number=20)
		{
			setHandlerArea(w,h);
			this.autoSize = "left"
			super();
		}
		protected var textWidthFlag:Number = -1;
		protected var textHeightFlag:Number = -1;
		
		protected var _width:Number = -1;
		protected var _height:Number = -1;
		
		protected var textType:String;
		protected var currentText:String
		
		override public function set width(value:Number):void{
			_width = value;
			dispatch()
		}
		
		override public function set height(value:Number):void{
			_height = value;
			dispatch()
		}
		
		override public function get width():Number{
			if(_width == -1)
				return this.textWidth;
			return _width;
		}
		
		override public function get height():Number{
			if(_height == -1)
				return this.textHeight;
			return _height;
		}
		
		public function setWH(w:Number,h:Number):void{
			_width = w;
			_height = h;
			dispatch();
		}
		
		public function setHandlerArea(w:Number,h:Number):void{
			super.width = w;
			super.height = h;
		}
		
		override public function set text(value:String):void{
			if(value == currentText) {
				return;
			}
			currentText = value;
			value = getText(value);
			super.text = value;
			dispatch2();
		}
		
		override public function set htmlText(value:String):void{
			if(value == currentText) {
				return;
			}
			currentText = value;
			value = getText(value);
			super.htmlText = value;
			dispatch2();
		}
		
		override public function appendText(newText:String):void{
			super.appendText(newText);
			dispatch2();
		}
		
		protected function dispatch2():void{
			if((_width == -1 || _height == -1) && (textWidthFlag != this.width || textHeightFlag != this.height)){
				dispatch();
			}
		}
		
		protected function dispatch():void{
			textWidthFlag = this.width;
			textHeightFlag = this.height;
			this.dispatchEvent(new LayoutEvent(LayoutEvent.BUILD));
		}
		
		public function setTextType(str:String):void{
			textType = str;
		}
		
		protected function getText(str:String):String{
			if(textType){
				str = textType.replace("{0}",str);
			}
			
			return str;
		}
		
		public function setTextColor(textColor:int,textFilterColor:int):void{
			this.textColor = textColor
			this.filters = [new GlowFilter(textFilterColor, 100, 2, 2, 5, 1, false, false)];
		}
	}
}