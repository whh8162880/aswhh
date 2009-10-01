package asgl.files {
	import flash.utils.ByteArray;
	
	public class Adler32 {
		private static const BASE:uint = 65521;
		public static function getValue(bytes:ByteArray, offset:uint=0, length:uint=0):uint {
			var len:uint = bytes.length;
			if (offset>len) offset = len;
			if (length == 0) length = len;
			length += offset;
			if (length>len) length = len;
			var s1:uint = 1;//&0xFFFF
			var s2:uint = 0;//>>16&0xFFFF
			for (var i:uint = offset; i<length; i++) {
				s1 = (s1+bytes[i])%BASE;
				s2 = (s1+s2)%BASE;
			}
			return (s2<<16)+s1;
		}
	}
}