package asgl.files.images {
	import asgl.files.AbstractFile;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	public class AbstractImageReader extends AbstractFile {
		protected var _image:BitmapData;
		public function AbstractImageReader(bytes:ByteArray = null):void {
			if (bytes == null) {
				clear();
			} else {
				read(bytes);
			}
		}
		public function get bitmapData():BitmapData {
			return _image;
		}
		public override function clear():void {
			super.clear();
			_image = null;
		}
		public function read(bytes:ByteArray):void {
		}
	}
}