package asgl.files.media {
	import asgl.events.FileEvent;
	import asgl.files.AbstractEncoder;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class SWFEncoder extends AbstractEncoder {
		public static const TAG_FILE_ATTRIBUTES:uint = 0x1144;
		public static const TAG_DO_ABC:uint = 0x14BF;
		public static const TAG_SHOW_FRAME:uint = 0x40;
		public static const TAG_BACKGROUND_COLOR:uint = 0x243;
		public static const TAG_END:uint = 0x0;
		public static const TAG_SCENE:uint = 0x15BF;
		public static const TAG_SOUND:uint = 0x3BF;
		public static const TAG_SYMBOL_CLASS:uint = 0x133F;
		public static const TAG_SOUND_STREAM_HEAD2:uint = 0xB44;
		public static const CLASS_SOUND:uint = 0x605;
		public static const SOUND_TYPE_ADPCM:String = 'ADPCM';
		public static const SOUND_TYPE_MP3:String = 'MP3';
		private var _actionData:ActionData = new ActionData();
		private var _useNetWork:Boolean = false;
		private var _header:ByteArray = new ByteArray();
		private var _compress:Boolean = true;
		private var _backgroundColor:uint = 0xFFFFFF;
		private var _frameRate:uint = 12;
		private var _height:uint = 400;
		private var _totalFrames:uint = 1;
		private var _width:uint = 550;
		public function SWFEncoder():void {
			_header.endian = Endian.LITTLE_ENDIAN;
			_header.writeUTFBytes('FWS');
			_header.writeByte(9);//version
			_header.writeUnsignedInt(0);//length
			_header.writeShort(0x78);//rect unit 15bit
			_setRect();
			_writeTagCode(_header, TAG_FILE_ATTRIBUTES, 21);
			this.useNetWork = _useNetWork;
			this.frameRate = _frameRate;
			this.totalFrames = _totalFrames;
			_writeTagCode(_header, TAG_BACKGROUND_COLOR, 27);
			this.backgroundColor = _backgroundColor;
		}
		public function get backgroundColor():uint {
			return _backgroundColor;
		}
		public function set backgroundColor(value:uint):void {
			_backgroundColor = value;
			_seek(_header, 29);
			_header.writeByte(_backgroundColor>>16&0xFF);
			_header.writeByte(_backgroundColor>>8&0xFF);
			_header.writeByte(_backgroundColor&0xFF);
		}
		public function get compress():Boolean {
			return _compress;
		}
		public function set compress(value:Boolean):void {
			_compress = value;
		}
		public function get frameRate():uint {
			return _frameRate;
		}
		public function set frameRate(value:uint):void {
			if (value<1) value = 1;
			_frameRate = value;
			_seek(_header, 17);
			_header.writeShort(_frameRate*256);
		}
		public function get height():uint {
			return _height;
		}
		public function set height(value:uint):void {
			if (value>=1 && value<=2880) {
				_height = value;
				_setRect();
			}
		}
		public function get totalFrames():uint {
			return _totalFrames;
		}
		public function set totalFrames(value:uint):void {
			_totalFrames = value;
			_seek(_header, 19);
			_header.writeShort(_totalFrames);
		}
		public function get useNetWork():Boolean {
			return _useNetWork;
		}
		public function set useNetWork(value:Boolean):void {
			_useNetWork = value;
			_seek(_header, 23);
			_header.writeUnsignedInt(_useNetWork ? 9 : 8);
		}
		public function get width():uint {
			return _width;
		}
		public function set width(value:uint):void {
			if (value>=1 && value<=2880) {
				_width = value;
				_setRect();
			}
		}
		public function addScene(name:String):void {
			_actionData.addScene(name);
		}
		public function addSoundAsset(className:String, sound:ByteArray):void {
			if (className.indexOf('.') == -1) {
				_actionData.addSoundAsset(className, sound);
			} else {
				throw new Error('the class name not set "."');
			}
		}
		/**public function addSoundStreamHead2():void {
			_actionData.hasSoundStreamHead2 = true;
		}**/
		public override function clear():void {
			super.clear();
			_actionData.clear();
		}
		public static function compress(bytes:ByteArray):ByteArray {
			bytes.endian = Endian.LITTLE_ENDIAN;
			bytes.position = 0;
			var out:ByteArray = new ByteArray();
			out.endian = Endian.LITTLE_ENDIAN;
			var type:String = bytes.readUTFBytes(3);
			if (type == 'FWS') {
				var temp:ByteArray = new ByteArray();
				temp.endian = Endian.LITTLE_ENDIAN;
				bytes.position = 8;
				bytes.readBytes(temp);
				temp.compress();
				bytes.position = 0;
				bytes.readBytes(out, 0, 8);
				out.position = 8;
				out.writeBytes(temp);
				out[0] = 0x43;
			} else if (type == 'CWS') {
				bytes.position = 0;
				bytes.readBytes(out);
			} else {
				throw new Error('file error');
			}
			return out;
		}
		public static function unpack(bytes:ByteArray):ByteArray {
			bytes.endian = Endian.LITTLE_ENDIAN;
			bytes.position = bytes.length-4;
			var length:uint = bytes.readUnsignedInt();
			var out:ByteArray = new ByteArray();
			out.writeBytes(bytes, bytes.length-8-length, length);
			return out;
		}
		public function removeScene(name:String):void {
			_actionData.removeScene(name);
		}
		public function removeSoundAsset(className:String):void {
			_actionData.removeSoundAsset(className);
		}
		public static function uncompress(bytes:ByteArray):ByteArray {
			bytes.endian = Endian.LITTLE_ENDIAN;
			bytes.position = 0;
			var out:ByteArray = new ByteArray();
			out.endian = Endian.LITTLE_ENDIAN;
			var type:String = bytes.readUTFBytes(3);
			if (type == 'FWS') {
				bytes.position = 0;
				bytes.readBytes(out);
			} else if (type == 'CWS') {
				var temp:ByteArray = new ByteArray();
				temp.endian = Endian.LITTLE_ENDIAN;
				bytes.position = 8;
				bytes.readBytes(temp);
				temp.uncompress();
				bytes.position = 0;
				bytes.readBytes(out, 0, 8);
				out.position = 8;
				out.writeBytes(temp);
				out[0] = 0x46;
			} else {
				throw new Error('file error');
			}
			return out;
		}
		public function encode():void {
			try {
				_bytes = new ByteArray();
				_bytes.endian = Endian.LITTLE_ENDIAN;
				_header.position = 0;
				_header.readBytes(_bytes);
				var assetslist:Array = _actionData.assetsList;
				var scenesList:Array = _actionData.scenesList;
				var i:int;
				var totalAssets:int = assetslist.length;
				var totalScenes:int = scenesList.length;
				var assetInfo:AssetInfo;
				var pos:uint;
				var name:String;
				var type:int;
				
				if (_actionData.hasScenes) {
					_writeTagCode(_bytes, TAG_SCENE, _bytes.length);
					pos = _bytes.position;
					_bytes.writeUnsignedInt(0);//length
					_bytes.writeByte(totalScenes);
					for (i = 0; i<totalScenes; i++) {
						_bytes.writeByte(i);//offset
						_bytes.writeMultiByte(scenesList[i], characterSet);
						if (i<totalScenes-1) _bytes.writeByte(0);
					}
					_bytes.writeShort(0);
					_bytes.position = pos;
					_bytes.writeUnsignedInt(_bytes.length-pos-4);
				}
				
				if (_actionData.hasAssets) {
					var importClassesList:Array = _actionData.importClassesList;
					var totalImportClasses:int = importClassesList.length;
					_writeTagCode(_bytes, TAG_DO_ABC, _bytes.length);
					pos = _bytes.position;
					_bytes.writeUnsignedInt(0);//length
					_bytes.writeUnsignedInt(1);
					_bytes.writeUnsignedInt(0x2E001000);
					_bytes.writeUnsignedInt(0);
					_bytes.writeShort(totalImportClasses+2);//num
					for (i = 0; i<totalImportClasses; i++) {
						name = importClassesList[i];
						_bytes.writeByte(name.length);
						_bytes.writeMultiByte(name, characterSet);
					}
					_bytes.writeUnsignedInt(0x16011600+4+totalAssets);
					_bytes.writeShort(0x1803);
					_bytes.writeByte(2);
					for (i = 1; i<totalAssets; i++) {
						_bytes.writeByte(0x18);
						_bytes.writeByte(4+i);
					}
					_bytes.writeByte(0x16);
					_bytes.writeShort(5+totalAssets);
					_bytes.writeByte(4+totalAssets);
					_bytes.writeUnsignedInt(0x7020107);
					_bytes.writeShort(0x402);
					_bytes.writeByte(7);
					for (i = 0; i<totalAssets; i++) {
						_bytes.writeByte(1);
						_bytes.writeByte(5+i);
						_bytes.writeByte(7);
					}
					_bytes.writeByte(3+totalAssets);
					_bytes.writeByte(6+totalAssets);
					_bytes.writeShort(3*totalAssets);
					for (i = 12*totalAssets; i>0; i--) {
						_bytes.writeByte(0);
					}
					_bytes.writeByte(totalAssets);
					_bytes.writeByte(1);
					_bytes.writeShort(0x802);
					_bytes.writeShort(3);
					_bytes.writeShort(1);
					if (totalAssets>1){
						for (i = 1; i<totalAssets; i++) {
							_bytes.writeByte(3+i-1);
							_bytes.writeShort(0x802);
							_bytes.writeShort(4+i-1);
							_bytes.writeShort(4+3*(i-1));
						}
						for (i = 1; i<totalAssets; i++) {
							_bytes.writeShort(3*(i-1));
						}
					}
					_bytes.writeShort(3*(totalAssets-1));
					_bytes.writeShort(0x200+totalAssets);
					_bytes.writeUnsignedInt(0x1040101);
					for (i = 1; i<totalAssets; i++) {
						_bytes.writeByte(i-1);
						_bytes.writeByte(2+3*i);
						_bytes.writeByte(1);
						_bytes.writeByte(2+i);
						_bytes.writeShort(0x104);
					}
					_bytes.writeByte(totalAssets-1);
					_bytes.writeByte(3*totalAssets);
					for (i = 0; i<totalAssets; i++) {
						type = assetslist[i].type;
						if (type == ActionData.TYPE_SOUND) {
							_addSoundClassTemplate(_bytes, i, totalAssets);
						}
					}
					_bytes.position = pos;
					_bytes.writeUnsignedInt(_bytes.length-pos-4);
				}
				
				if (_actionData.hasAssets) {
					for (i = 0; i<totalAssets; i++) {
						assetInfo = assetslist[i];
						type = assetInfo.type;
						if (type == ActionData.TYPE_SOUND) {
							_addSoundAsset(_bytes, assetInfo);
						}
					}
				}
				
				if (_actionData.hasAssets) {
					_writeTagCode(_bytes, TAG_SYMBOL_CLASS, _bytes.length);
					pos = _bytes.position;
					_bytes.writeUnsignedInt(0);//length
					_bytes.writeShort(totalAssets);
					for (i = 0; i<totalAssets; i++){
						assetInfo = assetslist[i];
						_bytes.writeShort(assetInfo.id)//id;
						_bytes.writeMultiByte(assetInfo.className, characterSet);//className
						_bytes.writeByte(0);
					}
					_bytes.position = pos;
					_bytes.writeUnsignedInt(_bytes.length-pos-4);
				}
				
				/**if (_actionData.hasSoundStreamHead2) {
					_writeTagCode(_bytes, TAG_SOUND_STREAM_HEAD2, _bytes.length);
					_bytes.writeUnsignedInt(0x26);
				}**/
				
				if (totalScenes == 0) totalScenes = 1;
				for (i = 0; i<totalScenes; i++) {
					_writeTagCode(_bytes, TAG_SHOW_FRAME, _bytes.length);
				}
				
				_writeTagCode(_bytes, TAG_END);
				_bytes.position = 4;
				_bytes.writeUnsignedInt(_bytes.length);
				if (_compress) _bytes = SWFEncoder.compress(_bytes);
				_isCorrectFormat = true;
				this.dispatchEvent(new FileEvent(FileEvent.COMPLETE));
			} catch (e:Error) {
				_bytes = null;
				_isCorrectFormat = false;
				this.dispatchEvent(new FileEvent(FileEvent.ERROR, e));
			}
		}
		private function _addSoundAsset(bytes:ByteArray, assetInfo:AssetInfo):void {
			var asset:ByteArray = assetInfo.data;
			_writeTagCode(bytes, TAG_SOUND, bytes.length);
			bytes.writeUnsignedInt(asset.length+9);
			bytes.writeShort(assetInfo.id);//id
			if (assetInfo.type2 == ActionData.SOUND_TYPE_MP3) {
				var mp3:MP3Reader = new MP3Reader(asset);
				bytes.writeByte(_getSoundInfoByte(SOUND_TYPE_MP3, 44100, 16, mp3.channel == MP3Reader.CHANNEL_SINGLE ? 1 : 2));
				bytes.writeUnsignedInt(mp3.sampleRate*mp3.totalSeconds);
				bytes.writeShort(0);
			} else {
				var wav:WAVReader = new WAVReader(asset);
				bytes.writeByte(_getSoundInfoByte(SOUND_TYPE_ADPCM, wav.sampleRate, 16, wav.channels));
				bytes.writeUnsignedInt(wav.sampleRate*wav.totalSeconds);
				bytes.writeShort(0xC0);
			}
			
			bytes.writeBytes(asset);
		}
		private function _addSoundClassTemplate(bytes:ByteArray, index:uint, total:uint):void {
			bytes.writeByte(3*index);
			bytes.writeShort(0x101);
			bytes.writeShort(CLASS_SOUND);
			bytes.writeUnsignedInt(0x4730D003);
			bytes.writeShort(0);
			bytes.writeByte(1+3*index);
			bytes.writeUnsignedInt(0x7060101);
			bytes.writeUnsignedInt(0xD030D006);
			bytes.writeUnsignedInt(0x470049);
			bytes.writeByte(0);
			bytes.writeByte(2+3*index);
			bytes.writeUnsignedInt(0x5010102);
			bytes.writeUnsignedInt(0x6530D017);
			bytes.writeShort(0x6000);
			bytes.writeByte(total+2);
			bytes.writeShort(0x6030);
			bytes.writeByte(total+3);
			bytes.writeShort(0x6030);
			bytes.writeUnsignedInt(0x2603002);
			bytes.writeByte(0x58);
			bytes.writeByte(index);
			bytes.writeUnsignedInt(0x681D1D1D);
			if (index == 0) {
				bytes.writeUnsignedInt(0x4701);
			} else {
				bytes.writeUnsignedInt(0x4702+index);
			}
		}
		private function _getSoundInfoByte(type:String, sampleRate:int, bits:int, channels:int):uint {
			var t:uint;
			var s:uint;
			var b:uint;
			var c:uint;
			if (type == SOUND_TYPE_ADPCM) {
				t = 0x1;
			} else if (type == SOUND_TYPE_MP3) {
				t = 0x2;
			}
			if (sampleRate >= 44100) {
				s = 0x3;
			} else if (sampleRate >= 22050) {
				s = 0x2;
			} else if (sampleRate >= 11025) {
				s = 0x1;
			} else {//5512
				s = 0x0;
			}
			if (bits == 16 || true) {
				b = 1;
			}
			c = channels == 1 ? 0 : 1;
			return t<<4|s<<2|b<<1|c;
		}
		private function _seek(bytes:ByteArray, position:int):void {
			if (position<0) return;
			if (bytes.length<position) bytes.length = position;
			bytes.position = position;
		}
		private function _setRect():void {
			var w:uint = _width*20;
			var h:uint = _height*20;
			_seek(_header, 10);
			_header.writeByte(w>>11&0xF);
			_header.writeByte(w>>3&0xFF);
			_header.writeByte((w&0x7)<<5);
			_header.writeByte(0);
			_header.writeByte(h>>9&0x3F);
			_header.writeByte(h>>1&0xFF);
			_header.writeByte((h&0x1)<<7);
		}
		private function _writeTagCode(bytes:ByteArray, tag:uint, position:int = -1):void {
			if (position != -1) _seek(bytes, position);
			//trace('write tag:'+tag.toString(16));
			bytes.writeShort(tag);
			//trace(bytes[bytes.position-2].toString(16), bytes[bytes.position-1].toString(16));
		}
	}
}
	import flash.utils.ByteArray;
	import asgl.files.media.MP3Reader;
	import asgl.files.media.WAVReader;
	
