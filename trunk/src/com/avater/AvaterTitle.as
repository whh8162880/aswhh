package com.avater
{
	import com.display.Box;
	import com.display.LayoutType;
	import com.display.utils.ObjectUtils;
	
	import flash.display.DisplayObject;

	public class AvaterTitle extends Box
	{
		public function AvaterTitle()
		{
			hAlign = LayoutType.CENTER;
			vAlign = LayoutType.MIDDLE;
			super(LayoutType.VERTICAL,true);
		}
		
		public function regTitle(item:DisplayObject):void{
			addChild(item);
		}
		
	
		
		override protected function doData():void{
			var o:Object = ObjectUtils.getObjectPropertys(_data);
			var arr:Array = getChildrens();
			for each(var item:Object in arr){
				if(item.hasOwnProperty("data")){
					item["data"] = o;
				}
			}
		}
		
	}
}