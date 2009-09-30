package asgl.bones {
	import __AS3__.vec.Vector;
	
	import asgl.data.indices.FaceVertexIndex;
	import asgl.math.Coordinates3D;
	import asgl.math.GLMatrix3D;
	import asgl.math.Vertex3D;
	import asgl.mesh.MeshObject;
	
	import flash.geom.Vector3D;
	
	public class EntityBone extends Bone {
		public static const ENTITY_FACES_AMOUNT:int = 14;
		public static const DEFAULT_ENTITY_COLOR:uint = 0xFFAEBACB;
		private static const PI_TO_ANGLE:Number = 180/Math.PI;
		private var _entityCoord:Coordinates3D = new Coordinates3D();
		private var _meshObject:MeshObject = new MeshObject();
		private var _tempEntityVerticesLocalValueList:Vector.<Number>;
		private var _entityVerticesList:Vector.<Vertex3D> = new Vector.<Vertex3D>();
		private var _entityDirection:Vector3D = new Vector3D(0, 0, 1);
		public function EntityBone(position:Vertex3D=null):void {
			super(position);
			_meshObject.content = this;
		}
		public function get entity():MeshObject {
			return _meshObject;
		}
		public function get entitiesWithChildren():Vector.<MeshObject> {
			var list:Vector.<MeshObject> = new Vector.<MeshObject>();
			var length:int = _childrenList.length;
			for (var i:int = 0; i<length; i++) {
				_getChildEntity(list, this.getChildAt(i) as Bone);
			}
			return list;
		}
		public function get entityDirection():Vector3D {
			return _entityDirection.clone();
		}
		public function set entityDirection(value:Vector3D):void {
			if (value == null) return;
			_entityDirection.x = value.x;
			_entityDirection.y = value.y;
			_entityDirection.z = value.z;
			_entityCoord.reset();
			_entityCoord.localRotationY = Math.atan2(_entityDirection.x, _entityDirection.z)*PI_TO_ANGLE;
			var angle:Number = Math.acos(Math.sqrt(_entityDirection.x*_entityDirection.x+_entityDirection.z*_entityDirection.z)/_entityDirection.length)*PI_TO_ANGLE;
			if (_entityDirection.y>0) {
				if (angle>0) angle *= -1;
			} else if (angle<0) {
				angle *= -1;
			}
			_entityCoord.localRotationX = angle;
			_transformEntityDirection();
		}
		public function clearEntity():void {
			if (_entityVerticesList.length>0) {
				_entityVerticesList = new Vector.<Vertex3D>();
				_tempVerticesLocalValueList = null;
				_tempEntityVerticesLocalValueList = null;
			}
		}
		public function createEntity(width:Number, height:Number, taper:Number=0.9, direction:Vector3D=null, color:uint=DEFAULT_ENTITY_COLOR, includeChildren:Boolean=true, childrenWHScale:Number=0.9):void {
			if (direction != null) this.entityDirection = direction;
			var absW:Number = width<0 ? -width : width;
			var absH:Number = height<0 ? -height : height;
			var d:Number = (absH<absW ? absW : absH)*0.7;
			var length:int = _childBonesList.length;
			var halfW:Number = width/2;
			var halfH:Number = height/2;
			var k:Number = 1-taper;
			var v0:Vertex3D = new Vertex3D();
			var v1:Vertex3D = new Vertex3D(-halfW, halfH, d);
			var v2:Vertex3D = new Vertex3D(halfW, halfH, d);
			var v3:Vertex3D = new Vertex3D(halfW, -halfH, d);
			var v4:Vertex3D = new Vertex3D(-halfW, -halfH, d);
			var vector:Vector3D;
			if (length == 1 || (length>0 && _childrenCoordEqualsTest())) {
				var child:Bone = _childBonesList[0];
				vector = new Vector3D(child.localX, child.localY, child.localZ);
				d = vector.length;
			} else {
				d *= 2;
			}
			var v5:Vertex3D = new Vertex3D(-halfW*k, halfH*k, d);
			var v6:Vertex3D = new Vertex3D(halfW*k, halfH*k, d);
			var v7:Vertex3D = new Vertex3D(halfW*k, -halfH*k, d);
			var v8:Vertex3D = new Vertex3D(-halfW*k, -halfH*k, d);
			_entityVerticesList[0] = v0;
			_entityVerticesList[1] = v1;
			_entityVerticesList[2] = v2;
			_entityVerticesList[3] = v3;
			_entityVerticesList[4] = v4;
			_entityVerticesList[5] = v5;
			_entityVerticesList[6] = v6;
			_entityVerticesList[7] = v7;
			_entityVerticesList[8] = v8;
			_transformEntityDirection();
			_meshObject.color = color;
			var list:Vector.<Vertex3D> = _meshObject.vertices;
			list[0] = v0;
			list[1] = v1;
			list[2] = v2;
			list[3] = v3;
			list[4] = v4;
			list[5] = v5;
			list[6] = v6;
			list[7] = v7;
			list[8] = v8;
			var list2:Vector.<FaceVertexIndex> = _meshObject.faceVertexIndices;
			list2[0] = new FaceVertexIndex(0, 1, 2);
			list2[1] = new FaceVertexIndex(0, 2, 3);
			list2[2] = new FaceVertexIndex(0, 3, 4);
			list2[3] = new FaceVertexIndex(0, 4, 1);
			list2[4] = new FaceVertexIndex(1, 5, 6);
			list2[5] = new FaceVertexIndex(1, 6, 2);
			list2[6] = new FaceVertexIndex(2, 6, 7);
			list2[7] = new FaceVertexIndex(2, 7, 3);
			list2[8] = new FaceVertexIndex(3, 7, 8);
			list2[9] = new FaceVertexIndex(3, 8, 4);
			list2[10] = new FaceVertexIndex(4, 8, 5);
			list2[11] = new FaceVertexIndex(4, 5, 1);
			list2[12] = new FaceVertexIndex(5, 8, 7);
			list2[13] = new FaceVertexIndex(5, 7, 6);
			_tempVerticesLocalValueList = null;
			_tempEntityVerticesLocalValueList = null;
			if (includeChildren) {
				for (var i:int = 0; i<length; i++) {
					var cw:Number = width*childrenWHScale;
					var ch:Number = height*childrenWHScale;
					var childBone:EntityBone = _childBonesList[i] as EntityBone;
					if (childBone != null) childBone.createEntity(cw, ch, taper, direction, color, true, childrenWHScale);
				}
			}
		}
		public override function destroy():void {
			super.destroy();
			_entityVerticesList = null;
			_entityCoord.destroy();
			_entityCoord = null;
			_meshObject = null;
			_entityDirection = null;
			_tempEntityVerticesLocalValueList = null;
		}
		public override function popVerticesLocalValue(isRefresh:Boolean=true):Boolean {
			var b:Boolean = super.popVerticesLocalValue();
			if (b) {
				var length:int = _entityVerticesList.length;
				var index:int = 0;
				for (var i:int = 1; i<length; i++) {
					var v:Vertex3D = _entityVerticesList[i];
					v.localX = _tempEntityVerticesLocalValueList[index++];
					v.localY = _tempEntityVerticesLocalValueList[index++];
					v.localZ = _tempEntityVerticesLocalValueList[index++];
				}
				_tempEntityVerticesLocalValueList = null;
			}
			if (isRefresh) refresh();
			return b;
		}
		public override function pushVerticesLocalValue():void {
			super.pushVerticesLocalValue();
			_tempEntityVerticesLocalValueList = new Vector.<Number>();
			var length:int = _entityVerticesList.length;
			for (var i:int = 1; i<length; i++) {
				var v:Vertex3D = _entityVerticesList[i];
				_tempEntityVerticesLocalValueList.push(v.localX, v.localY, v.localZ);
			}
		}
		protected override function _verticesRefresh():void {
			super._verticesRefresh();
			var length:int = _entityVerticesList.length;
			var m:GLMatrix3D = this.worldMatrix;
			for (var i:int = 0; i<length; i++) {
				var v:Vertex3D = _entityVerticesList[i];
				//use Vertex transformWorldSpace method
				v.worldX = v.localX*m.a+v.localY*m.b+v.localZ*m.c+m.tx;
				v.worldY = v.localX*m.d+v.localY*m.e+v.localZ*m.f+m.ty;
				v.worldZ = v.localX*m.g+v.localY*m.h+v.localZ*m.i+m.tz;
				//
			}
		}
		private function _childrenCoordEqualsTest():Boolean {
			var length:int = _childBonesList.length;
			var child:Bone = _childBonesList[0];
			var v:Vector3D = new Vector3D(child.localX, child.localY, child.localZ);
			var m:Number = v.length;
			for (var i:int = 1; i<length; i++) {
				child = _childBonesList[i];
				v.x = child.localX;
				v.y = child.localY;
				v.z = child.localZ;
				if (m != v.length) return false;
			}
			return true;
		}
		private function _getChildEntity(list:Vector.<MeshObject>, child:Bone):void {
			var entityBone:EntityBone = child as EntityBone;
			if (entityBone != null) list.push(entityBone.entity);
			var length:int = child.totalChildBones;
			for (var i:int = 0; i<length; i++) {
				_getChildEntity(list, child.getChildBoneAt(i));
			}
		}
		private function _transformEntityDirection():void {
			var length:int = _entityVerticesList.length;
			for (var i:int = 0; i<length; i++) {
				var v:Vertex3D = _entityVerticesList[i];
				_entityCoord.addVertex(v);
				v.localX = v.worldX;
				v.localY = v.worldY;
				v.localZ = v.worldZ;
			}
			_entityCoord.clearVertices();
		}
	}
}