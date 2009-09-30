package asgl.files {
	import flash.utils.ByteArray;
	
	public class CRC32 {
		private static var _crcTable:Array = _createCrcTable();
		public static function getValue(bytes:ByteArray, offset:uint=0, length:uint=0):uint {
			var len:uint = bytes.length;
			if (offset>len) offset = len;
			if (length == 0 || length>len) length = len;
			if (length+offset>len) length = len-offset;
			var crc:uint = 0;
			var c:uint = ~crc;
			while(--length>=0) {
				c = _crcTable[(c^bytes[offset++])&0xFF]^(c>>>8);
			}
			crc = ~c;
			return crc&0xFFFFFFFF;
		}
		private static function _createCrcTable():Array {
			var table:Array = [];
			for (var i:int = 0; i<256; i++) {
				var c:uint = i;
				for (var k:int = 8; --k>=0; ) {
					if((c&1) != 0) c = 0xEDB88320^(c>>>1);
					else c = c >>> 1;
				}
				table[i] = c;
			}
			return table;
		}
	}
}
