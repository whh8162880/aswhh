package asgl.files.utils.zip {
	import asgl.events.FileEvent;
	import asgl.files.AbstractFile;
	import asgl.files.CRC32;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class ZIPFile extends AbstractFile {
		public var extra:ByteArray;
		public var dosTime:uint;
		private var _data:ByteArray;
		private var _name:String;
		private var _deflateCompressionLevel:int;
		private var _compressedSize:uint;
		private var _compressionMethod:uint;
		private var _crc:uint;
		private var _uncompressedSize:uint;
		public function ZIPFile():void {
			clear();
		}
		public function get deflateCompressionLevel():int {
			return _deflateCompressionLevel;
		}
		public function get compressedSize():uint {
			return _compressedSize;
		}
		public function get compressionMethod():uint {
			return _compressionMethod;
		}
		public function get crc32():uint {
			return _crc;
		}
		public function get data():ByteArray {
			return _data;
		}
		public function get name():String {
			return _name;
		}
		public function set name(value:String):void {
			var list:Array = value.split('/');
			var length:int = list.length;
			_name = '';
			for (var i:int = 0; i<length; i++) {
				_name += list[i];
			}
		}
		public function get time():Number {
			return new Date(((dosTime>>25)&0x7F)+1980, ((dosTime>>21)&0xF)-1, (dosTime>>16)&0x1F, (dosTime>>11)&0x1F, (dosTime>>5)&0x3F, (dosTime&0x1F)<<1).time;
		}
		public function set time(value:Number):void {
			var date:Date = new Date(value);
			dosTime = (date.fullYear-1980&0x7F)<<25|(date.month+1)<<21|date.date<<16|date.hours<<11|date.minutes<<5|date.seconds>>1;
		}
		public function get uncompressedSize():uint {
			return _uncompressedSize;
		}
		public override function clear():void {
			_data = null;
			_compressionMethod = ZIPCompressionMethod.STORED;
			_deflateCompressionLevel = -1;
			dosTime = 0;
			_compressedSize = 0;
			_uncompressedSize = 0;
			_crc = 0;
			extra = null;
		}
		public function compress():void {
			try {
				if (_compressionMethod != ZIPCompressionMethod.STORED) throw new Error('the data is compressed');
				_crc = CRC32.getValue(_data);
				_data.compress();
				var temp:ByteArray = new ByteArray();
				temp.endian = Endian.LITTLE_ENDIAN;
				temp.writeBytes(_data, 2, _data.length-6);
				_data = temp;
				_compressionMethod = ZIPCompressionMethod.DEFLATED;
				_deflateCompressionLevel = ZIPDeflateCompressionLevel.MAXIMUM;
				_compressedSize = _data.length;
				this.dispatchEvent(new FileEvent(FileEvent.COMPLETE));
			} catch (e:Error) {
				this.dispatchEvent(new FileEvent(FileEvent.ERROR, e));
			}
		}
		public function decompress():void {
			try {
				if (_compressionMethod == ZIPCompressionMethod.STORED) throw new Error('the data is uncompressed');
				_data.uncompress();
				_compressionMethod = ZIPCompressionMethod.STORED;
				_deflateCompressionLevel = -1;
				_uncompressedSize = _data.length;
				_crc = 0;
				this.dispatchEvent(new FileEvent(FileEvent.COMPLETE));
			} catch (e:Error) {
				this.dispatchEvent(new FileEvent(FileEvent.ERROR, e));
			}
		}
		public function setData(data:ByteArray, compressionMethod:uint, level:* = null, sourceSize:* = null, crc32:* = null):void {
			_data = data;
			_compressionMethod = compressionMethod;
			_compressedSize = data.length;
			if (_compressionMethod == ZIPCompressionMethod.STORED) {
				_deflateCompressionLevel = -1;
				_uncompressedSize = data.length;
				_crc = 0;
			} else {
				_uncompressedSize = sourceSize is uint ? sourceSize : 0;
				_crc = crc32 is uint ? crc32 : 0;
				if (_compressionMethod == ZIPCompressionMethod.DEFLATED && level is uint) {
					_deflateCompressionLevel = level;
				} else {
					_deflateCompressionLevel = -1;
				}
			}
		}
	}
}