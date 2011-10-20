package rfcomponents.text
{
	import flash.display.Graphics;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import rfcomponents.SkinBase;
	import rfcomponents.vo.OffsizeVO;
	
	public class Text extends SkinBase
	{
		public static function createText(tcolor:int = 0xF8F8F8,filter:Array = null,size:int = 13):TextField{
			var text:TextField = new TextField();
			var textFormat:TextFormat = text.defaultTextFormat;
			textFormat.font = 'Tahoma';
			textFormat.size = size;
			textFormat.color = tcolor;
			text.defaultTextFormat = textFormat;
			text.mouseEnabled = false;
			text.selectable = false;
			if(filter){
				text.filters = filter;
			}
			//text.filters = [new GlowFilter(0xFFFFFF,100,2,2,3,1,false,false)];
			text.width = 20;
			text.height = 20;
			return text;
		}
		
		//---------------------------------------------------------------------------------------------------------------
		//
		//label
		//
		//---------------------------------------------------------------------------------------------------------------
		protected var _label:String;
		public function set label(value:String):void{
			_label = value;
			doLabel();
		}
		public function get label():String{
			if(_editable){
				return textField.text;
			}
			return _label;
		}
		
		protected var _editable:Boolean;
		public function set editable(value:Boolean):void{
			_editable = value;
			doEditable();
		}
		public function get editable():Boolean{
			return _editable;
		}
		
		
	//-------------------------------------------------------------------------------------------------------------------
	//
	//-------------------------------------------------------------------------------------------------------------------
		protected var textField:TextField;
		protected var offsize:OffsizeVO;
		public function Text()
		{
			super();
		}
		
		override public function create(width:int, height:int, color:int=0xFFFFFF, line:Boolean=false,alpha:Number = 0):void{
			offsize = new OffsizeVO();
			textField = createText();
			super.create(width,height,color,line,alpha);
			addChild(textField);
			doEditable()
		}
		
		public function getTextField():TextField{
			return textField;
		}
		
		public function setOffsize(l:int,t:int,r:int,u:int):void{
			offsize.l = l;
			offsize.t = t;
			offsize.r = r;
			offsize.u = u;
			renderSize();
		}
		
		override protected function doSizeRender():void{
			_skin.graphics.clear();
			_skin.graphics.beginFill(0xFFFFFF,0);
			_skin.graphics.drawRect(0,0,_width,_height);
			_skin.graphics.endFill();
			_skin.scrollRect = new Rectangle(0,0,width+1,height+1);
			textResize();
		}
		
		protected function textResize():void{
			var _textHeight:int;
			if(!_editable){
				_textHeight = textField.textHeight;
				textField.x = (_width - textField.textWidth-4)/2;
			}else{
				_textHeight = int(textField.defaultTextFormat.size)+2;
				textField.x = 0;
			}
			textField.y = (_height - _textHeight-6)/2;
		}
		
		protected function doLabel():void{
			textField.htmlText = _label;
			textField.width = textField.textWidth+10;
			textResize();
		}
		
		protected function doEditable():void{
			if(_editable){
				textField.autoSize = TextFieldAutoSize.NONE;
				textField.mouseEnabled = true;
				textField.selectable = true;
				textField.type = TextFieldType.INPUT;
				textField.width = _width;
				textField.height = _height;
			}else{
				textField.autoSize = TextFieldAutoSize.LEFT;
				textField.mouseEnabled = false;
				textField.selectable = false;
				textField.type = TextFieldType.DYNAMIC;
				label = textField.text;
			}
			textResize();
		}
		
		
	}
}