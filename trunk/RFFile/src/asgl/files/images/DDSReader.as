package asgl.files.images {
	import asgl.events.FileEvent;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	public class DDSReader extends AbstractImageReader {
		public static const DXT1:String = 'DXT1';
		public static const DXT2:String = 'DXT2';
		public static const DXT3:String = 'DXT3';
		public static const DXT4:String = 'DXT4';
		public static const DXT5:String = 'DXT5';
		public var alphaTestEnabled:Boolean = true;
		private var _height:int;
		private var _width:int;
		private var _type:String;
		public function DDSReader(bytes:ByteArray=null, alphaTest:Boolean=true):void {
			alphaTestEnabled = alphaTest;
			if (bytes == null) {
				clear();
			} else {
				read(bytes);
			}
		}
		public function get type():String {
			return _type;
		}
		public override function clear():void {
			super.clear();
			_type = null;
		}
		public override function read(bytes:ByteArray):void {
			clear();
			try {
				bytes.endian = Endian.LITTLE_ENDIAN;
				bytes.position = 12;
				_height = bytes.readUnsignedInt();
				_width = bytes.readUnsignedInt();
				bytes.position = 84;
				_type = bytes.readUTFBytes(4);
				_image = new BitmapData(_width, _height, true, 0x00);
				bytes.position = 128;
				if (_type == DXT1) {
					_readDXT1Image(bytes, alphaTestEnabled);
				} else if (_type == DXT3) {
					_readDXT3Image(bytes, alphaTestEnabled);
				} else if (_type == DXT2 || _type == DXT4 || _type == DXT5) {
					_readDXT5Image(bytes, alphaTestEnabled);
				} else {
					throw new Error();
				}
				_isCorrectFormat = true;
				this.dispatchEvent(new FileEvent(FileEvent.COMPLETE));
			} catch (e:Error) {
				clear();
				this.dispatchEvent(new FileEvent(FileEvent.ERROR, e));
			}
		}
		private function _readDXT1Image(bytes:ByteArray, alphaTest:Boolean):void {
			for (var h:int = 0; h<_height; h+=4) {
				for (var w:int = 0; w<_width; w+=4) {
					var c0:uint = bytes.readUnsignedShort();
					var c1:uint = bytes.readUnsignedShort();
					
					var indexList:Array = [bytes.readUnsignedByte(), bytes.readUnsignedByte(), bytes.readUnsignedByte(), bytes.readUnsignedByte()];
					
					var r0:int = (c0&0xF800)>>8;
					var g0:int = (c0&0x7E0)>>3;
					var b0:int = (c0&0x1F)<<3;
					
					var r1:int = (c1&0xF800)>>8;
					var g1:int = (c1&0x7E0)>>3;
					var b1:int = (c1&0x1F)<<3;
					
					var r2:int = (r0*2+r1+1)/3;
					var g2:int = (g0*2+g1+1)/3;
					var b2:int = (b0*2+b1+1)/3;
					
					var r3:int = (r0+r1*2+1)/3;
					var g3:int = (g0+g1*2+1)/3;
					var b3:int = (b0+b1*2+1)/3;
					
					var redList:Array = [r0, r1, r2, r3];
					var greenList:Array = [g0, g1, g2, g3];
					var blueList:Array = [b0, b1, b2, b3];
					
					for (var i:int = 0; i<4; i++) {
						var index:int = indexList[i];
						for (var j:int = 0; j<4; j++) {
							var k:int = (index&(0x03<<j*2))>>(j*2);
							_image.setPixel32(w+j, h+i, 0xFF000000|redList[k]<<16|greenList[k]<<8|blueList[k]);
						}
					}
				}
			}
		}
		private function _readDXT3Image(bytes:ByteArray, alphaTest:Boolean):void {
			for (var h:int = 0; h<_height; h+=4) {
				for (var w:int = 0; w<_width; w+=4) {
					var alphaList:Array = [];
					var a:int;
					if (alphaTest) {
						for (a = 0; a<4; a++) {
							var alpha:int = bytes.readUnsignedShort();
							alphaList[a*4] = ((alpha>>4)&0xF)*17;
							alphaList[a*4+1] = ((alpha)&0xF)*17;
							alphaList[a*4+2] = ((alpha>>12)&0xF)*17;
							alphaList[a*4+3] = ((alpha>>8)&0xF)*17;
						}
					} else {
						for (a = 0; a<16; a++) {
							alphaList[a] = 255;
						}
					}
					var c0:uint = bytes.readUnsignedShort();
					var c1:uint = bytes.readUnsignedShort();
					
					var indexList:Array = [bytes.readUnsignedByte(), bytes.readUnsignedByte(), bytes.readUnsignedByte(), bytes.readUnsignedByte()];
					
					var r0:int = (c0&0xF800)>>8;
					var g0:int = (c0&0x7E0)>>3;
					var b0:int = (c0&0x1F)<<3;
					
					var r1:int = (c1&0xF800)>>8;
					var g1:int = (c1&0x7E0)>>3;
					var b1:int = (c1&0x1F)<<3;
					
					var r2:int = (r0*2+r1+1)/3;
					var g2:int = (g0*2+g1+1)/3;
					var b2:int = (b0*2+b1+1)/3;
					
					var r3:int = (r0+r1*2+1)/3;
					var g3:int = (g0+g1*2+1)/3;
					var b3:int = (b0+b1*2+1)/3;
					
					var redList:Array = [r0, r1, r2, r3];
					var greenList:Array = [g0, g1, g2, g3];
					var blueList:Array = [b0, b1, b2, b3];
					
					for (var i:int = 0; i<4; i++) {
						var index:int = indexList[i];
						for (var j:int = 0; j<4; j++) {
							var k:int = (index&(0x03<<j*2))>>(j*2);
							_image.setPixel32(w+j, h+i, alphaList[i*4+j]<<24|redList[k]<<16|greenList[k]<<8|blueList[k]);
						}
					}
				}
			}
		}
		private function _readDXT5Image(bytes:ByteArray, alphaTest:Boolean):void {
			for (var h:int = 0; h<_height; h+=4) {
				for (var w:int = 0; w<_width; w+=4) {
					bytes.position += 8;
					
					var c0:uint = bytes.readUnsignedShort();
					var c1:uint = bytes.readUnsignedShort();
					
					var indexList:Array = [bytes.readUnsignedByte(), bytes.readUnsignedByte(), bytes.readUnsignedByte(), bytes.readUnsignedByte()];
					
					var r0:int = (c0&0xF800)>>8;
					var g0:int = (c0&0x7E0)>>3;
					var b0:int = (c0&0x1F)<<3;
					
					var r1:int = (c1&0xF800)>>8;
					var g1:int = (c1&0x7E0)>>3;
					var b1:int = (c1&0x1F)<<3;
					
					var r2:int = (r0*2+r1+1)/3;
					var g2:int = (g0*2+g1+1)/3;
					var b2:int = (b0*2+b1+1)/3;
					
					var r3:int = (r0+r1*2+1)/3;
					var g3:int = (g0+g1*2+1)/3;
					var b3:int = (b0+b1*2+1)/3;
					
					var redList:Array = [r0, r1, r2, r3];
					var greenList:Array = [g0, g1, g2, g3];
					var blueList:Array = [b0, b1, b2, b3];
					
					for (var i:int = 0; i<4; i++) {
						var index:int = indexList[i];
						for (var j:int = 0; j<4; j++) {
							var k:int = (index&(0x03<<j*2))>>(j*2);
							_image.setPixel32(w+j, h+i, 0xFF000000|redList[k]<<16|greenList[k]<<8|blueList[k]);
						}
					}
				}
			}
		}
	}
}