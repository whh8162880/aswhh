package asgl.buffer {
	import __AS3__.vec.Vector;
	
	import flash.geom.Vector3D;
	
	public class VectorBuffer {
		public var vectors:Vector.<Vector3D>;
		private var _cache:Vector.<Number>;
		public function VectorBuffer(vectors:Vector.<Vector3D>):void {
			this.vectors = vectors;
		}
		public function clear():void {
			_cache = null;
		}
		public function pop():void {
			if (vectors == null || _cache == null) return;
			var length:int = vectors.length;
			for (var i:int = 0; i<length; i++) {
				var v:Vector3D = vectors[i];
				var index:int = i*3;
				v.x = _cache[index];
				v.y = _cache[index+1];
				v.z = _cache[index+2];
			}
		}
		public function push():void {
			if (vectors == null) return;
			var length:int = vectors.length;
			_cache = new Vector.<Number>();
			for (var i:int = 0; i<length; i++) {
				var v:Vector3D = vectors[i];
				var index:int = i*3;
				_cache[index] = v.x;
				_cache[index+1] = v.y;
				_cache[index+2] = v.z;
			}
		}
	}
}