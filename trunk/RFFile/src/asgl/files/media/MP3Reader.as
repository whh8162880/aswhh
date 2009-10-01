package asgl.files.media {
	import asgl.events.FileEvent;
	import asgl.files.AbstractFile;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class MP3Reader extends AbstractFile {
		public static const BITRATE_CBR:String = 'cbr';
		public static const BITRATE_VBR:String = 'vbr';
		public static const CHANNEL_STEREO:String = 'stereo';
		public static const CHANNEL_JOINT_STEREO:String = 'jointStereo';
		public static const CHANNEL_DUAL:String = 'dual';
		public static const CHANNEL_SINGLE:String = 'single';
		public static const LAYER_DESCRIPTION_LAYER1:String = 'layer1';
		public static const LAYER_DESCRIPTION_LAYER2:String = 'layer2';
		public static const LAYER_DESCRIPTION_LAYER3:String = 'layer3';
		public static const LAYER_DESCRIPTION_RESERVED:String = 'reserved';
		public static const PROTECTION_CRC:String = 'crc';
		public static const PROTECTION_NONE:String = 'none'; 
		public static const VERSION_MPEG1:String = 'mpeg1';
		public static const VERSION_MPEG2:String = 'mpeg2';
		public static const VERSION_MPEG25:String = 'mpeg25';
		public static const VERSION_RESERVED:String = 'reserved';
		private var _hasID3v1Info:Boolean;
		private var _hasID3v2Info:Boolean;
		private var _isCopyright:Boolean;
		private var _isOriginMedia:Boolean;
		private var _isVBR:Boolean;
		private var _id3v1Info:ID3v1Info = new ID3v1Info();
		private var _totalSeconds:Number;
		private var _bitRateType:String;
		private var _channel:String;
		private var _layerDescription:String;
		private var _protection:String;
		private var _version:String;
		private var _bitRate:uint;
		private var _sampleRate:uint;
		public function MP3Reader(bytes:ByteArray=null):void {
			if (bytes == null) {
				clear();
			} else {
				read(bytes);
			}
		}
		public function get bitRate():uint {
			return _bitRate;
		}
		public function get bitRateType():String {
			return _bitRateType;
		}
		public function get hasID3v1Info():Boolean {
			return _hasID3v1Info;
		}
		public function get hasID3v2Info():Boolean {
			return _hasID3v2Info;
		}
		public function get id3v1Info():ID3v1Info {
			return _id3v1Info;
		}
		public function get isCopyright():Boolean {
			return _isCopyright;
		}
		public function get isOriginMedia():Boolean {
			return _isOriginMedia;
		}
		public function get isVBR():Boolean {
			return _isVBR;
		}
		public function get sampleRate():uint {
			return _sampleRate;
		}
		public function get channel():String {
			return _channel;
		}
		public function get layerDescription():String {
			return _layerDescription;
		}
		public function get protection():String {
			return _protection;
		}
		public function get totalSeconds():Number {
			return _totalSeconds;
		}
		public function get version():String {
			return _version;
		}
		public override function clear():void {
			super.clear();
			_id3v1Info.clear();
			_hasID3v1Info = false;
			_hasID3v2Info = false;
			_bitRate = 0;
			_sampleRate = 0;
			_totalSeconds = 0;
			_bitRateType = null;
			_channel = null;
			_layerDescription = null;
			_protection = null;
			_version = null;
			_isVBR = false;
			_isCopyright = false;
			_isOriginMedia = false;
		}
		public function read(bytes:ByteArray):void {
			clear();
			try {
				bytes.endian = Endian.BIG_ENDIAN;
				bytes.position = 0;
				
				if (bytes.readUTFBytes(3) == 'ID3') {
					_hasID3v2Info = true;
					bytes.position = 10+((bytes[6]&0x7F)<<21|(bytes[7]&0x7F)<<14|(bytes[8]&0x7F)<<7|(bytes[9]&0x7F));
				} else {
					bytes.position = 0;
				}
				var length:int = bytes.bytesAvailable;
				var head:uint = bytes.readUnsignedShort();
				if ((head>>5) == 0x7FF) {
					var version:int = head>>3&0x3;
					if (version == 0) {
						_version = VERSION_MPEG25;
					} else if (version == 1) {
						_version = VERSION_RESERVED;
					} else if (version == 2) {
						_version = VERSION_MPEG2;
					} else {
						_version = VERSION_MPEG1;
					}
					
					var layerDescription:int = head>>1&0x3;
					if (layerDescription == 0) {
						_layerDescription = LAYER_DESCRIPTION_RESERVED;
					} else if (layerDescription == 1) {
						_layerDescription = LAYER_DESCRIPTION_LAYER3;
					} else if (layerDescription == 2) {
						_layerDescription = LAYER_DESCRIPTION_LAYER2;
					} else {
						_layerDescription = LAYER_DESCRIPTION_LAYER1;
					}
					
					_protection = (head&0x1) == 0 ? PROTECTION_CRC : PROTECTION_NONE;
					
					head = bytes.readUnsignedShort();
					var bitrateIndex:int = head>>12&0xF;
					if (_version == VERSION_MPEG1) {
						if (_layerDescription == LAYER_DESCRIPTION_LAYER1) {
							if (bitrateIndex == 0 || bitrateIndex == 15) {
								_bitRate = 0;
							} else {
								_bitRate = bitrateIndex*32;
							}
						} else if (_layerDescription == LAYER_DESCRIPTION_LAYER2) {
							if (bitrateIndex == 0 || bitrateIndex == 15) {
								_bitRate = 0;
							} else if (bitrateIndex == 1) {
								_bitRate = 32;
							} else if (bitrateIndex == 2) {
								_bitRate = 48;
							} else if (bitrateIndex == 3) {
								_bitRate = 56;
							} else if (bitrateIndex == 4) {
								_bitRate = 64;
							} else if (bitrateIndex == 5) {
								_bitRate = 80;
							} else if (bitrateIndex == 6) {
								_bitRate = 96;
							} else if (bitrateIndex == 7) {
								_bitRate = 112;
							} else if (bitrateIndex == 8) {
								_bitRate = 128;
							} else if (bitrateIndex == 9) {
								_bitRate = 160;
							} else if (bitrateIndex == 10) {
								_bitRate = 192;
							} else if (bitrateIndex == 11) {
								_bitRate = 224;
							} else if (bitrateIndex == 12) {
								_bitRate = 256;
							} else if (bitrateIndex == 13) {
								_bitRate = 320;
							} else if (bitrateIndex == 14) {
								_bitRate = 384;
							}
						} else if (_layerDescription == LAYER_DESCRIPTION_LAYER3){
							if (bitrateIndex == 0 || bitrateIndex == 15) {
								_bitRate = 0;
							} else if (bitrateIndex<6) {
								_bitRate = 24+bitrateIndex*8;
							} else if (bitrateIndex<10) {
								_bitRate = 80+(bitrateIndex-6)*16;
							} else if (bitrateIndex<14) {
								_bitRate = 160+(bitrateIndex-10)*32;
							} else {
								_bitRate = 320;
							}
						}
					} else if (_version == VERSION_MPEG2 || _version == VERSION_MPEG25) {
						if (_layerDescription == LAYER_DESCRIPTION_LAYER1) {
							if (bitrateIndex == 0 || bitrateIndex == 15) {
								_bitRate = 0;
							} else if (bitrateIndex == 1) {
								_bitRate = 32;
							} else if (bitrateIndex == 2) {
								_bitRate = 48;
							} else if (bitrateIndex == 3) {
								_bitRate = 56;
							} else if (bitrateIndex == 4) {
								_bitRate = 64;
							} else if (bitrateIndex == 5) {
								_bitRate = 80;
							} else if (bitrateIndex == 6) {
								_bitRate = 96;
							} else if (bitrateIndex == 7) {
								_bitRate = 112;
							} else if (bitrateIndex == 8) {
								_bitRate = 128;
							} else if (bitrateIndex == 9) {
								_bitRate = 144;
							} else if (bitrateIndex == 10) {
								_bitRate = 160;
							} else if (bitrateIndex == 11) {
								_bitRate = 176;
							} else if (bitrateIndex == 12) {
								_bitRate = 192;
							} else if (bitrateIndex == 13) {
								_bitRate = 224;
							} else if (bitrateIndex == 14) {
								_bitRate = 256;
							}
						} else if (_layerDescription == LAYER_DESCRIPTION_LAYER2 || _layerDescription == LAYER_DESCRIPTION_LAYER3) {
							if (bitrateIndex == 0 || bitrateIndex == 15) {
								_bitRate = 0;
							} else if (bitrateIndex<9) {
								_bitRate = bitrateIndex*8;
							} else {
								_bitRate = 64+(bitrateIndex-8)*16;
							}
						}
					}
					if (_bitRate>0) _bitRate *= 1000;
					
					var samplingRateFrequencyIndex:int = head>>10&0x3;
					if (samplingRateFrequencyIndex == 0) {
						if (_version == VERSION_MPEG1) {
							_sampleRate = 44100;
						} else if (_version == VERSION_MPEG2) {
							_sampleRate = 22050;
						} else if (_version == VERSION_MPEG25) {
							_sampleRate = 11025;
						} else {
							_sampleRate = 0;
						}
					} else if (samplingRateFrequencyIndex == 1) {
						if (_version == VERSION_MPEG1) {
							_sampleRate = 48000;
						} else if (_version == VERSION_MPEG2) {
							_sampleRate = 24000;
						} else if (_version == VERSION_MPEG25) {
							_sampleRate = 12000;
						} else {
							_sampleRate = 0;
						}
					} else if (samplingRateFrequencyIndex == 2) {
						if (_version == VERSION_MPEG1) {
							_sampleRate = 32000;
						} else if (_version == VERSION_MPEG2) {
							_sampleRate = 16000;
						} else if (_version == VERSION_MPEG25) {
							_sampleRate = 8000;
						} else {
							_sampleRate = 0;
						}
					} else {
						_sampleRate = 0;
					}
					
					var paddingBit:int = head>>9&0x1;
					
					var privateBit:int = head>>8&0x1;
					
					var channelMode:int = head>>6&0x3;
					if (channelMode == 0) {
						_channel = CHANNEL_STEREO;
					} else if (channelMode == 1) {
						_channel = CHANNEL_JOINT_STEREO;
					} else if (channelMode == 2) {
						_channel = CHANNEL_DUAL;
					} else {
						_channel = CHANNEL_SINGLE;
					}
					
					var mode_ext:int = head>>4&0x3;
					var jsbound:int;
					if (_layerDescription == LAYER_DESCRIPTION_LAYER1 || _layerDescription == LAYER_DESCRIPTION_LAYER2) {
						jsbound = 4*(mode_ext+1);
					} else if (_layerDescription == LAYER_DESCRIPTION_LAYER3) {
						if (mode_ext<3) {
							jsbound = 4*mode_ext;
						} else {
							jsbound = 16;
						}
					}
					
					_isCopyright = (head>>3&0x1) == 1;
					
					_isOriginMedia = (head>>2&0x1) == 1;
					
					if (_protection == PROTECTION_CRC) {
						bytes.readShort();
					}
					
					var frameSize:Number = (((_version == VERSION_MPEG1 ? 144 : 72)*_bitRate)/_sampleRate)+paddingBit;
					
					bytes.position = bytes.length-length;
					if (_version == VERSION_MPEG1) {
						if (_channel == CHANNEL_SINGLE) {
							bytes.position += 21;
						} else {
							bytes.position += 36;
						}
					} else {
						if (_channel == CHANNEL_SINGLE) {
							bytes.position += 13;
						} else {
							bytes.position += 21;
						}
					}
					_isVBR = bytes.readUTFBytes(4) == 'Xing';
					_bitRateType = _isVBR ? BITRATE_VBR : BITRATE_CBR;
					bytes.position = bytes.length-length+40;
					var flags:uint = bytes.readUnsignedInt();
					var totalFrames:uint = bytes.readUnsignedInt();
					var fileLength:uint = bytes.readUnsignedInt();
					
					bytes.position = bytes.length-128;
					if (bytes.readUTFBytes(3) == 'TAG') {
						_hasID3v1Info = true;
						length -= 128;
						_id3v1Info.title = bytes.readMultiByte(30, characterSet);
						_id3v1Info.artist = bytes.readMultiByte(30, characterSet);
						_id3v1Info.album = bytes.readMultiByte(30, characterSet);
						_id3v1Info.year = bytes.readMultiByte(4, characterSet);
						if (bytes[bytes.position+28] == 0x0) {
							_id3v1Info.comment = bytes.readMultiByte(28, characterSet);
							bytes.readUnsignedByte();
							_id3v1Info.track =  bytes.readUnsignedByte().toString();
						} else {
							_id3v1Info.comment = bytes.readMultiByte(30, characterSet);
							_id3v1Info.track =  null;
						}
						_id3v1Info.genre = ID3v1GenreTable.getGenre(bytes.readUnsignedByte());
					}
					_totalSeconds = 0.026*(_isVBR ? totalFrames : length/frameSize);
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
	}
}