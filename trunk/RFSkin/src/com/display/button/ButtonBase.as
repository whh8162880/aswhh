package com.display.button
{
	import com.display.Container;
	import com.display.LayoutType;
	import com.display.skin.SkinInteractiveBase;
	import com.display.utils.geom.IntRectangle;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class ButtonBase extends Container
	{
		protected var skinInteractive:SkinInteractiveBase
		protected var onlySkin:Boolean = false
		protected var _textField:TextField;
		protected var _labelString:String;
		public function ButtonBase(skin:Object=null,type:String=LayoutType.HORIZONTAL, directionFlag:Boolean=false)
		{
			this.useHandCursor = true;
			this.buttonMode = true;
			_enabled = true;
			super(getUseSkin(skin));
			this._layout = LayoutType.HORIZONTAL;
//			this.graphics.beginFill(0xffff00,1);
//			this.graphics.drawCircle(0,0,2);
//			this.graphics.endFill();
		}
		
		override protected function doEnabled():void{
			this._enabled ? addListener() : removeListener();
			skinInteractive.enabled = _enabled;
			skinInteractive.refresh();
			if(onlySkin){
				setSkinColorNULL(_enabled);
			}
		}
		
		public function get textField():TextField{
			return _textField;
		}
		
		public function set textField(value:TextField):void{
			if(value == null){
				return;
			}
			
			if(_textField != null){
				value.htmlText = _textField.htmlText;
			}else{
				value.htmlText = _labelString ? _labelString : "";
			}
			
			_textField = value;
		}
		
		public function set label(value:String):void{
			_labelString = value;
			if(_textField!=null)
				_textField.htmlText = value;
		}
		
		public function get label():String{
			return _labelString;
		}
		
		protected function getUseSkin(_skin:Object):DisplayObjectContainer{
			if(_skin is SkinInteractiveBase){
				onlySkin = false;
				skinInteractive =  _skin as SkinInteractiveBase
			}else{
				onlySkin = true;
				skinInteractive =  new SkinInteractiveBase(_skin);
			}
			return skinInteractive;
		}
		
		protected function addListener():void{
			this.addEventListener(MouseEvent.ROLL_OVER,rollHandelr);
			this.addEventListener(MouseEvent.ROLL_OUT,rollHandelr);
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseHandler);
		}
		
		protected function removeListener():void{
			this.removeEventListener(MouseEvent.ROLL_OVER,rollHandelr);
			this.removeEventListener(MouseEvent.ROLL_OUT,rollHandelr);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,mouseHandler);
		}
		
		override protected function createSkin():void{
			
		}
		
		
		protected function rollHandelr(event:MouseEvent):void{
			var mouseover:Boolean = (event.type == MouseEvent.ROLL_OVER);
			var num:Number = numChildren;
			while(num--){
				var active:SkinInteractiveBase = getChildAt(num) as SkinInteractiveBase;
				if(active == null){
					continue;
				}
				active.mouseover = mouseover;
				active.refresh(intRectangle,skinInteractive.width,skinInteractive.height);
			}
		}
		
		protected function mouseHandler(event:MouseEvent):void{
			var b:Boolean = event.type == MouseEvent.MOUSE_DOWN
			if(b){
				stage.addEventListener(MouseEvent.MOUSE_UP,mouseHandler);
				
			}else{
				IEventDispatcher(event.target).removeEventListener(MouseEvent.MOUSE_UP,mouseHandler);
			}
			
			var num:Number = numChildren;
			while(num--){
				var active:SkinInteractiveBase = getChildAt(num) as SkinInteractiveBase;
				if(active == null){
					continue;
				}
				active.selected = b;
				active.refresh(intRectangle,skinInteractive.width,skinInteractive.height);
			}
		}
		
		override public function get intRectangle():IntRectangle{
			if(intRectangleFlag == false && _intRectangle){
//				_intRectangle.x = this.x;
//				_intRectangle.y = this.y;
				_intRectangle.width = skinInteractive.width;
				_intRectangle.height =  skinInteractive.height;
			}
			return _intRectangle; 
		}
		
		
		override protected function bulid():void{
			super.bulid();
		}
		
	}
}










