package asgl.files.utils.zip {
	import asgl.events.FileEvent;
	import asgl.files.AbstractFile;
	import asgl.files.CharacterSet;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class ZIPReader extends AbstractFile {
		private var _directoryList:Array;
		private var _fileList:Array;
		public function ZIPReader(bytes:ByteArray=null):void {
			if (bytes == null) {
				clear();
			} else {
				read(bytes);
			}
		}
		public function get componentStructureXML():XML {
			var xml:XML = <zip/>;
			for (var i:int = 0; i<totalDirectories; i++) {
				xml.appendChild(_getDirectoryXML(_directoryList[i]));
			}
			for (i = 0; i<totalFiles; i++) {
				xml.appendChild(_getFileXML(_fileList[i]));
			}
			return xml;
		}
		public function get totalDirectories():uint {
			return _directoryList.length;
		}
		public function get totalFiles():uint {
			return _fileList.length;
		}
		public override function clear():void {
			super.clear();
			_fileList = [];
			_directoryList = [];
		}
		public function getDirectory(index:uint):ZIPDirectory {
			return _directoryList[index];
		}
		public function getFile(index:uint):ZIPFile {
			return _fileList[index];
		}
		public function read(bytes:ByteArray):void {
			clear();
			try {
				bytes.endian = Endian.LITTLE_ENDIAN;
				bytes.position = 0;
				var fileNameLength:uint;
				var extraFieldLength:uint;
				var fileCommentLength:uint;
				var directoryMap:Object = {};
				var level:uint = 0;
				while (bytes.bytesAvailable>0) {
					var signature:uint = bytes.readUnsignedInt();
					if (signature == ZIPSignature.LOCAL_FILE_HEADER) {
						bytes.readUnsignedShort();//version needed to extract
						var flag:uint = bytes.readUnsignedShort();
						var compressionMethod:uint = bytes.readUnsignedShort();
						if (compressionMethod == ZIPCompressionMethod.DEFLATED) level = flag>>1&0x3;
						var charSet:String = (flag>>10&0x1) ? CharacterSet.UTF_8 : characterSet;
						var time:uint = bytes.readUnsignedInt();
						var crc:uint = bytes.readUnsignedInt();
						var compressedSize:uint = bytes.readUnsignedInt();
						var uncompressedSize:uint = bytes.readUnsignedInt();
						fileNameLength = bytes.readUnsignedShort();
						extraFieldLength = bytes.readUnsignedShort();
						var fileName:String = bytes.readMultiByte(fileNameLength, charSet);
						var extra:ByteArray;
						if (extraFieldLength != 0) {
							extra = new ByteArray();
							extra.endian = Endian.LITTLE_ENDIAN;
							bytes.readBytes(extra, 0, extraFieldLength);
						}
						var data:ByteArray = new ByteArray();
						data.endian = Endian.LITTLE_ENDIAN;
						if (compressedSize != 0) bytes.readBytes(data, 0, compressedSize);
						if ((flag>>2&0x1) == 1) {
							bytes.readUnsignedInt();//crc32
							bytes.readUnsignedInt();//compressed size
							bytes.readUnsignedInt();//uncompressed size
						}
						var parentDirectory:ZIPDirectory;
						if (_isDirectory(fileName)) {
							var directory:ZIPDirectory = new ZIPDirectory();
							directory.dosTime = time;
							directory.name = _getDirectoryName(fileName);
							directoryMap[fileName] = directory;
							parentDirectory = directoryMap[_getDirectoryParent(fileName)];
							if (parentDirectory == null) {
								_directoryList.push(directory);
							} else {
								parentDirectory.addDirectory(directory);
							}
						} else {
							var file:ZIPFile = new ZIPFile();
							file.dosTime = time;
							file.name =_getFileName(fileName);
							file.extra = extra;
							file.setData(data, compressionMethod, level, uncompressedSize, crc);
							parentDirectory = directoryMap[_getFileParent(fileName)];
							if (parentDirectory == null) {
								_fileList.push(file);
							} else {
								parentDirectory.addFile(file);
							}
						}
					} else if (signature == ZIPSignature.ARCHIVE_EXTRA_DATA) {
						extraFieldLength = bytes.readUnsignedInt();
						bytes.position += extraFieldLength;
					} else if (signature == ZIPSignature.CENTRAL_FILE_HEADER) {
						bytes.readUnsignedShort();//version made by
						bytes.readUnsignedShort();//version needed to extract
						bytes.readUnsignedShort();//flag
						bytes.readUnsignedShort();//compression method
						bytes.readUnsignedShort();//time
						bytes.readUnsignedShort();//date
						bytes.readUnsignedInt();//crc32
						bytes.readUnsignedInt();//compressed size
						bytes.readUnsignedInt();//uncompressed size
						fileNameLength = bytes.readUnsignedShort();
						extraFieldLength = bytes.readUnsignedShort();
						fileCommentLength = bytes.readUnsignedShort();
						bytes.readUnsignedShort();//disk number start
						bytes.readUnsignedShort();//internal file attributes
						bytes.readUnsignedInt();//external file attributes	
						bytes.readUnsignedInt();//relative offset of local header
						//trace(bytes.readMultiByte(fileNameLength, characterSet));
						bytes.position += fileNameLength;
						bytes.position += extraFieldLength;
						bytes.position += fileCommentLength;
					} else if (signature == ZIPSignature.DIGITAL_HEADER) {
						var dataSize:uint = bytes.readUnsignedShort();
						bytes.position += dataSize;
					} else if (signature == ZIPSignature.CENTRAL_DIR_END) {
						bytes.readUnsignedShort();//number of this disk
						bytes.readUnsignedShort();//number of the disk with the start of the central directory
						bytes.readUnsignedShort();//total number of entries in the central directory on this disk 
						bytes.readUnsignedShort();//the central directory
						bytes.readUnsignedInt();//size of the central directory
						bytes.readUnsignedInt();//offset of start of central directory with respect to the starting disk number
						fileCommentLength = bytes.readUnsignedShort();
						bytes.position + fileCommentLength;
						break;
					}
				}
				this.dispatchEvent(new FileEvent(FileEvent.COMPLETE));
			} catch (e:Error) {
				clear();
				this.dispatchEvent(new FileEvent(FileEvent.ERROR));
			}
		}
		private function _getDirectoryName(name:String):String {
			var list:Array = name.split('/');
			return list[list.length-2];
		}
		private function _getDirectoryParent(name:String):String {
			var str:String = _getDirectoryName(name);
			return name.substr(0, name.length-str.length-1);
		}
		private function _getDirectoryXML(directory:ZIPDirectory):XML {
			var d:Date = new Date(directory.time);
			var xml:XML = <directory name={directory.name} date={d.fullYear+' '+d.month+' '+d.date+' '+d.hours+':'+d.minutes+':'+d.seconds}></directory>;
			var totalDirectories:uint = directory.totalDirectories;
			for (var i:int = 0; i<totalDirectories; i++) {
				xml.appendChild(_getDirectoryXML(directory.getDirectory(i)));
			}
			var totalFiles:uint = directory.totalFiles;
			for (i = 0; i<totalFiles; i++) {
				xml.appendChild(_getFileXML(directory.getFile(i)));
			}
			return xml;
		}
		private function _getFileName(name:String):String {
			var list:Array = name.split('/');
			return list[list.length-1];
		}
		private function _getFileParent(name:String):String {
			var str:String = _getFileName(name);
			return name.substr(0, name.length-str.length);
		}
		private function _getFileXML(file:ZIPFile):XML {
			var d:Date = new Date(file.time);
			return <file name={file.name} date={d.fullYear+' '+d.month+' '+d.date+' '+d.hours+':'+d.minutes+':'+d.seconds} compressionMethod={file.compressionMethod} deflateCompressionLevel={file.deflateCompressionLevel}></file>;
		}
		private function _isDirectory(name:String):Boolean {
			return name.substr(name.length-1, 1) == '/';
		}
	}
}