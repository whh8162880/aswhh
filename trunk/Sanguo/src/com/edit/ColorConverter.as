package com.edit
{
	import flash.geom.ColorTransform;
	/**
	 * ColorConverter 提供对RGP、CMYK、HSB等颜色格式的转换
	 * @author Sean
	 * 
	 */	
	public class ColorConverter extends ColorTransform
	{
		public function ColorConverter(redMultiplier:Number=1.0, greenMultiplier:Number=1.0, blueMultiplier:Number=1.0, alphaMultiplier:Number=1.0, redOffset:Number=0.0, greenOffset:Number=0.0, blueOffset:Number=0.0, alphaOffset:Number=0.0)
		{
			super(redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier, redOffset, greenOffset, blueOffset, alphaOffset);
		}
		
		/**
		 * 设置CMY格式颜色
		 * @param cmy
		 * @param k 
		 * 
		 */		
		public function setCMYK(cmy:CMY,k:uint = 0):void{
			k = 1-k/100;
			this.setColor((255-cmy.c*2.55)*k,(255-cmy.m*2.55)*k,(255-cmy.y*2.55)*k);
		}
		
		/**
		 * 获取CMY格式颜色
		 * @return 
		 * 
		 */		
		public function getCMY():CMY{
			var rgb:uint = this.color;
			var _r:Number = (rgb >> 16) & 0xFF;
			var _g:Number = (rgb >> 8) & 0xFF;
			var _b:Number = (rgb) & 0xFF;
			
			var ratio:Number = 100/255;
			
			var cmy:CMY = new CMY();
			cmy.c = Math.round(100-_r*ratio);
			cmy.m = Math.round(100-_g*ratio);
			cmy.y = Math.round(100-_b*ratio);
			return cmy;
		}
		
		/**
		 * 设置HSB格式颜色
		 * @param hsb
		 * 
		 */		
		public function setHSB(hsb:HSB):void{
			var _r:Number = 0;
			var _g:Number = 0;
			var _b:Number = 0;
			
			hsb.s *= 2.55;
			hsb.b *= 2.55;
			if (!hsb.h && !hsb.s) {
				_r = _g = _b = hsb.b;
			} else {
				var diff:Number = (hsb.b*hsb.s)/255;
				var low:Number = hsb.b-diff;
				if (hsb.h>300 || hsb.h<=60) {
					_r = hsb.b;
					if(hsb.h > 300){
						_g = Math.round(low);
						hsb.h = (hsb.h-360)/60;
						_b = -Math.round(hsb.h*diff - low);
					}else{
						_b = Math.round(low);
						hsb.h = hsb.h/60;
						_g = Math.round(hsb.h*diff + low);
					}
				} else if (hsb.h>60 && hsb.h<180) {
					_g = hsb.b;
					if (hsb.h<120) {
						_b = Math.round(low);
						hsb.h = (hsb.h/60-2)*diff;
						_r = Math.round(low-hsb.h);
					} else {
						_r = Math.round(low);
						hsb.h = (hsb.h/60-2)*diff;
						_b = Math.round(low+hsb.h);
					}
				} else {
					_b = hsb.b;
					if (hsb.h<240) {
						_r = Math.round(low);
						hsb.h = (hsb.h/60-4)*diff;
						_g = Math.round(low-hsb.h);
					} else {
						_g = Math.round(low);
						hsb.h = (hsb.h/60-4)*diff;
						_r = Math.round(low+hsb.h);
					}
				}
			}
			
			setColor(_r,_g,_b);
		}
		/**
		 * 获取HSB格式颜色
		 * @return 
		 * 
		 */		
		public function getHSB():HSB{
			var rgb:uint = this.color;
			var _r:Number = (rgb >> 16) & 0xFF;
			var _g:Number = (rgb >> 8) & 0xFF;
			var _b:Number = (rgb) & 0xFF;
			
			var hsb:HSB = new HSB();
			var low:Number = Math.min(_r, Math.min(_g, _b));
			var high:Number = Math.max(_r, Math.max(_g, _b));
			hsb.b = high*100/255;
			var diff:Number = high-low;
			if (diff) {
				hsb.s = Math.round(100*(diff/high));
				if (_r == high) {
					hsb.h = Math.round(((_g-_b)/diff)*60);
				} else if (_g == high) {
					hsb.h = Math.round((2+(_b-_r)/diff)*60);
				} else {
					hsb.h = Math.round((4+(_r-_g)/diff)*60);
				}
				if (hsb.h>360) {
					hsb.h -= 360;
				} else if (hsb.h<0) {
					hsb.h += 360;
				}
			} else {
				hsb.h = hsb.s=0;
			}
			return hsb;
		}
		
		/**
		 * 设置一个随机的颜色
		 * 
		 */		
		public function setRandom():void{
			this.color = getRandom();
		}
		/**
		 * 获得一个随机的颜色
		 * @return 
		 * 
		 */		
		public function getRandom():uint{
			return Math.floor(Math.random()*0xFFFFFF);
		}
		
		/**
		 * 获取一个灰度颜色
		 * @return 
		 * 
		 */		
		public function getGray():uint{
			var rgb:uint = this.color;
			var _r:Number = (rgb >> 16) & 0xFF;
			var _g:Number = (rgb >> 8) & 0xFF;
			var _b:Number = (rgb) & 0xFF;
			
			var gray:Number = Math.round(.3*_r + .59*_g + .11*_b);
			
			return (gray << 16) | (gray << 8) | gray;
		}
		
		/**
		 * 设置颜色
		 * @param r
		 * @param g
		 * @param b
		 * 
		 */		
		private function setColor(r:Number,g:Number,b:Number):void{
			this.color = (r << 16) | (g << 8) | b;
		}
	}
}