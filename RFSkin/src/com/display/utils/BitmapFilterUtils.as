package com.display.utils
{
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	
	public class BitmapFilterUtils
	{
		public function BitmapFilterUtils()
		{
			
		}
		
		private static var _bitmapFilter:Array
		public static function getBitmapFilter():Array{
			if(!_bitmapFilter){
				_bitmapFilter = getRandomBitmapFilter();
			}
			return _bitmapFilter;
		}
		
		public static function getRandomBitmapFilter():Array {
            var color:uint = Math.random()*0xFFFFFF;
            var alpha:Number = 0.8;
            var blurX:Number = 5;
            var blurY:Number = 5;
            var strength:Number = 2;
            var inner:Boolean = false;
            var knockout:Boolean = false;
            var quality:Number = BitmapFilterQuality.HIGH;

            return [new GlowFilter(color,
                                  alpha,
                                  blurX,
                                  blurY,
                                  strength,
                                  quality,
                                  inner,
                                  knockout)];
        }

	}
}