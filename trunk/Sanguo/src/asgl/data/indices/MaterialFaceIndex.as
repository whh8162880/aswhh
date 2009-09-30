package asgl.data.indices {
	import __AS3__.vec.Vector;
	
	public class MaterialFaceIndex {
		public var materialName:String;
		private var _offset:int;
		private var _list:Vector.<uint> = new Vector.<uint>();
		public function MaterialFaceIndex(materialName:String = null, offset:int=0):void {
			this.materialName = materialName;
			_offset = offset;
		}
		public function get faceIndexLength():int {
			return _list.length;
		}
		public function get offset():int {
			return _offset;
		}
		public function set offset(value:int):void {
			if (_offset == value) return;
			var temp:int = _offset;
			_offset = value;
			temp = _offset-temp;
			for (var i:int = _list.length-1; i>=0; i--) {
				_list[i] += temp;
			}
		}
		public function addIndex(index:uint):void {
			_list.push(index+_offset);
		}
		public function getIndex(index:uint):uint {
			return _list[index];
		}
	}
}