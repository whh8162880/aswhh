package com.utils
{
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;

	public class ColorUtils
	{
		public function ColorUtils()
		{
		}
		
		/**
		 *  执行一个颜色的亮度的调节. 
		 *
		 *  <p>这个RGB颜色的每个值都必须在0-255之间.</p>
		 *
		 *  @param rgb 原始的RGB颜色.
		 *
		 *  @param brite 增加每个颜色的值.
		 *  这个参数的范围必须是-255至255之间.
		 *  当值为255时为白色，-255时为黑色.
		 *  如果这个值为0，则返回原值.
		 *  @return 新的 RGB 颜色.
		 */
		public static function adjustBrightness(rgb:uint, brite:Number):uint
		{
			var r:Number = Math.max(Math.min(((rgb >> 16) & 0xFF) + brite, 255), 0);
			var g:Number = Math.max(Math.min(((rgb >> 8) & 0xFF) + brite, 255), 0);
			var b:Number = Math.max(Math.min((rgb & 0xFF) + brite, 255), 0);
			
			return (r << 16) | (g << 8) | b;
		} 
		
		public static function blackFilter(target:DisplayObject,flag:Boolean):void{
			if(flag){
				target.filters = [new ColorMatrixFilter([0.3086, 0.6094, 0.0820, 0, 0, 0.3086, 0.6094, 0.0820, 0,
					0, 0.3086, 0.6094, 0.0820, 0, 0, 0, 0, 0, 1, 0])];
			}else{
				target.filters = null;
			}
		}
	}
}