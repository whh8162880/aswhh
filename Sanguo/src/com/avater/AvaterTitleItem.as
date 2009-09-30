package com.avater
{
	import com.display.Box;
	import com.display.LayoutType;
	import com.display.utils.ObjectUtils;
	
	import flash.display.DisplayObjectContainer;

	public class AvaterTitleItem extends Box
	{
		public function AvaterTitleItem(_skin:DisplayObjectContainer = null,layoutType:String =  LayoutType.HORIZONTAL,directionFlag:Boolean = false)
		{
			this._vAlign = LayoutType.MIDDLE;
			this._hAlign = LayoutType.CENTER;
			super(LayoutType.HORIZONTAL,directionFlag);
		}
		
		override protected function doData():void{
			var o:Object = ObjectUtils.getObjectPropertys(this._data);
			for (var s:String in o){
				setValue(s,o[s]);
			}
		}
		
	}
}