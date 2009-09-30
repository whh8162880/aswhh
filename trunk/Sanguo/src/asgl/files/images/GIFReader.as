package asgl.files.images {
	import asgl.events.FileEvent;
	import asgl.files.AbstractFile;
	
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	/**
	 * modify form gifplayer of bytearray.org.
	 */
	public class GIFReader extends AbstractFile {
		private static const MAX_STACK_SIZE:int = 4096;
		private var _framesList:Array;
		private var _pixelsList:Array;
		private var _pixelStackList:Array;
		private var _prefixList:Array;
		private var _suffixList:Array;
		private var _bitmap:BitmapData;
		private var _image:BitmapData;
		private var _lastImage:BitmapData;
		private var _transparency:Boolean;
		private var _block:ByteArray;
		private var _bytes:ByteArray;
		private var _blockSize:int;
		private var _delay:int;
		private var _dispose:int;
		private var _lastDispose:int;
		private var _totalFrames:int;
		private var _lastRect:Rectangle;
		private var _lastBgColor:uint;
		public function GIFReader(bytes:ByteArray=null):void {
			if (bytes == null) {
				clear();
			} else {
				read(bytes);
			}
		}
		public function get totalFrames():int {
			return _totalFrames;
		}
		public override function clear():void {
			super.clear();
			_framesList = [];
			_pixelsList = null;
			_pixelStackList = null;
			_prefixList = null;
			_suffixList = null;
			_bitmap = null;
			_lastImage = null;
			_transparency = false;
			_block = new ByteArray();
			_bytes = null;
			_blockSize = 0;
			_delay = 0;
			_dispose = 0;
			_lastDispose = 0;
			_totalFrames = 0;
			_lastRect = null;
			_lastBgColor = 0;
		}
		public function getDelayAt(index:int):int {
			index--;
			if (index<0) {
				index = 0;
			} else if (index>_totalFrames-1) {
				index = _totalFrames-1;
			}
			return _framesList[index][1];
		}
		public function getFrameAt(index:int):BitmapData {
			index--;
			if (index<0) {
				index = 0;
			} else if (index>_totalFrames-1) {
				index = _totalFrames-1;
			}
			return _framesList[index][0];
		}
		public function read(bytes:ByteArray):void {
			clear();
			try {
				bytes.endian = Endian.LITTLE_ENDIAN;
				bytes.position = 6;
				_bytes = bytes;
				var width:int = bytes.readShort();
				var height:int = bytes.readShort();
				var pack:int = bytes.readUnsignedByte();
				var gctSize:int = 2<<(pack&7);
				var bgIndex:int = bytes.readUnsignedByte();
				var pixelAspect:int = bytes.readUnsignedByte();
				var gct:Array = _readColorTable(gctSize);
				var bgColor:uint = gct[bgIndex];
				var act:Array;
				var lct:Array;
				var transIndex:int = 0;
				var interlace:Boolean;
				while (true) {
					var code:int = bytes.readUnsignedByte();
					if (code == 0x2C) {
						var x:int = bytes.readUnsignedByte()|bytes.readUnsignedByte()<<8;
						var y:int = bytes.readUnsignedByte()|bytes.readUnsignedByte()<<8;
						var w:int = bytes.readUnsignedByte()|bytes.readUnsignedByte()<<8;
						var h:int = bytes.readUnsignedByte()|bytes.readUnsignedByte()<<8;
						pack = bytes.readUnsignedByte();
						interlace = (pack&0x40) != 0;
						var lctSize:int = 2<<(pack&7);
						if ((pack&0x80) == 0) {
							act = gct;
							if (bgIndex == transIndex) bgColor = 0;
						} else {
							lct = _readColorTable(lctSize);
							act = lct;
						}
						var save:int = 0;
						if (_transparency) {
							save = act[transIndex];
							act[transIndex] = 0;
						}
						var NullCode:int = -1;
						var npix:int = w*h;
						var available:int;
						var clearValue:int;
						var code_mask:int;
						var code_size:int;
						var end_of_information:int;
						var in_code:int;
						var old_code:int;
						var bits:int;
						var count:int;
						var datum:int;
						var data_size:int;
						var first:int;
						var top:int;
						var bi:int;
						var pi:int;
						if (_pixelsList == null || _pixelsList.length<npix) _pixelsList = new Array(npix);
						if (_prefixList == null) _prefixList = new Array(MAX_STACK_SIZE);
						if (_suffixList == null) _suffixList = new Array(MAX_STACK_SIZE);
						if (_pixelStackList == null) _pixelStackList = new Array(MAX_STACK_SIZE+1);
						data_size = bytes.readUnsignedByte();
						clearValue = 1<<data_size;
						end_of_information = clearValue+1;
						available = clearValue+2;
						old_code = NullCode;
						code_size = data_size+1;
						code_mask = (1<<code_size)-1;
						for (code = 0; code<clearValue; code++) {
							_prefixList[int(code)] = 0;
							_suffixList[int(code)] = code;
						}
						datum = bits = count = first = top = pi = bi = 0;
						for (var i:int = 0; i<npix;) {
							if (top == 0) {
								if (bits<code_size) {
									if (count == 0) {
										count = _readBlock();
										if (count <= 0) break;
										bi = 0;
									}
									datum += (int((_block[int(bi)]))&0xFF)<<bits;
									bits += 8;
									bi++;
									count--;
									continue;
								}
								code = datum & code_mask;
								datum >>= code_size;
								bits -= code_size;
								if ((code > available) || (code == end_of_information)) break;
								if (code == clearValue) {
									code_size = data_size + 1;
									code_mask = (1 << code_size) - 1;
									available = clearValue+2;
									old_code = NullCode;
									continue;
								}
								if (old_code == NullCode) {
									_pixelStackList[int(top++)] = _suffixList[int(code)];
									old_code = code;
									first = code;
									continue;
								}
								in_code = code;
								if (code == available) {
									_pixelStackList[int(top++)] = first;
									code = old_code;
								}
								while (code>clearValue) {
									_pixelStackList[int(top++)] = _suffixList[int(code)];
									code = _prefixList[int(code)];
								}
								first = (_suffixList[int(code)]) & 0xFF;
								if (available >= MAX_STACK_SIZE) break;
								_pixelStackList[int(top++)] = first;
								_prefixList[int(available)] = old_code;
								_suffixList[int(available)] = first;
								available++;
								if (((available&code_mask) == 0)&&(available<MAX_STACK_SIZE)) {
									code_size++;
									code_mask += available;
								}
								old_code = in_code;
							}
							top--;
							_pixelsList[int(pi++)] = _pixelStackList[int(top)];
							i++;
						}
						for (i = pi; i < npix; i++) {
							_pixelsList[int(i)] = 0;
						}
						_skip();
						_totalFrames++;
						_bitmap = new BitmapData(width, height);
						_image = _bitmap;
						var dest:Array = _getPixels(_bitmap);
						if (_lastDispose>0) {
							if (_lastDispose == 3) {
								var n:int = _totalFrames-2;
								_lastImage = n>0 ? _framesList[n-1][0] : null;
							}
							if (_lastImage != null) {
								var prev:Array = _getPixels(_lastImage);
								dest = prev.slice();
								if (_lastDispose == 2) {
									var c:Number;
									c = _transparency ? 0x00000000 : _lastBgColor;
									_image.fillRect(_lastRect, c);
								}
							}
						}
						var pass:int = 1;
						var inc:int = 8;
						var iline:int = 0;
						for (i = 0; i < h; i++) {
							var line:int = i;
							if (interlace) {
								if (iline>=h) {
									pass++;
									switch (pass) {
										case 2 :
											iline = 4;
											break;
										case 3 :
											iline = 2;
											inc = 4;
											break;
										case 4 :
											iline = 1;
											inc = 2;
											break;
									}
								}
								line = iline;
								iline += inc;
							}
							line += y;
							if (line<height) {
								var k:int = line*width;
								var dx:int = k+x;
								var dlim:int = dx+w;
								if (k+width<dlim) dlim = k+width;
								var sx:int = i*w;
								while (dx<dlim) {
									var index:int = _pixelsList[sx++]&0xFF;
									var tmp:int = act[index];
									if (tmp != 0) dest[dx] = tmp;
									dx++;
								}
							}
						}
						count = 0;
						var lngWidth:int = _image.width;
						var lngHeight:int = _image.height;
						for (var th:int = 0; th < lngHeight; th++) {
							for (var tw:int = 0; tw < lngWidth; tw++) {
								var color:int = dest[int(count++)];
								_bitmap.setPixel32(tw,th, color);
							}
						}
						_framesList.push([_bitmap, _delay]);
						if (_transparency) act[transIndex] = save;
						_lastDispose = _dispose;
						_lastRect = new Rectangle(x, y, w, h);
						_lastImage = _image;
						_lastBgColor = bgColor;
						lct = null;
					} else if (code == 0x21) {
						code = bytes.readUnsignedByte();
						if (code == 0xF9) {
							bytes.readUnsignedByte();
							pack = bytes.readUnsignedByte();
							_dispose = (pack&0x1C)>>2;
							if (_dispose == 0) _dispose = 1;
							_transparency = (pack&1) != 0;
							_delay = (bytes.readUnsignedByte()|bytes.readUnsignedByte()<<8)*10;
							transIndex = bytes.readUnsignedByte();
							bytes.readUnsignedByte();
						} else if (code == 0xFF) {
							_readBlock();
							_skip();
						} else {
							_skip();
						}
					} else if (code != 0x00) {
						break;
					}
				}
				_isCorrectFormat = true;
				this.dispatchEvent(new FileEvent(FileEvent.COMPLETE));
			} catch (e:Error) {
				clear();
				this.dispatchEvent(new FileEvent(FileEvent.ERROR, e));
			}
		}
		private function _getPixels(bitmap:BitmapData):Array {
			var pixels:Array = new Array(4*_image.width*_image.height);
			var count:int = 0;
			var lngWidth:int = _image.width;
			var lngHeight:int = _image.height;
			for (var th:int = 0; th < lngHeight; th++) {
				for (var tw:int = 0; tw < lngWidth; tw++) {
					var color:uint = bitmap.getPixel(th, tw);
					pixels[count++] = (color&0xFF0000)>>16;
					pixels[count++] = (color&0x00FF00)>>8;
					pixels[count++] = (color&0x0000FF);
				}
			}
			return pixels;
		}
		private function _readBlock():int {
			_blockSize = _bytes.readUnsignedByte();
			var n:int = 0;
			if (_blockSize>0) {
				var count:int = 0;
				while (n<_blockSize) {
					_bytes.readBytes(_block, n, _blockSize-n);
					if (_blockSize-n == -1) break;
					n += _blockSize-n;
				}
			}
			return n;
		}
		private function _readColorTable(ncolors:int):Array {
			var tab:Array = [];
			var bytes:ByteArray = new ByteArray;
			_bytes.readBytes(bytes, 0, 3*ncolors);
			var i:int = 0;
			var j:int = 0;
			while (i<ncolors) {
				var r:int = bytes[j++]&0xFF;
				var g:int = bytes[j++]&0xFF;
				tab[i++] = 0xFF000000|r<<16|g<<8|(bytes[j++]&0xFF);
			}
			return tab;
		}
		private function _skip():void {
			do {
				_readBlock();
			} while (_blockSize>0);
		}
		
		public function getFramesList():Array{
			return _framesList;
		}
	}
}