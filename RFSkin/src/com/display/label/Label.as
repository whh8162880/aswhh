package com.display.label
{
	import com.display.Box;
	import com.display.Container;
	import com.display.LayoutType;
	import com.display.button.ButtonBase;
	import com.display.text.Text;
	
	import flash.display.DisplayObjectContainer;

	public class Label extends ButtonBase
	{
		protected var box:Box
		public function Label(skin:Object=null, type:String=LayoutType.HORIZONTAL, directionFlag:Boolean=false)
		{
			if(skin == null){
				skin = initSkin()
			}
			super(skin, type, directionFlag);
		}
		
		override protected function initSkin():DisplayObjectContainer{
			box = new Box();
			var text:Text = new Text();
			text.setTextColor(0xFFFFFF,0);
			box.addChild(text);
			box.regDisplayObjectToProperty(text,"label");
			text.selectable = false
			return box;
		}
		
		override protected function doData():void{
			if(_data is String){
				_data = {label:_data}
			}
			box.data = _data;
		}
		
	}
}