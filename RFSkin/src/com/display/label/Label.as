package com.display.label
{
	import com.display.Box;
	import com.display.LayoutType;
	import com.display.button.ButtonBase;
	import com.display.text.Text;
	
	import flash.display.DisplayObjectContainer;

	public class Label extends ButtonBase
	{
		public function Label(skin:Object=null, type:String=LayoutType.HORIZONTAL, directionFlag:Boolean=false)
		{
			super(skin, type, directionFlag);
			if(skin == null){
				skin = initSkin()
			}
			addListener()
			
			this._vAlign = LayoutType.CENTER;
			this._hAlign = LayoutType.LEFT;
		}
		
		override protected function initSkin():DisplayObjectContainer{
			var text:Text = new Text();
			text.setTextColor(0xFFFFFF,0);
			addChildToBoxLayer(text);
			_box.regDisplayObjectToProperty(text,"label");
			text.selectable = false
			text.mouseEnabled = false
			textField = text;
			_box.hAlign = LayoutType.MIDDLE;
			return _box;
		}
		
		override protected function doData():void{
			if(_data is String){
				_data = {label:_data}
			}
			box.data = _data;
		}
	}
}