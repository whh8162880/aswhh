package asgl.math {
	import __AS3__.vec.Vector;
	
	public class Coordinates3DContainer extends AbstractCoordinates3D {
		protected var _tempVerticesLocalValueList:Vector.<Number>;
		protected var _verticesList:Vector.<Vertex3D> = new Vector.<Vertex3D>();
		public function Coordinates3DContainer(position:Vertex3D=null):void {
			super(position);
		}
		public function get totalChildren():uint {
			return _childrenList.length;
		}
		public function get totalVertexes():uint {
			return _verticesList.length;
		}
		public function addChild(child:AbstractCoordinates3D, isRefresh:Boolean=true):Boolean {
			if (!child.worldEnabled && child.parent == null) {
				_childrenList.push(child);
				child.hide::parent = this;
				child.hide::root = this.root;
				if (isRefresh) child.hide::inceptMatrix(_sendTransformMatrix);
				return true;
			} else {
				return false;
			}
		}
		public function addVertex(vertex:Vertex3D, isRefresh:Boolean=true):void {
			_verticesList.push(vertex);
			_tempVerticesLocalValueList = null;
			if (isRefresh) vertex.transformWorldSpace(this.worldMatrix);
		}
		public function addVertexSecurity(vertex:Vertex3D, isRefresh:Boolean=true):Boolean {
			if (_verticesList.indexOf(vertex) == -1) {
				_verticesList.push(vertex);
				_tempVerticesLocalValueList = null;
				if (isRefresh) vertex.transformWorldSpace(this.worldMatrix);
				return true;
			}
			return false;
		}
		public function addVertices(vertices:Vector.<Vertex3D>, isRefresh:Boolean=true):void {
			if (vertices == null) return;
			var length:int = vertices.length;
			var i:int;
			if (isRefresh) {
				var m:GLMatrix3D = this.worldMatrix;
				var vertex:Vertex3D;
				for (i = 0; i<length; i++) {
					vertex = vertices[i];
					_verticesList.push(vertex);
					vertex.transformWorldSpace(m);
				}
			} else {
				for (i = 0; i<length; i++) {
					_verticesList.push(vertices[i]);
				}
			}
			if (length>0) _tempVerticesLocalValueList = null;
		}
		public function addVerticesSecurity(vertices:Vector.<Vertex3D>, isRefresh:Boolean=true):Vector.<Vertex3D> {
			var length:int = vertices.length;
			var i:int;
			var vertex:Vertex3D;
			var noAdd:Vector.<Vertex3D> = new Vector.<Vertex3D>();
			if (isRefresh) {
				var m:GLMatrix3D = this.worldMatrix;
				for (i = 0; i<length; i++) {
					vertex = vertices[i];
					if (_verticesList.indexOf(vertex) == -1) {
						_verticesList.push(vertex);
						vertex.transformWorldSpace(m);
					} else {
						noAdd.push(vertex);
					}
				}
			} else {
				for (i = 0; i<length; i++) {
					vertex = vertices[i];
					if (_verticesList.indexOf(vertex) == -1) {
						_verticesList.push(vertex);
					} else {
						noAdd.push(vertex);
					}
				}
			}
			if (length>0 && noAdd.length != length) _tempVerticesLocalValueList = null;
			return noAdd;
		}
		public function clearChildren():void {
			for (var i:int = _childrenList.length-1; i>=0; i--) {
				removeChild(_childrenList[i]);
			}
		}
		public function clearVertices():void {
			_verticesList = new Vector.<Vertex3D>();
			_tempVerticesLocalValueList = null;
		}
		public function containChild(child:AbstractCoordinates3D):Boolean {
			return _childrenList.indexOf(child) != -1;
		}
		public function containVertex(vertex:Vertex3D):Boolean {
			return _verticesList.indexOf(vertex) != -1;
		}
		public override function destroy():void {
			clearChildren();
			clearVertices();
			super.destroy();
			_verticesList = null;
			_tempVerticesLocalValueList = null;
		}
		public function getAllVertices():Vector.<Vertex3D> {
			return _verticesList.concat();
		}
		public function getChildAt(index:uint):AbstractCoordinates3D {
			return _childrenList[index];
		}
		public function getVertexAt(index:uint):Vertex3D {
			return _verticesList[index];
		}
		public function getVertices(vertex:Vertex3D, length:int=1):Vector.<Vertex3D> {
			var index:int = _verticesList.indexOf(vertex);
			if (index<=0) return new Vector.<Vertex3D>();
			return _verticesList.slice(index, index+length);
		}
		public function getVerticesAt(index:int, length:int=1):Vector.<Vertex3D> {
			if (index<0) return new Vector.<Vertex3D>();
			return _verticesList.slice(index, index+length);
		}
		public function popVerticesLocalValue(isRefresh:Boolean=true):Boolean {
			if (_tempVerticesLocalValueList == null) return false;
			var length:int = _verticesList.length;
			var index:int = 0;
			for (var i:int = 0; i<length; i++) {
				var v:Vertex3D = _verticesList[i];
				v.localX = _tempVerticesLocalValueList[index++];
				v.localY = _tempVerticesLocalValueList[index++];
				v.localZ = _tempVerticesLocalValueList[index++];
			}
			_tempVerticesLocalValueList = null;
			if (isRefresh) refresh();
			return true;
		}
		public function pushVerticesLocalValue():void {
			_tempVerticesLocalValueList = new Vector.<Number>();
			var length:int = _verticesList.length;
			for (var i:int = 0; i<length; i++) {
				var v:Vertex3D = _verticesList[i];
				_tempVerticesLocalValueList.push(v.localX, v.localY, v.localZ);
			}
		}
		public function removeChild(child:AbstractCoordinates3D):Boolean {
			var index:int = _childrenList.indexOf(child);
			if (index == -1) return false;
			_childrenList.splice(index, 1);
			child.hide::parent = null;
			child.hide::root = child;
			return true;
		}
		public function removeChildAt(index:uint):AbstractCoordinates3D {
			var child:AbstractCoordinates3D = _childrenList[index];
			if (child == null) return null;
			_childrenList.splice(index, 1);
			child.hide::parent = null;
			child.hide::root = child;
			return child;
		}
		public function removeVertex(vertex:Vertex3D):Boolean {
			var index:int = _verticesList.indexOf(vertex);
			if (index == -1) return false;
			_verticesList.splice(index, 1);
			_tempVerticesLocalValueList = null;
			return true;
		}
		public function removeVertexAt(index:uint):Vertex3D {
			var vertex:Vertex3D = _verticesList[index];
			if (vertex == null) return null;
			_verticesList.splice(index, 1);
			_tempVerticesLocalValueList = null;
			return vertex;
		}
		public function removeVertices(vertex:Vertex3D, length:uint=1):Vector.<Vertex3D> {
			if (length == 0) return new Vector.<Vertex3D>();
			var index:int = _verticesList.indexOf(vertex);
			if (index == -1) return new Vector.<Vertex3D>();
			var list:Vector.<Vertex3D> = _verticesList.splice(index, length);
			_tempVerticesLocalValueList = null;
			return list;
		}
		public function removeVerticesAt(index:uint, length:uint=1):Vector.<Vertex3D> {
			if (length == 0) return new Vector.<Vertex3D>();
			var vertex:Vertex3D = _verticesList[index];
			if (vertex == null) return new Vector.<Vertex3D>();
			var list:Vector.<Vertex3D> = _verticesList.splice(index, length);
			_tempVerticesLocalValueList = null;
			return list;
		}
		public function scaleVerticesLocalValue(sx:Number, sy:Number, sz:Number):void {
			var length:int = _verticesList.length;
			for (var i:int = 0; i<length; i++) {
				var v:Vertex3D = _verticesList[i];
				v.localX *= sx;
				v.localY *= sy;
				v.localZ *= sz;
			}
		}
		protected override function _verticesRefresh():void {
			var m:GLMatrix3D = this.worldMatrix;
			_position.worldX = m.tx;
			_position.worldY = m.ty;
			_position.worldZ = m.tz;
			var length:int = _verticesList.length;
			for (var i:int = 0; i<length; i++) {
				var v:Vertex3D = _verticesList[i];
				//use Vertex transformWorldSpace method
				v.worldX = v.localX*m.a+v.localY*m.b+v.localZ*m.c+m.tx;
				v.worldY = v.localX*m.d+v.localY*m.e+v.localZ*m.f+m.ty;
				v.worldZ = v.localX*m.g+v.localY*m.h+v.localZ*m.i+m.tz;
				//
			}
		}
	}
}