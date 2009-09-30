package asgl.files.utils.zip {
	public class ZIPDirectory {
		public var dosTime:uint;
		private var _directoryList:Array;
		private var _fileList:Array;
		private var _name:String;
		public function ZIPDirectory():void {
			clear();
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
		public function clear():void {
			_directoryList = [];
			_fileList = [];
			dosTime = 0;
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
	}
}