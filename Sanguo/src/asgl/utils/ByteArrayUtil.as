package asgl.utils {
	import asgl.files.CharacterSet;
	
	import flash.utils.ByteArray;

	public class ByteArrayUtil extends ByteArray {
		public static function readLousyCode(value:String):String {
			var source:ByteArray = new ByteArray();
			source.writeUTFBytes(value);
			var temp:ByteArray = new ByteArray();
			var length:int = source.length;
			for (var i:int = 0; i<length; i++) {
				if (source[i] == 194) {
					temp.writeByte(source[i+1]);
					i++;
				} else if (source[i] == 195) {
					temp.writeByte(source[i+1] + 64);
					i++;
			    } else {
					temp.writeByte(source[i]);
			    }
			}
			temp.position = 0;
			return  temp.readMultiByte(temp.bytesAvailable, CharacterSet.GB_2312);
		}
		public static function toByteString(bytes:ByteArray):String {
			var str:String = '            0  1  2  3  4  5  6  7  8  9  a  b  c  d  e  f';
			var index:int = 0;
			var length:int = bytes.length;
			for (var i:int = 0; i<length; i++) {
				var value:int = bytes[i];
				if (i%16 == 0) {
					str += '\n';
					var line:String = i.toString(16);
					var num:int = line.length;
					if (num<8) {
						for (var j:int = 8-num; j>0; j--) {
							str += '0';
						}
					}
					str += line+'h: ';
				}
				str += value<16 ? '0'+value.toString(16) : value.toString(16);
				if ((i+1)%16 != 0) str += ' ';
			}
			return str;
		}
	}
}