package com.display.utils
{
	import flash.display.DisplayObjectContainer;
	
	public class DisplayObjectUtils
	{
		public function DisplayObjectUtils()
		{
		}
		
		public static function clear(item:DisplayObjectContainer):void{
			if(!item){
				return;
			}
			while(item.numChildren){
				item.removeChildAt(0);
			}
		}

	}
}