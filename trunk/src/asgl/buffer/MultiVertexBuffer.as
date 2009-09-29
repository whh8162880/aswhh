package asgl.buffer {
	import __AS3__.vec.Vector;
	
	import asgl.math.SpaceType;
	import asgl.math.Vertex3D;
	
	public class MultiVertexBuffer {
		public var channel:uint = 0;
		private var _channelList:Array = [];
		public var vertices:Vector.<Vertex3D>;
		private var _spaceType:String = SpaceType.LOCAL_SPACE;
		public function MultiVertexBuffer(vertices:Vector.<Vertex3D>=null):void {
			this.vertices = vertices;
		}
		public function get hasCache():Boolean {
			return _channelList[channel] != null;
		}
		public function get spaceType():String {
			return _spaceType;
		}
		public function set spaceType(value:String):void {
			if (value == SpaceType.LOCAL_SPACE || value == SpaceType.WORLD_SPACE || value == SpaceType.SCREEN_SPACE || value == SpaceType.CAMERA_SPACE) _spaceType = value;
		}
		public function clear():void {
			delete _channelList[channel];
		}
		public function clearAll():void {
			_channelList = [];
		}
		public function pop():void {
			if (vertices == null) return;
			var cache:Vector.<Number> = _channelList[channel];
			if (cache == null) return;
			var length:int = vertices.length;
			var i:int;
			var v:Vertex3D;
			var index:int;
			if (_spaceType == SpaceType.LOCAL_SPACE) {
				for (i = 0; i<length; i++) {
					v = vertices[i];
					index = i*3;
					v.localX = cache[index];
					v.localY = cache[index+1];
					v.localZ = cache[index+2];
				}
			} else if (_spaceType == SpaceType.WORLD_SPACE) {
				for (i = 0; i<length; i++) {
					v = vertices[i];
					index = i*3;
					v.worldX = cache[index];
					v.worldY = cache[index+1];
					v.worldZ = cache[index+2];
				}
			} else if (_spaceType == SpaceType.SCREEN_SPACE) {
				for (i = 0; i<length; i++) {
					v = vertices[i];
					index = i*3;
					v.screenX = cache[index];
					v.screenY = cache[index+1];
					v.screenZ = cache[index+2];
				}
			} else if (_spaceType == SpaceType.CAMERA_SPACE) {
				for (i = 0; i<length; i++) {
					v = vertices[i];
					index = i*3;
					v.cameraX = cache[index];
					v.cameraY = cache[index+1];
					v.cameraZ = cache[index+2];
				}
			}
		}
		public function push():void {
			if (vertices == null) return;
			var length:int = vertices.length;
			var i:int;
			var v:Vertex3D;
			var cache:Vector.<Number> = new Vector.<Number>();
			var index:int;
			if (_spaceType == SpaceType.LOCAL_SPACE) {
				for (i = 0; i<length; i++) {
					v = vertices[i];
					index = i*3;
					cache[index] = v.localX;
					cache[index+1] = v.localY;
					cache[index+2] = v.localZ;
				}
			} else if (_spaceType == SpaceType.WORLD_SPACE) {
				for (i = 0; i<length; i++) {
					v = vertices[i];
					index = i*3;
					cache[index] = v.worldX;
					cache[index+1] = v.worldY;
					cache[index+2] = v.worldZ;
				}
			} else if (_spaceType == SpaceType.SCREEN_SPACE) {
				for (i = 0; i<length; i++) {
					v = vertices[i];
					index = i*3;
					cache[index] = v.screenX;
					cache[index+1] = v.screenY;
					cache[index+2] = v.screenZ;
				}
			} else if (_spaceType == SpaceType.CAMERA_SPACE) {
				for (i = 0; i<length; i++) {
					v = vertices[i];
					index = i*3;
					cache[index] = v.cameraX;
					cache[index+1] = v.cameraY;
					cache[index+2] = v.cameraZ;
				}
			}
			_channelList[channel] = cache;
		}
	}
}