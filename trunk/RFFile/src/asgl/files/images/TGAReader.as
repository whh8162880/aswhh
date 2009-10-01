package asgl.files.images {
	import asgl.events.FileEvent;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	public class TGAReader extends AbstractImageReader {
		public static const TYPE_NO_IMAGE:int = 0;
		public static const TYPE_UNCOMPRESSED_COLOR_MAPPED_IMAGE:int = 1;
		public static const TYPE_UNCOMPRESSED_RGB_IMAGE:int = 2;
		public static const TYPE_UNCOMPRESSED_BLACK_AND_WHITE_IMAGE:int = 3;
		public static const TYPE_RUNLENGTH_ENCODED_COLOR_MAPPED_IMAGE:int = 9;
		public static const TYPE_RUNLENGTH_ENCODED_RGB_IMAGE:int = 10;
		public static const TYPE_COMPRESSED_BLACK_AND_WHITE_IMAGE:int = 11;
		public static const TYPE_COMPRESSED_HUFFMAN_DELTA_RUNLENGTH_COLOR_MAPPED_IMAGE:int = 32;
		public static const TYPE_COMPRESSED_HUFFMAN_DELTA_RUNLENGTH_4PASS_QUADTREE_COLOR_MAPPED_IMAGE:int = 33;
		private var _type:int;
		private var _offset:int;
		public function TGAReader(bytes:ByteArray=null):void {
			if (bytes == null) {
				clear();
			} else {
				read(bytes);
			}
		}
		public function get type():int {
			return _type;
		}
		public override function clear():void {
			super.clear();
			_type = -1;
		}
		public override function read(bytes:ByteArray):void {
			clear();
			try {
				if (bytes != null) {
					bytes.position = 0;
					bytes.endian = Endian.LITTLE_ENDIAN;
					_offset = bytes.readByte(); 
					bytes.position = 2;
					_type = bytes.readInt();
					if (_type == TYPE_UNCOMPRESSED_RGB_IMAGE) {
						readType2(bytes);
					} else {
						throw new Error();
					}
				}
				_isCorrectFormat = true;
				this.dispatchEvent(new FileEvent(FileEvent.COMPLETE));
			} catch (e:Error) {
				clear();
				this.dispatchEvent(new FileEvent(FileEvent.ERROR, e));
			}
		}
		private function readType2(bytes:ByteArray):void {
			bytes.position = 12;
			var width:int = bytes.readShort();
			var height:int = bytes.readShort();
			var pixelByte:int = bytes.readByte();
			bytes.position += _offset;
			_image = new BitmapData(width, height, true, 0x00);
			var red:int;
			var green:int;
			var blue:int;
			for (var row:int = height-1; row>=0; row--) {
				for (var column:int = 0; column<width; column++) {
					if (pixelByte == 24) {
						red = bytes.readUnsignedByte();
						blue = bytes.readUnsignedByte();
						green = bytes.readUnsignedByte();
						_image.setPixel32(column, row, (0xFF000000|red<<16|green<<8|blue));
					} else if (pixelByte == 32) {
						var alpha:int = bytes.readUnsignedByte();
						blue = bytes.readUnsignedByte();
						green = bytes.readUnsignedByte();
						red = bytes.readUnsignedByte();
						_image.setPixel32(column, row, (alpha<<24|red<<16|green<<8|blue));
					} else {
						return;
					}
				}
			}
		}
	}
}