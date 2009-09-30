package asgl.data.indices {
	
	public class FaceUVIndex {
		private var _index1:int;
		private var _index2:int;
		private var _index3:int;
		private var _offset:int;
		public function FaceUVIndex(index1:int, index2:int, index3:int, offset:int=0):void {
			_offset = offset;
			_index1 = index1+_offset;
			_index2 = index2+_offset;
			_index3 = index3+_offset;
		}
		public function get offset():int {
			return _offset;
		}
		public function set offset(value:int):void {
			if (_offset == value) return;
			var temp:int = _offset;
			_offset = value;
			temp = _offset-temp;
			_index1 += temp;
			_index2 += temp;
			_index3 += temp;
		}
		public function coordinatesTransform():void {
			flip();
		}
		public function flip():void {
			var temp:int = _index1;
			_index1 = _index2;
			_index2 = temp;
		}
		/**
		 * @param index the value is 0, 1, 2.
		 */
		public function getIndex(index:int):int {
			if (index == 0) {
				return _index1;
			} else if (index == 1) {
				return _index2;
			} else {
				return _index3;
			}
		}
		public function toString():String {
			return _index1+', '+_index2+', '+_index3;
		}
	}
}