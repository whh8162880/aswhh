package asgl.files.media {
	import asgl.events.FileEvent;
	import asgl.files.AbstractFile;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class WAVReader extends AbstractFile {
		private var _bytes:ByteArray;
		private var _unitSampleLength:int;
		private var _totalSeconds:Number;
		private var _bits:uint;
		private var _channels:uint;
		private var _sampleRate:uint;
		public function WAVReader(bytes:ByteArray=null):void {
			if (bytes == null) {
				clear();
			} else {
				read(bytes);
			}
		}
		public function get bits():uint {
			return _bits;
		}
		public function get channels():uint {
			return _channels;
		}
		public function get sampleRate():uint {
			return _sampleRate;
		}
		public function get totalSeconds():Number {
			return _totalSeconds;
		}
		public override function clear():void {
			super.clear();
			_bits = 0;
			_channels = 0;
			_sampleRate = 0;
			_totalSeconds = 0;
			_bytes = null;
		}
		public function extract(target:ByteArray, length:Number, startPosition:Number=0):void {
			if (!_isCorrectFormat || target == null) return;
			target.writeBytes(_bytes, startPosition*_unitSampleLength, _unitSampleLength*length);
		}
		public function read(bytes:ByteArray):void {
			clear();
			try {
				bytes.endian = Endian.LITTLE_ENDIAN;
				bytes.position = 0;
				
				bytes.readUTFBytes(4);//RIFF
				bytes.readUnsignedInt();//length
				bytes.readUTFBytes(4);//WAVE
				
				bytes.readUTFBytes(4)//fmt 
				var size:uint = bytes.readUnsignedInt();//normal is 16
				var formatTag:uint = bytes.readUnsignedShort();
				_channels = bytes.readUnsignedShort();//1 or 2
				_sampleRate = bytes.readUnsignedInt();
				var avgBytesPerSec:uint = bytes.readUnsignedInt();
				var blockAlign:uint = bytes.readUnsignedShort();
				_bits = bytes.readUnsignedShort();
				bytes.position += size-16;
				
				var tag:String = bytes.readUTFBytes(4);
				if (tag == 'fact') {
					size = bytes.readUnsignedInt();
					bytes.position += size;
				} else {
					bytes.position -= 4;
				}
				
				bytes.readUTFBytes(4);
				size = bytes.readUnsignedInt();
				_totalSeconds = size/avgBytesPerSec;
				_bytes = new ByteArray();
				_bytes.writeBytes(bytes, bytes.position, size);
				
				_unitSampleLength = _bits*_channels/8;
				
				_isCorrectFormat = true;
				this.dispatchEvent(new FileEvent(FileEvent.COMPLETE));
			} catch (e:Error) {
				clear();
				this.dispatchEvent(new FileEvent(FileEvent.ERROR, e));
			}
		}
	}
}