class ActionData {
	public static const TYPE_SOUND:int = 0;
	public static const TYPE_IMAGE:int = 1;
	public static const TYPE_SPRITE:int = 2;
	public static const TYPE_MOVIECLIP:int = 3;
	public static const SOUND_TYPE_MP3:int = 0;
	public static const SOUND_TYPE_WAV:int = 1;
	private var _assetsList:Array;
	private var _scenesList:Array;
	private var _hasAssets:Boolean = true;
	private var _idManager:uint;
	public var hasSoundStreamHead2:Boolean = false;
	public function ActionData():void {
		clear();
	}
	public function get assetsList():Array {
		return _assetsList;
	}
	public function get hasAssets():Boolean {
		return _hasAssets;
	}
	public function get hasScenes():Boolean {
		return _scenesList.length != 0;
	}
	public function get importClassesList():Array {
		var soundAssetsList:Array = [];
		var imageAssetsList:Array = [];
		var spriteAssetsList:Array = [];
		var movieclipAssetsList:Array = [];
		var length:int = _assetsList.length;
		for (var i:int = 0; i<length; i++){
			var assetInfo:AssetInfo = _assetsList[i];
			var type:int = assetInfo.type;
			if (type == TYPE_SOUND) {
				soundAssetsList.push(assetInfo.className);
			} else if (type == TYPE_IMAGE) {
				imageAssetsList.push(assetInfo.className);
			} else if (type == TYPE_SPRITE){
				spriteAssetsList.push(assetInfo.className);
			} else if (type == TYPE_MOVIECLIP) {
				movieclipAssetsList.push(assetInfo.className);
			}
		}
		var hasSoundAssets:Boolean = soundAssetsList.length != 0;
		var hasImageAssets:Boolean = imageAssetsList.length != 0;
		var hasSpriteAssets:Boolean = spriteAssetsList.length != 0;
		var hasMovieClipAssets:Boolean = movieclipAssetsList.length != 0;
		var list:Array = [];
		if (hasImageAssets) {
			list.push('Number');
			list.push(imageAssetsList[0]);
			list.push('flash.display');
			list.push('BitmapData');
			for (i = 1; i<length; i++) {
				list.push(imageAssetsList[i]);
			}
		}
		if (hasSoundAssets) {
			list.push(soundAssetsList[0]);
			list.push('flash.media');
			list.push('Sound');
			length = soundAssetsList.length;
			for (i = 1; i<length; i++) {
				list.push(soundAssetsList[i]);
			}
		}
		if (hasSpriteAssets) {
			list.push(spriteAssetsList[0]);
			if (!hasImageAssets) list.push('flash.display');
			list.push('Sprite');
			length = spriteAssetsList.length;
			for (i = 1; i<length; i++) {
				list.push(spriteAssetsList[i]);
			}
		}
		if (hasMovieClipAssets) {
			list.push(movieclipAssetsList[0]);
			if (!hasImageAssets && !hasSpriteAssets) list.push('flash.display');
			list.push('MovieClip');
			length = movieclipAssetsList.length;
			for (i = 1; i<length; i++) {
				list.push(movieclipAssetsList[i]);
			}
		}
		if (list.length != 0) list.push('Object');
		if (hasSoundAssets || hasSpriteAssets || hasMovieClipAssets) {
			list.push('flash.events');
			list.push('EventDispatcher');
			if (hasSpriteAssets || hasMovieClipAssets) {
				list.push('DisplayObject');
				list.push('InteractiveObject');
				list.push('DisplayObjectContainer');
			}
			if (!hasSpriteAssets && hasMovieClipAssets) list.push('Sprite');
		}
		return list;
	}
	public function get scenesList():Array {
		return _copyList(_scenesList);
	}
	public function addScene(name:String):void {
		if (_scenesList.indexOf(name) == -1) _scenesList.push(name);
	}
	public function addSoundAsset(className:String, sound:ByteArray):void {
		_hasAssets = true;
		if (!_hasSameClassNameTest(className)) {
			var mp3:MP3Reader = new MP3Reader(sound);
			if (mp3.isCorrectFormat) {
				_addSoundAsset(className, sound, SOUND_TYPE_MP3);
			} else {
				throw new Error('sound type error');
				//var wav:WAVReader = new WAVReader(sound);
				//if (wav.isCorrectForamt) _addSoundAsset(className, sound, SOUND_TYPE_WAV);
			}
			
		}
	}
	public function clear():void {
		_idManager = 0;
		_assetsList = [];
		_scenesList = [];
		_hasAssets = false;
	}
	public function removeScene(name:String):void {
		var index:int = _scenesList.indexOf(name);
		if (index != -1) {
			_scenesList.splice(index, 1);
		}
	}
	public function removeSoundAsset(className:String):void {
		_removeAssetInfo(className);
		_hasAssetsTest();
	}
	private function _addSoundAsset(className:String, sound:ByteArray, type:int):void {
		var assetInfo:AssetInfo = new AssetInfo();
		_idManager++;
		assetInfo.id = _idManager;
		assetInfo.type = TYPE_SOUND;
		assetInfo.type2 = type;
		assetInfo.className = className;
		assetInfo.data = sound;
		_assetsList.push(assetInfo);
	}
	private function _copyList(list:Array):Array {
		var out:Array = [];
		var length:int = list.length;
		for (var i:int = 0; i<length; i++){
			out[i] = list[i];
		}
		return out;
	}
	private function _hasAssetsTest():void {
		_hasAssets = _assetsList.length != 0;
	}
	private function _removeAssetInfo(className:String):void {
		var length:int = _assetsList.length;
		for (var i:int = 0; i<length; i++){
			if (_assetsList[i].className == className) {
				_assetsList.splice(i, 1);
				length--;
				for (var j:int = i; j<length; j++) {
					_assetsList[j].id--;
				}
				_idManager--;
				break;
			}
		}
	}
	private function _hasSameClassNameTest(className:String):Boolean {
		var length:int = _assetsList.length;
		for (var i:int = 0; i<length; i++){
			if (_assetsList[i].className == className) return true;
		}
		return false;
	}
}
class AssetInfo {
	public var data:ByteArray;
	public var type:int;
	public var type2:int;
	public var className:String;
	public var id:uint;
}