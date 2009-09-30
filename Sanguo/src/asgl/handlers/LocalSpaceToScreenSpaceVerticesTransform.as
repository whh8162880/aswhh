package asgl.handlers {
	import __AS3__.vec.Vector;
	
	import asgl.cameras.Camera3D;
	import asgl.drivers.AbstractRenderDriver;
	import asgl.lights.AbstractLight;
	import asgl.math.Coordinates3DContainer;
	import asgl.math.GLMatrix3D;
	import asgl.math.Vertex3D;
	import asgl.mesh.TriangleFace;
	
	import flash.utils.Dictionary;
	
	public class LocalSpaceToScreenSpaceVerticesTransform implements IHandler {
		protected var _coordMap:Dictionary = new Dictionary();
		public function addCoordinates(coord:Coordinates3DContainer):void {
			if (_coordMap[coord] == null) _coordMap[coord] = Vector.<Vertex3D>;
		}
		public function addVertex(coord:Coordinates3DContainer, vertex:Vertex3D):void {
			var vList:Vector.<Vertex3D> = _coordMap[coord];
			if (vList == null) {
				vList = new Vector.<Vertex3D>();
				_coordMap[coord] = vList;
			}
			vList.push(vertex);
		}
		public function addVertices(coord:Coordinates3DContainer, vertices:Vector.<Vertex3D>):void {
			var vList:Vector.<Vertex3D> = _coordMap[coord];
			if (vList == null) {
				_coordMap[coord] = vertices.concat();
			} else {
				_coordMap[coord] = vList.concat(vertices);
			}
		}
		public function clearAll():void {
			_coordMap = new Dictionary();
		}
		public function clearCoordinates(coord:Coordinates3DContainer):void {
			if (_coordMap[coord] != null) delete _coordMap[coord];
		}
		public function clearVertices(coord:Coordinates3DContainer):void {
			var list:Vector.<Vertex3D> = _coordMap[coord];
			if (list == null) return;
			_coordMap[coord] = new Vector.<Vertex3D>();
		}
		public function handle(driver:AbstractRenderDriver, faces:Vector.<TriangleFace>, completeFucntion:Function):void {
			var screenMatrix:GLMatrix3D = driver.camera.screenMatrix;
			for (var coord:* in _coordMap) {
				var m:GLMatrix3D = coord.worldMatrix;
				m.concat(screenMatrix);
				var list:Vector.<Vertex3D> = _coordMap[coord];
				var length:int = list.length;
				for (var i:int = 0; i<length; i++) {
					var v:Vertex3D = list[i];
					v.screenX = v.localX*m.a+v.localY*m.b+v.localZ*m.c+m.tx;
					v.screenY = v.localX*m.d+v.localY*m.e+v.localZ*m.f+m.ty;
					v.screenZ = v.localX*m.g+v.localY*m.h+v.localZ*m.i+m.tz;
				}
			}
			if (driver.lights != null) {
				var lights:Vector.<AbstractLight> = driver.lights;
				for (var j:int = lights.length-1; j>=0; j--) {
					lights[j].transformScreenSpace(screenMatrix);
				}
			}
			completeFucntion(faces);
		}
		public function removeVertex(coord:Coordinates3DContainer, vertex:Vertex3D):Boolean {
			var list:Vector.<Vertex3D> = _coordMap[coord];
			if (list == null) return false;
			var index:int = list.indexOf(vertex);
			if (index == -1) return false;
			list.splice(index, 1);
			return true;
		}
		public function removeVertexAt(coord:Coordinates3DContainer, index:uint):Vertex3D {
			var list:Vector.<Vertex3D> = _coordMap[coord];
			if (list == null) return null;
			var vertex:Vertex3D = list[index];
			if (vertex == null) return null;
			list.splice(index, 1);
			return vertex;
		}
		public function removeVertices(coord:Coordinates3DContainer, vertex:Vertex3D, length:uint=1):Vector.<Vertex3D> {
			if (length == 0) return new Vector.<Vertex3D>();
			var list:Vector.<Vertex3D> = _coordMap[coord];
			if (list == null) return new Vector.<Vertex3D>();
			var index:int = list.indexOf(vertex);
			if (index == -1) return new Vector.<Vertex3D>();
			return list.splice(index, length);
		}
		public function removeVerticesAt(coord:Coordinates3DContainer, index:uint, length:uint=1):Vector.<Vertex3D> {
			if (length == 0) return new Vector.<Vertex3D>();
			var list:Vector.<Vertex3D> = _coordMap[coord];
			if (list == null || index>=list.length) return new Vector.<Vertex3D>();
			return list.splice(index, length);
		}
	}
}