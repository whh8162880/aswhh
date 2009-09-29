package asgl.files.utils.zip {
	import asgl.events.FileEvent;
	import asgl.files.AbstractFile;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class ZIPEncoder extends AbstractFile {
		private var _directoryList:Array;
		private var _fileList:Array;
		private var _writeCentralList:Array;
		private var _bytes:ByteArray;
		public function ZIPEncoder():void {
			clear();
		}
		public function get bytes():ByteArray {
			return _bytes;
		}
		public function get totalDirectories():uint {
			return _directoryList.length;
		}
		public function get totalFiles():uint {
			return _fileList.length;
		}
		public function addDirectory(directory:ZIPDirectory):void {
			if (_directoryList.indexOf(directory) == -1) _directoryList.push(directory);
		}
		public function addFile(file:ZIPFile):void {
			if (_fileList.indexOf(file) == -1) _fileList.push(file);
		}
		public override function clear():void {
			_clear();
			_directoryList = [];
			_fileList = [];
		}
		public function encode():void {
			try {
				_writeCentralList = [];
				_bytes = new ByteArray();
				_bytes.endian = Endian.LITTLE_ENDIAN;
				var length:int = _directoryList.length;
				for (var i:int = 0; i<length; i++) {
					_writeDirectory(_directoryList[i]);
				}
				length = _fileList.length;
				for (i = 0; i<length; i++) {
					_writeFile(_fileList[i]);
				}
				var pos:uint = _bytes.position;
				length = _writeCentralList.length;
				for (i = 0; i<length; i++) {
					_wirteCentral(_writeCentralList[i]);
				}
				_writeCentralEnd(pos, _bytes.position-pos);
				_writeCentralList = null;
				_isCorrectFormat = true;
				this.dispatchEvent(new FileEvent(FileEvent.COMPLETE));
			} catch (e:Error) {
				_clear();
				this.dispatchEvent(new FileEvent(FileEvent.ERROR, e));
			}
		}
		public function getDirectory(index:uint):ZIPDirectory {
			return _directoryList[index];
		}
		public function getFile(index:uint):ZIPFile {
			return _fileList[index];
		}
		public function removeDirectory(directory:ZIPDirectory):Boolean {
			var index:int = _directoryList.indexOf(directory);
			if (index == -1) {
				return false;
			} else {
				_directoryList.splice(index, 1);
				return true;
			}
		}
		public function removeFile(file:ZIPFile):Boolean {
			var index:int = _fileList.indexOf(file);
			if (index == -1) {
				return false;
			} else {
				_fileList.splice(index, 1);
				return true;
			}
		}
		private function _clear():void {
			_bytes = null;
			_writeCentralList = null;
			_isCorrectFormat = false;
		}
		private function _wirteCentral(list:Array):void {
			var extraFieldLength:uint = list[8];
			_bytes.writeUnsignedInt(ZIPSignature.CENTRAL_FILE_HEADER);
			_bytes.writeShort(0x14);
			_bytes.writeShort(list[0]);
			_bytes.writeShort(list[1]);
			_bytes.writeShort(list[2]);
			_bytes.writeUnsignedInt(list[3]);
			_bytes.writeUnsignedInt(list[4]);
			_bytes.writeUnsignedInt(list[5]);
			_bytes.writeUnsignedInt(list[6]);
			_bytes.writeShort(list[7].length);
			_bytes.writeShort(extraFieldLength);
			_bytes.writeShort(0);
			_bytes.writeShort(0);
			_bytes.writeShort(0);
			_bytes.writeUnsignedInt(list[10]);
			_bytes.writeUnsignedInt(list[11]);
			_bytes.writeMultiByte(list[7], characterSet);
			if (extraFieldLength != 0) _bytes.writeBytes(list[9], 0, extraFieldLength);
		}
		private function _writeCentralEnd(centralOffset:uint, centralLength:uint):void {
			_bytes.writeUnsignedInt(ZIPSignature.CENTRAL_DIR_END);
			_bytes.writeShort(0);
			_bytes.writeShort(0);
			_bytes.writeShort(_writeCentralList.length);
			_bytes.writeShort(_writeCentralList.length);
			_bytes.writeUnsignedInt(centralLength);
			_bytes.writeUnsignedInt(centralOffset);
			_bytes.writeShort(0);
		}
		private function _writeDirectory(directory:ZIPDirectory, path:String = null):void {
			var name:String = path == null ? directory.name+'/' : path+directory.name+'/';
			var pos:uint = _bytes.position;
			_bytes.writeUnsignedInt(ZIPSignature.LOCAL_FILE_HEADER);
			_bytes.writeShort(0xA);
			_bytes.writeShort(0);
			_bytes.writeShort(ZIPCompressionMethod.STORED);
			_bytes.writeUnsignedInt(directory.dosTime);
			_bytes.writeUnsignedInt(0);
			_bytes.writeUnsignedInt(0);
			_bytes.writeUnsignedInt(0);
			_bytes.writeShort(name.length);
			_bytes.writeShort(0);
			_bytes.writeMultiByte(name, characterSet);
			
			_writeCentralList.push([0xA, 0, 0, directory.dosTime, 0, 0, 0, name, 0, null, 0x10, pos]);
			
			var length:int = directory.totalDirectories;
			for (var i:int = 0; i<length; i++) {
				_writeDirectory(directory.getDirectory(i), name);
			}
			length = directory.totalFiles;
			for (i = 0; i<length; i++) {
				_writeFile(directory.getFile(i), name);
			}
		}
		private function _writeFile(file:ZIPFile, path:String = null):void {
			var name:String = path == null ? file.name : path+file.name;
			var flag:uint = file.compressionMethod  == ZIPCompressionMethod.DEFLATED ? file.deflateCompressionLevel<<1 : 0;
			var pos:uint = _bytes.position;
			_bytes.writeUnsignedInt(ZIPSignature.LOCAL_FILE_HEADER);
			_bytes.writeShort(0x14);
			_bytes.writeShort(flag);
			_bytes.writeShort(file.compressionMethod);
			_bytes.writeUnsignedInt(file.dosTime);
			_bytes.writeUnsignedInt(file.crc32);
			_bytes.writeUnsignedInt(file.compressedSize);
			_bytes.writeUnsignedInt(file.uncompressedSize);
			_bytes.writeShort(name.length);
			var extraFieldLength:uint = file.extra == null ? 0 : file.extra.length;
			if (extraFieldLength>0xFFFF) extraFieldLength = 0xFFFF;
			_bytes.writeShort(extraFieldLength);
			_bytes.writeMultiByte(name, characterSet);
			_bytes.writeBytes(file.data);
			if (extraFieldLength != 0) _bytes.writeBytes(file.extra, 0, extraFieldLength);
			
			_writeCentralList.push([file.compressionMethod == ZIPCompressionMethod.STORED ? 0xA : 0x14, flag, file.compressionMethod, file.dosTime, file.crc32, file.compressedSize, file.uncompressedSize, name, extraFieldLength, file.extra, 0x20, pos]);
		}
	}
}