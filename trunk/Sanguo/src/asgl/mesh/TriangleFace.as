package asgl.mesh {
	import __AS3__.vec.Vector;
	
	import asgl.materials.Material;
	import asgl.math.UV;
	import asgl.math.Vertex3D;
	import asgl.renderers.shaders.IShader;
	
	import flash.geom.Vector3D;
	
	public class TriangleFace {
		private static const PI:Number = Math.PI;
		private static var _idManager:Number = 0;
		public var isMaterialFace:Boolean;
		public var mipmapFilteringEnabled:Boolean = false;
		public var shader:IShader;
		public var material:Material;
		/**
		 * [read only]
		 */
		public var id:Number;
		public var mipmapDistance:Number = 100;
		public var content:Object;
		public var data:Object;
		public var concatFaces:Vector.<TriangleFace>;
		public var color:uint = 0xFFFFFFFF;
		/**
		 * can not set null
		 */
		public var vector:Vector3D = new Vector3D();
		public var uv0:UV;
		public var uv1:UV;
		public var uv2:UV;
		/**
		 * can not set null
		 */
		public var vertex0:Vertex3D;
		public var vertex1:Vertex3D;
		public var vertex2:Vertex3D;
		public function TriangleFace(v0:Vertex3D, v1:Vertex3D, v2:Vertex3D, isMaterialFace:Boolean=false, material:Material=null, uv0:UV=null, uv1:UV=null, uv2:UV=null):void {
			id = _idManager;
			_idManager++;
			vertex0 = v0;
			vertex1 = v1;
			vertex2 = v2;
			this.isMaterialFace = isMaterialFace;
			this.uv0 = uv0;
			this.uv1 = uv1;
			this.uv2 = uv2;
			this.material = material;
		}
		public function get isBack():Boolean {
			return (vertex2.screenX-vertex0.screenX)*(vertex1.screenY-vertex0.screenY)<(vertex2.screenY-vertex0.screenY)*(vertex1.screenX-vertex0.screenX);
		}
		public function get screenSpaceDepthSortValue():Number {
			return vertex0.screenZ+vertex1.screenZ+vertex2.screenZ;
		}
		public function coordinatesTransform():void {
			var v:Vertex3D = vertex1;
			vertex1 = vertex2;
			vertex2 = v;
		}
		public function destroy():void {
			data = null;
			content = null;
			concatFaces = null;
			shader = null;
			vector = null;
			vertex0 = null;
			vertex1 = null;
			vertex2 = null;
			material = null;
			uv0 = null;
			uv1 = null;
			uv2 = null;
		}
		public function flip():void {
			var v:Vertex3D = vertex0;
			vertex0 = vertex1;
			vertex1 = v;
			if (isMaterialFace) {
				var uv:UV = uv0;
				uv0 = uv1;
				uv1 = uv;
			}
		}
		/**
		 * @param index the index is 0-2.
		 * 
		 * this.vector is screen space vector. need concatFaces.
		 */
		public function getClipVertexScreenSpaceBlendNormal(index:uint):Vector3D {
			if (concatFaces == null || concatFaces.length == 0) return vector.clone();
			var vertex:Vertex3D;
			if (index == 0) {
				vertex = vertex0;
			} else if (index == 1) {
				vertex = vertex1;
			} else {
				vertex = vertex2;
			}
			var nx:Number = vector.x;
			var ny:Number = vector.y;
			var nz:Number = vector.z;
			var concatNormal:Vector3D;
			for (var i:int = concatFaces.length-1; i>=0; i--) {
				var concatFace:TriangleFace = concatFaces[i];
				var concatVertex:Vertex3D = concatFace.vertex0;
				if (vertex.screenX == concatVertex.screenX && vertex.screenY == concatVertex.screenY && vertex.screenZ == concatVertex.screenZ) {
					concatNormal = concatFace.vector;
					nx += concatNormal.x;
					ny += concatNormal.y;
					nz += concatNormal.z;
				} else {
					concatVertex = concatFace.vertex1;
					if (vertex.screenX == concatVertex.screenX && vertex.screenY == concatVertex.screenY && vertex.screenZ == concatVertex.screenZ) {
						concatNormal = concatFace.vector;
						nx += concatNormal.x;
						ny += concatNormal.y;
						nz += concatNormal.z;
					} else {
						concatVertex = concatFace.vertex2;
						if (vertex.screenX == concatVertex.screenX && vertex.screenY == concatVertex.screenY && vertex.screenZ == concatVertex.screenZ) {
							concatNormal = concatFace.vector;
							nx += concatNormal.x;
							ny += concatNormal.y;
							nz += concatNormal.z;
						}
					}
				}
			}
			return new Vector3D(nx, ny, nz);
		}
		public function getNewTriangleFace(v0:Vertex3D, v1:Vertex3D, v2:Vertex3D, isMaterialFace:Boolean=false, material:Material=null, uv0:UV=null, uv1:UV=null, uv2:UV=null):TriangleFace {
			var face:TriangleFace = new TriangleFace(v0, v1, v2, isMaterialFace, material, uv0, uv1, uv2);
			face.shader = shader;
			face.content = content;
			face.color = color;
			face.vector = vector.clone();
			return face;
		}
	}
}