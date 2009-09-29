package asgl.math {
	import asgl.data.info.PixelInfo;
	
	public class Color {
		/**
		 * @param c1 is foreColor.
		 * @param c2 is backColor.
		 */
		public static function colorBlend(c1:uint, c2:uint):uint {
			//c2 = 0xFFFF0000;
			var a1:int = c1>>24&0xFF;
			if (a1 == 255) {
				return c1;
			} else {
				var a2:int = c2>>24&0xFF;
				var k:Number;
				if (a2 == 255) {
					k = 255-a1;
					return 0xFF000000|(((c2>>16&0xFF)*k+(c1>>16&0xFF)*a1)/255)<<16|(((c2>>8&0xFF)*k+(c1>>8&0xFF)*a1)/255)<<8|(((c2&0xFF)*k+(c1&0xFF)*a1)/255);
				} else {
					var k1:Number = a1/255;
					var k2:Number = a2/255;
					k = (1-k1)*k2;
					var a:Number = 1-(1-k1)*(1-k2);
					return (a*255)<<24|(((c1>>16&0xFF)*k1+(c2>>16&0xFF)*k)/a)<<16|(((c1>>8&0xFF)*k1+(c2>>8&0xFF)*k)/a)<<8|(((c1&0xFF)*k1+(c2&0xFF)*k)/a);
				}
			}
		}
		public static function colorBlendWithLightStrength(c1:uint, c2:uint, k:Number):uint {
			var k1:Number = k*(c1>>24&0xFF)/255;
			var k2:Number = (c2>>24&0xFF)/255;
			var k3:Number = (1-k1)*k2;
			return ((1-(1-k1)*(1-k2))*255)<<24|(((c1>>16&0xFF)*k1+(c2>>16&0xFF)*k3))<<16|(((c1>>8&0xFF)*k1+(c2>>8&0xFF)*k3))<<8|(((c1&0xFF)*k1+(c2&0xFF)*k3));
		}
		public static function colorBlendWithPixelAlphaColor(pixelInfo:PixelInfo):uint {
			var list:Array = pixelInfo.alphaColorList;
			var length:int = list.length;
			var color:uint = list[length-2];
			for (var i:int = length-4; i>=0; i-=2) {
				color = colorBlend(list[i], color);
			}
			return color;
		}
		public static function colorBlendWithPixelAlphaColorAndOpaqueColor(pixelInfo:PixelInfo):uint {
			var list:Array = pixelInfo.alphaColorList;
			var length:int = list.length;
			if (length == 2) {
				return colorBlend(list[0], pixelInfo.opaqueColor);
			} else {
				var color:uint = list[length-2];
				for (var i:int = length-4; i>=0; i-=2) {
					color = colorBlend(list[i], color);
				}
				return colorBlend(color, pixelInfo.opaqueColor);
			}
		}
		public static function colorBrightness(c:uint, brightness:Number):uint {
			if (brightness == 0.5) {
				return c;
			} else {
				var red:int = c>>16&0xFF;
				var green:int = c>>8&0xFF;
				var blue:int = c&0xFF;
				
				var k:Number;
				if (brightness>0.5) {
					k = brightness*2-1;
					red += (255-red)*k;
					green += (255-green)*k;
					blue += (255-blue)*k;
				} else {
					k = brightness*2;
					red *= k;
					green *= k;
					blue *= k;
				}
				return (c>>24&0xFF)<<24|red<<16|green<<8|blue;
			}
		}
		public static function pixelBlend(c1:uint, c2:uint, k1:Number):uint {
			var k2:Number = 1-k1;
			return ((c1>>24&0xFF)*k1+(c2>>24&0xFF)*k2)<<24|((c1>>16&0xFF)*k1+(c2>>16&0xFF)*k2)<<16|((c1>>8&0xFF)*k1+(c2>>8&0xFF)*k2)<<8|((c1&0xFF)*k1+(c2&0xFF)*k2);
		}
		public static function randomColor(randomAlpha:Boolean=true):uint {
			return (randomAlpha ? Math.round(Math.random()*255) : 255)<<24|Math.round(Math.random()*255)<<16|Math.round(Math.random()*255)<<8|Math.round(Math.random()*255);
		}
	}
}