package asgl.files {
	import flash.utils.ByteArray;
	
	public class AbstractEncoder extends AbstractFile {
		protected var _bytes:ByteArray;
		public function get bytes():ByteArray {
			return _bytes;
		}
		public override function clear():void {
			super.clear();
			_bytes = null;
		}
	}
}