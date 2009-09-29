package asgl.buffer {
	import __AS3__.vec.Vector;
	
	import asgl.math.SpaceType;
	import asgl.math.Vertex3D;
	
	public class VertexBuffer {
		public var vertices:Vector.<Vertex3D>;
		private var _spaceType:String = SpaceType.LOCAL_SPACE;
		private var _cache:Vector.<Number>;
		public function VertexBuffer(vertices:Vector.<Vertex3D>=null):void {
			this.vertices = vertices;
		}
		public function get spaceType():String {
			return _spaceType;
		}
		public function set spaceType(value:String):void {
			if (value == SpaceType.LOCAL_SPACE || value == SpaceType.WORLD_SPACE || value == SpaceType.SCREEN_SPACE || value == SpaceType.CAMERA_SPACE) _spaceType = value;
		}
		public function clear():void {
			_cache = null;
		}
		public function pop():void {
			if (vertices == null || _cache == null) return;
			var length:int = vertices.length;
			var i:int;
			var v:Vertex3D;
			var index:int;
			if (_spaceType == SpaceType.LOCAL_SPACE) {
				for (i = 0; i<length; i++) {
					index  = i*3;
					v = vertices[i];
					v.localX = _cache[index];
					v.localY = _cache[index+1];
					v.localZ = _cache[index+2];
				}
			} else if (_spaceType == SpaceType.WORLD_SPACE) {
				for (i = 0; i<length; i++) {
					index  = i*3;
					v = vertices[i];
					v.worldX = _cache[index];
					v.worldY = _cache[index+1];
					v.worldZ = _cache[index+2];
				}
			} else if (_spaceType == SpaceType.SCREEN_SPACE) {
				for (i = 0; i<length; i++) {
					index  = i*3;
					v = vertices[i];
					v.screenX = _cache[index];
					v.screenY = _cache[index+1];
					v.screenZ = _cache[index+2];
				}
			} else if (_spaceType == SpaceType.CAMERA_SPACE) {
				for (i = 0; i<length; i++) {
					index  = i*3;
					v = vertices[i];
					v.cameraX = _cache[index];
					v.cameraY = _cache[index+1];
					v.cameraZ = _cache[index+2];
				}
			}
		}
		public function push():void {
			if (vertices == null) return;
			var length:int = vertices.length;
			var i:int;
			var v:Vertex3D;
			var index:int;
			_cache = new Vector.<Number>();
			if (_spaceType == SpaceType.LOCAL_SPACE) {
				for (i = 0; i<length; i++) {
					v = vertices[i];
					index = i*3;
					_cache[index] = v.localX;
					_cache[index+1] = v.localY;
					_cache[index+2] = v.localZ;
				}
			} else if (_spaceType == SpaceType.WORLD_SPACE) {
				for (i = 0; i<length; i++) {
					v = vertices[i];
					index = i*3;
					_cache[index] = v.worldX;
					_cache[index+1] = v.worldY;
					_cache[index+2] = v.worldZ;
				}
			} else if (_spaceType == SpaceType.SCREEN_SPACE) {
				for (i = 0; i<length; i++) {
					v = vertices[i];
					index = i*3;
					_cache[index] = v.screenX;
					_cache[index+1] = v.screenY;
					_cache[index+2] = v.screenZ;
				}
			} else if (_spaceType == SpaceType.CAMERA_SPACE) {
				for (i = 0; i<length; i++) {
					v = vertices[i];
					index = i*3;
					_cache[index] = v.cameraX;
					_cache[index+1] = v.cameraY;
					_cache[index+2] = v.cameraZ;
				}
			}
		}
	}
}