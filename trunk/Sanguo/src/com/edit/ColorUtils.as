package com.edit
{
	public class ColorUtils
	{
		
		
		
		
		
		/**  
		 * 颜色转换算法  
		 *   
		 */ 
		private static const value:Number = 240/256
	    public static function RGB2HSL(rgb:int):Array {
	    	var R:Number = Math.round((rgb>>16 & 0xFF)*value);
			var G:Number =  Math.round((rgb>>8 & 0xFF)*value);
			var B:Number =  Math.round((rgb & 0xFF)*value);
			var max:int = 240;
	        var H:Number, S:Number, L:Number, var_Min:Number, var_Max:Number, del_Max:Number, del_R:Number, del_G:Number, del_B:Number;   
	        H = 0;   
	        var_Min = Math.min(R, Math.min(B, G));   
	        var_Max = Math.max(R, Math.max(B, G));
	        del_Max = var_Max - var_Min;   
	        L = (var_Max + var_Min) / 2;   
	        if (del_Max == 0) {   
	            H = 0;   
	            S = 0;   
	  
	        } else {   
	            if (L < max/2) {   
	                S = max * del_Max / (var_Max + var_Min);   
	            } else {   
	                S = max * del_Max / (max*2 - var_Max - var_Min);   
	            }   
	            del_R = ((max * (var_Max - R) / 6) + (max * del_Max / 2))   
	                    / del_Max;   
	            del_G = ((max * (var_Max - G) / 6) + (max * del_Max / 2))   
	                    / del_Max;   
	            del_B = ((max * (var_Max - B) / 6) + (max * del_Max / 2))   
	                    / del_Max;   
	            if (R == var_Max) {   
	                H = del_B - del_G;   
	            } else if (G == var_Max) {   
	                H = max/3 + del_R - del_B;   
	            } else if (B == var_Max) {   
	                H = max/3*2 + del_G - del_R;   
	            }   
	            if (H < 0) {   
	                H += max;   
	            }   
	            if (H >= max) {   
	                H -= max;   
	            }   
	            if (L >= max) {   
	                L = max;   
	            }   
	            if (S >= max) {   
	                S = max;   
	            }   
	        }   
//	        H = H<<16
//	        L = L<<8
	        return [Math.round(H),Math.round(S),Math.round(L)]
	    }   
	  
	    public static function HSL2RGB(H:Number,S:Number,L:Number):int {   
	  		var max:int = 240
	        var R:Number, G:Number, B:Number, var_1:Number, var_2:Number;   
	        if (S == 0) {   
	            R = L;   
	            G = L;   
	            B = L;   
	        } else {   
	            if (L < max/2) {   
	                var_2 = (L * (max + S)) / max;   
	            } else {   
	                var_2 = (L + S) - (S * L) / max;   
	            }   
	  
	            if (var_2 > max-1) {   
	                var_2 = Math.round(var_2);   
	            }   
	  
//	            if (var_2 > max-2) {   
//	                var_2 = max-1;   
//	            }   
	  
	            var_1 = 2 * L - var_2;   
	            R = RGBFromHue(var_1, var_2, H + max/3,max);   
	            G = RGBFromHue(var_1, var_2, H,max);   
	            B = RGBFromHue(var_1, var_2, H - max/3,max);   
	        }   
	        R = R < 0 ? 0 : R;   
	        R = R > max-1 ? max-1 : R;   
	        G = G < 0 ? 0 : G;   
	        G = G > max-1 ? max-1 : G;   
	        B = B < 0 ? 0 : B;   
	        B = B > max-1 ? max-1 : B;
	         
	        R /= value;
	        G /= value;
	        B /= value;
	        return ((Math.round(R)<<16) & 0xFF0000)+((Math.round(G)<<8) & 0xFF00)+(Math.round(B) & 0xFF)  
	    }   
	  
	    public static function RGBFromHue(a:Number, b:Number, h:Number,max:Number):Number {   
	        if (h < 0) {   
	            h += max;   
	        }   
	        if (h >= max) {   
	            h -= max;   
	        }   
	        var temp:Number = max/6;
	        if (h < temp) {   
	            return a + ((b - a) * h) / temp;   
	        }   
	        if (h < temp*2) {   
	            return b;   
	        }   
	  
	        if (h < temp*4) {   
	            return a + ((b - a) * (temp*4 - h)) / temp;   
	        }   
	        return a;   
	    }   
	  
	}  
}