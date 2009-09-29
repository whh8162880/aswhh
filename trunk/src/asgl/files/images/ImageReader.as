package asgl.files.images {
	import asgl.events.FileEvent;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	public class ImageReader extends AbstractImageReader {
		private var _bitmapData:BitmapData;
		private var _bytes:ByteArray;
		public function ImageReader(bytes:ByteArray=null):void {
			super(bytes);
		}
		public override function read(bytes:ByteArray):void {
			clear();
			_image = new PNGReader(bytes).bitmapData;
			if (_image == null) {
				_image = new DDSReader(bytes).bitmapData;
				if (_image == null) {
					_image = new BMPReader(bytes).bitmapData;
					if (_image == null) {
						_image = new TGAReader(bytes).bitmapData;
						if (_image == null) {
							this.dispatchEvent(new FileEvent(FileEvent.ERROR, new Error('not support')));
						} else {
							_analysisComplete();
						}
					} else {
						_analysisComplete();
					}
				} else {
					_analysisComplete();
				}
			} else {
				_analysisComplete();
			}
		}
		private function _analysisComplete():void {
			_isCorrectFormat = true;
			this.dispatchEvent(new FileEvent(FileEvent.COMPLETE));
		}
	}
}