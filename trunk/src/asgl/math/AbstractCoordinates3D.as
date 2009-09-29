package asgl.math {
	import __AS3__.vec.Vector;
	
	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;
	public class AbstractCoordinates3D extends EventDispatcher {
		private static var _idManager:Number = 0;
		public var autoRefreshEnabled:Boolean = true;
		/**
		 * [read only]
		 */
		public var id:Number;
		public var name:String;
		protected namespace hide;
		protected var _parent:Coordinates3DContainer = null;
		private var _root:AbstractCoordinates3D;
		protected var _isWorld:Boolean = false;
		protected var _localTransformMatrix:GLMatrix3D = new GLMatrix3D();
		protected var _parentTransformMatrix:GLMatrix3D = new GLMatrix3D();
		protected var _sendTransformMatrix:GLMatrix3D = new GLMatrix3D();
		protected var _tempMatrix:GLMatrix3D = new GLMatrix3D();
		protected var _childrenList:Vector.<AbstractCoordinates3D> = new Vector.<AbstractCoordinates3D>();
		protected var _position:Vertex3D = new Vertex3D();
		public function AbstractCoordinates3D(position:Vertex3D=null):void {
			if (position != null) {
				_localTransformMatrix.tx = position.localX;
				_localTransformMatrix.ty = position.localY;
				_localTransformMatrix.tz = position.localZ;
			}
			_sendTransformMatrix.copy(_localTransformMatrix);
			_sendTransformMatrix.concat(_parentTransformMatrix);
			_root = this;
			id = _idManager;
			_idManager++;
		}
		/**
		 * return a new matrix3D;
		 */
		public function get localMatrix():GLMatrix3D {
			return _localTransformMatrix.clone();
		}
		public function set localMatrix(value:GLMatrix3D):void {
			_localTransformMatrix.copy(value);
			if (autoRefreshEnabled) refresh();
		}
		public function set localRotationX(value:Number):void {
			_localTransformMatrix.rotationX = value;
			if (autoRefreshEnabled) refresh();
		}
		public function set localRotationY(value:Number):void {
			_localTransformMatrix.rotationY = value;
			if (autoRefreshEnabled) refresh();
		}
		public function set localRotationZ(value:Number):void {
			_localTransformMatrix.rotationZ = value;
			if (autoRefreshEnabled) refresh();
		}
		public function set localTranslateX(value:Number):void {
			_localTransformMatrix.translateX = value;
			if (autoRefreshEnabled) refresh();
		}
		public function set localTranslateY(value:Number):void {
			_localTransformMatrix.translateY = value;
			if (autoRefreshEnabled) refresh();
		}
		public function set localTranslateZ(value:Number):void {
			_localTransformMatrix.translateZ = value;
			if (autoRefreshEnabled) refresh();
		}
		public function get localX():Number {return _localTransformMatrix.tx;}
		public function set localX(value:Number):void {
			_localTransformMatrix.tx = value;
			if (autoRefreshEnabled) refresh();
		}
		public function get localY():Number {return _localTransformMatrix.ty;}
		public function set localY(value:Number):void {
			_localTransformMatrix.ty = value;
			if (autoRefreshEnabled) refresh();
		}
		public function get localZ():Number {return _localTransformMatrix.tz;}
		public function set localZ(value:Number):void {
			_localTransformMatrix.tz = value;
			if (autoRefreshEnabled) refresh();
		}
		public function get parent():Coordinates3DContainer {
			return _parent;
		}
		hide function set parent(value:Coordinates3DContainer):void {
			_parent = value;
			if (_parent == null) hide::inceptMatrix(new GLMatrix3D());
		}
		/**
		 * return a new vertex;
		 */
		public function get position():Vertex3D {
			var p:Vertex3D = _position.cloneWorld();
			p.localX = _localTransformMatrix.tx;
			p.localY = _localTransformMatrix.ty;
			p.localZ = _localTransformMatrix.tz;
			return p;
		}
		public function get root():AbstractCoordinates3D {
			return _root;
		}
		hide function set root(value:AbstractCoordinates3D):void {
			_root = value;
			var length:int = _childrenList.length;
			for (var i:int = 0; i<length; i++) {
				_childrenList[i].hide::root = _root;
			}
		}
		public function get world():Coordinates3D {
			if (_root.worldEnabled) {
				return _root as Coordinates3D;
			} else {
				return null;
			}
		}
		public function get worldEnabled():Boolean {return _isWorld;}
		/**
		 * return a new matrix3D;
		 */
		public function get worldMatrix():GLMatrix3D {
			_tempMatrix.copy(_localTransformMatrix);
			_tempMatrix.concat(_parentTransformMatrix);
			return _tempMatrix.clone();
		}
		public function set worldMatrix(value:GLMatrix3D):void {
			value = value.clone();
			_tempMatrix.copy(_parentTransformMatrix);
			_tempMatrix.invert();
			value.concat(_tempMatrix);
			_localTransformMatrix = value;
			if (autoRefreshEnabled) refresh();
		}
		public function set worldRotationX(value:Number):void {
			var m:GLMatrix3D = this.worldMatrix;
			m.rootRotationX = value;
			_tempMatrix.copy(_parentTransformMatrix);
			_tempMatrix.invert();
			m.concat(_tempMatrix);
			_localTransformMatrix = m;
			if (autoRefreshEnabled) refresh();
		}
		public function set worldRotationY(value:Number):void {
			var m:GLMatrix3D = this.worldMatrix;
			m.rootRotationY = value;
			_tempMatrix.copy(_parentTransformMatrix);
			_tempMatrix.invert();
			m.concat(_tempMatrix);
			_localTransformMatrix = m;
			if (autoRefreshEnabled) refresh();
		}
		public function set worldRotationZ(value:Number):void {
			var m:GLMatrix3D = this.worldMatrix;
			m.rootRotationZ = value;
			_tempMatrix.copy(_parentTransformMatrix);
			_tempMatrix.invert();
			m.concat(_tempMatrix);
			_localTransformMatrix = m;
			if (autoRefreshEnabled) refresh();
		}
		public function get worldX():Number {return _position.worldX;}
		public function set worldX(value:Number):void {
			var m:GLMatrix3D = this.worldMatrix;
			m.tx = value;
			_tempMatrix.copy(_parentTransformMatrix);
			_tempMatrix.invert();
			m.concat(_tempMatrix);
			_localTransformMatrix = m;
			if (autoRefreshEnabled) refresh();
		}
		public function get worldY():Number {return _position.worldY;}
		public function set worldY(value:Number):void {
			var m:GLMatrix3D = this.worldMatrix;
			m.ty = value;
			_tempMatrix.copy(_parentTransformMatrix);
			_tempMatrix.invert();
			m.concat(_tempMatrix);
			_localTransformMatrix = m;
			if (autoRefreshEnabled) refresh();
		}
		public function get worldZ():Number {return _position.worldZ;}
		public function set worldZ(value:Number):void {
			var m:GLMatrix3D = this.worldMatrix;
			m.tz = value;
			_tempMatrix.copy(_parentTransformMatrix);
			_tempMatrix.invert();
			m.concat(_tempMatrix);
			_localTransformMatrix = m;
			if (autoRefreshEnabled) refresh();
		}
		public function destroy():void {
			if (parent != null) parent.removeChild(this);
			_parent = null;
			_root = null;
			_childrenList = null;
			_localTransformMatrix = null;
			_parentTransformMatrix = null;
			_sendTransformMatrix = null;
			_tempMatrix = null;
			_position = null;
		}
		hide function inceptMatrix(parentMatrix:GLMatrix3D):void {
			_parentTransformMatrix.copy(parentMatrix);
			if (autoRefreshEnabled) refresh();
		}
		public function localLocation(x:Number = 0, y:Number = 0, z:Number = 0):void {
			_localTransformMatrix.tx = x;
			_localTransformMatrix.ty = y;
			_localTransformMatrix.tz = z;
			if (autoRefreshEnabled) refresh();
		}
		/**
		 * @param v the v is a normalize Vector.
		 */
		public function localRotationAxis(v:Vector3D, angle:Number):void {
			var q:Quaternion = new Quaternion();
			q.setValue(v, angle);
			_tempMatrix.copy(q.matrix);
			_tempMatrix.concat(_localTransformMatrix);
			_localTransformMatrix.copy(_tempMatrix);
			if (autoRefreshEnabled) refresh();
		}
		public function localTranslate(x:Number=0, y:Number=0, z:Number=0):void {
			_localTransformMatrix.translate(x, y, z);
			if (autoRefreshEnabled) refresh();
		}
		public function refresh(send:Boolean=true):void {
			if (send) this.send();
			_verticesRefresh();
		}
		public function reset():void {
			this.localMatrix = new GLMatrix3D();
		}
		public function send():void {
			_sendTransformMatrix.copy(_localTransformMatrix);
			_sendTransformMatrix.concat(_parentTransformMatrix);
			var length:int = _childrenList.length;
			for (var i:int = 0; i<length; i++) {
				_childrenList[i].hide::inceptMatrix(_sendTransformMatrix);
			}
		}
		public function worldLocation(x:Number=0, y:Number=0, z:Number=0):void {
			var m:GLMatrix3D = this.worldMatrix;
			m.tx = x;
			m.ty = y;
			m.tz = z;
			_tempMatrix.copy(_parentTransformMatrix);
			_tempMatrix.invert();
			m.concat(_tempMatrix);
			_localTransformMatrix = m;
			if (autoRefreshEnabled) refresh();
		}
		public function worldRotationAxis(v0:Vertex3D, v1:Vertex3D, angle:Number):void {
			var vec0:Vector3D = new Vector3D(v1.worldX-v0.worldX, v1.worldY-v0.worldY, v1.worldZ-v0.worldZ);
			vec0.normalize();
			var vec1:Vector3D = new Vector3D();
			if (vec0.z == 0) {
				vec1.x = 0;
				vec1.y = 0;
				vec1.z = 1;
			} else {
				vec1.x = 1;
				vec1.y = 1;
				vec1.z = -(vec0.x+vec0.y+Math.cos(Math.PI/2))/vec0.z;
				vec1.normalize();
			}
			var vec2:Vector3D = new Vector3D(vec0.z*vec1.y-vec0.y*vec1.z, vec0.x*vec1.z-vec0.z*vec1.x, vec0.y*vec1.x-vec0.x*vec1.y);
			vec2.normalize();
			var m:GLMatrix3D = new GLMatrix3D(vec1.x, vec0.x, vec2.x, vec1.y, vec0.y, vec2.y, vec1.z, vec0.z, vec2.z, v0.worldX, v0.worldY, v0.worldZ);
			var m2:GLMatrix3D = m.clone();//world
			m.invert();
			var m3:GLMatrix3D = this.root.worldMatrix;
			var m4:GLMatrix3D = m3.clone();//parent world
			m3.invert();
			m2.concat(m3);//local
			m2.rotationY = angle;
			m2.concat(m4);
			m.concat(m2);
			var v:Vector3D = new Vector3D(m2.b, m2.e, m2.h);
			v.normalize();
			var q:Quaternion = new Quaternion();
			q.setValue(v, angle);
			m2 = this.worldMatrix;
			m2.concat(q.matrix);
			var wx:Number = _position.worldX;
			var wy:Number = _position.worldY;
			var wz:Number = _position.worldZ;
			m2.tx = wx*m.a+wy*m.b+wz*m.c+m.tx;
			m2.ty = wx*m.d+wy*m.e+wz*m.f+m.ty;
			m2.tz = wx*m.g+wy*m.h+wz*m.i+m.tz;
			_tempMatrix.copy(_parentTransformMatrix);
			_tempMatrix.invert();
			m2.concat(_tempMatrix);
			_localTransformMatrix = m2;
			if (autoRefreshEnabled) refresh();
		}
		public function worldTranslate(x:Number=0, y:Number=0, z:Number=0):void {
			var m:GLMatrix3D = this.worldMatrix;
			m.tx = _position.worldX+x;
			m.ty = _position.worldY+y;
			m.tz = _position.worldZ+z;
			_tempMatrix.copy(_parentTransformMatrix);
			_tempMatrix.invert();
			m.concat(_tempMatrix);
			_localTransformMatrix = m;
			if (autoRefreshEnabled) refresh();
		}
		protected function _verticesRefresh():void {
			var m:GLMatrix3D = this.worldMatrix;
			_position.worldX = m.tx;
			_position.worldY = m.ty;
			_position.worldZ = m.tz;
		}
	}
}