package asgl.mesh {
	import __AS3__.vec.Vector;
	
	import asgl.data.indices.FaceUVIndex;
	import asgl.data.indices.FaceVertexIndex;
	import asgl.data.indices.MaterialFaceIndex;
	import asgl.data.info.Camera3DInfo;
	import asgl.data.info.FaceInfo;
	import asgl.materials.Material;
	import asgl.math.UV;
	import asgl.math.Vertex3D;
	import asgl.mesh.TriangleFace;
	import asgl.renderers.shaders.IShader;
	import asgl.utils.VectorUtil;
	
	public class MeshObject {
		public var cameraInfo:Camera3DInfo;
		public var shader:IShader;
		public var name:String;
		public var type:String = MeshObjectType.NONE;
		public var material:Material;
		public var content:Object;
		public var color:uint = 0xFFFFFFFF;
		public var faceInfos:Vector.<FaceInfo>;
		public var faceUVIndices:Vector.<FaceUVIndex>;
		public var faceVertexIndices:Vector.<FaceVertexIndex> = new Vector.<FaceVertexIndex>();
		public var materialFaceIndices:Vector.<MaterialFaceIndex>;
		public var faces:Vector.<TriangleFace>;
		public var uvs:Vector.<UV>;
		public var vertices:Vector.<Vertex3D> = new Vector.<Vertex3D>();
		public function MeshObject(name:String = null):void {
			this.name = name;
		}
		public function concat(meshObject:MeshObject, concatUVs:Boolean=false, concatFaceUVIndices:Boolean=false, concatMaterialFaceIndices:Boolean=false):void {
			var index:int = vertices.length;
			VectorUtil.concat(vertices, meshObject.vertices);
			VectorUtil.concat(faceVertexIndices, meshObject.faceVertexIndices);
			var fvi:Vector.<FaceVertexIndex> = meshObject.faceVertexIndices;
			var length:int = fvi.length;
			for (var i:int = 0; i<length; i++) {
				fvi[i].offset = index;
			}
			index = uvs.length;
			if (concatUVs) VectorUtil.concat(uvs, meshObject.uvs);
			if (concatFaceUVIndices) {
				VectorUtil.concat(faceUVIndices, meshObject.faceUVIndices);
				var fuvi:Vector.<FaceUVIndex> = meshObject.faceUVIndices;
				length = fuvi.length;
				for (i = 0; i<length; i++) {
					fuvi[i].offset = index;
				}
			}
			index = faceVertexIndices.length-meshObject.faceVertexIndices.length;
			if (concatMaterialFaceIndices) {
				materialFaceIndices = materialFaceIndices.concat(meshObject.materialFaceIndices);
				var mfi:Vector.<MaterialFaceIndex> = meshObject.materialFaceIndices;
				length = mfi.length;
				for (i = 0; i<length; i++) {
					mfi[i].offset = index;
				}
			}
		}
		public function createFaces(faceType:String, faceClass:Class=null):Vector.<TriangleFace> {
			faces = new Vector.<TriangleFace>();
			if (faceInfos == null) return faces;
			if (faceClass == null) faceClass = TriangleFace;
			var length:int = faceInfos.length;
			var i:int;
			var info:FaceInfo;
			var face:TriangleFace;
			if (faceType == FaceType.MATERIAL_FACE) {
				for (i = 0; i<length; i++) {
					info = faceInfos[i];
					face = new faceClass(info.vertex0, info.vertex1, info.vertex2, true, info.material, info.uv0, info.uv1, info.uv2);
					face.shader = shader;
					face.content = content;
					face.color = color;
					faces[i] = face;
				}
			} else if (faceType == FaceType.SHAPE_FACE) {
				for (i = 0; i<length; i++) {
					info = faceInfos[i];
					face = new faceClass(info.vertex0, info.vertex1, info.vertex2);
					face.shader = shader;
					face.content = content;
					face.color = color;
					faces[i] = face;
				}
			}
			return faces;
		}
		public function directlyCreateFaces(faceType:String, materials:Vector.<Material>=null, faceClass:Class=null):Vector.<TriangleFace> {
			faces = new Vector.<TriangleFace>();
			if (faceClass == null) faceClass = TriangleFace;
			var faceVertexIndex:FaceVertexIndex;
			var index0:int;
			var index1:int;
			var index2:int;
			var i:int;
			var length:int = faceVertexIndices.length;
			var face:TriangleFace;
			if (faceType == FaceType.MATERIAL_FACE) {
				if (faceUVIndices == null) {
					for (i = 0; i<length; i++) {
						faceVertexIndex = faceVertexIndices[i];
						index0 = faceVertexIndex.getIndex(0);
						index1 = faceVertexIndex.getIndex(1);
						index2 = faceVertexIndex.getIndex(2);
						face = new faceClass(vertices[index0], vertices[index1], vertices[index2], true, material, uvs[index0], uvs[index1], uvs[index2]);
						face.shader = shader;
						face.content = content;
						face.color = color;
						faces[i] = face;
					}
				} else {
					var faceUVIndex:FaceUVIndex;
					var index3:int;
					var index4:int;
					var index5:int;
					for (i = 0; i<length; i++) {
						faceVertexIndex = faceVertexIndices[i];
						index0 = faceVertexIndex.getIndex(0);
						index1 = faceVertexIndex.getIndex(1);
						index2 = faceVertexIndex.getIndex(2);
						faceUVIndex = faceUVIndices[i];
						index3 = faceUVIndex.getIndex(0);
						index4 = faceUVIndex.getIndex(1);
						index5 = faceUVIndex.getIndex(2);
						face = new faceClass(vertices[index0], vertices[index1], vertices[index2], true, material, uvs[index0], uvs[index1], uvs[index2]);
						face.shader = shader;
						face.content = content;
						face.color = color;
						faces[i] = face;
					}
				}
				if (materials != null && materialFaceIndices != null) {
					length = materials.length;
					var material:Material;
					for (i = materialFaceIndices.length-1; i>=0; i--) {
						var materialFaceIndex:MaterialFaceIndex = materialFaceIndices[i];
						var name:String = materialFaceIndex.materialName;
						for (var j:int = 0; j<length; j++) {
							material = materials[j];
							if (material.name != null && material.name == name) {
								var n:int = materialFaceIndex.faceIndexLength;
								for (var k:int = 0; k<n; k++) {
									faces[materialFaceIndex.getIndex(k)].material = material;
								}
								break;
							}
						}
					}
				}
			} else if (faceType == FaceType.SHAPE_FACE) {
				for (i = 0; i<length; i++) {
					faceVertexIndex = faceVertexIndices[i];
					index0 = faceVertexIndex.getIndex(0);
					index1 = faceVertexIndex.getIndex(1);
					index2 = faceVertexIndex.getIndex(2);
					face = new faceClass(vertices[index0], vertices[index1], vertices[index2]);
					face.shader = shader;
					face.content = content;
					face.color = color;
					faces[i] = face;
				}
			}
			return faces;
		}
		public function destroy():void {
			cameraInfo = null;
			content = null;
			faceInfos = null;
			faces = null;
			faceUVIndices = null;
			faceVertexIndices = null;
			material = null;
			materialFaceIndices = null;
			shader = null;
		}
		public function format(materials:Vector.<Material>=null):void {
			faceInfos = new Vector.<FaceInfo>();
			var length:int = faceVertexIndices.length;
			for (var i:int = 0; i<length; i++) {
				var faceVertexIndex:FaceVertexIndex = faceVertexIndices[i];
				var index0:int = faceVertexIndex.getIndex(0);
				var index1:int = faceVertexIndex.getIndex(1);
				var index2:int = faceVertexIndex.getIndex(2);
				var faceInfo:FaceInfo = new FaceInfo();
				faceInfo.material = material;
				faceInfo.vertex0 = vertices[index0];
				faceInfo.vertex1 = vertices[index1];
				faceInfo.vertex2 = vertices[index2];
				if (faceUVIndices != null) {
					var faceUVIndex:FaceUVIndex = faceUVIndices[i];
					index0 = faceUVIndex.getIndex(0);
					index1 = faceUVIndex.getIndex(1);
					index2 = faceUVIndex.getIndex(2);
				}
				if (uvs != null) {
					faceInfo.uv0 = uvs[index0];
					faceInfo.uv1 = uvs[index1];
					faceInfo.uv2 = uvs[index2];
				}
				faceInfos.push(faceInfo);
			}
			
			if (materials != null && materialFaceIndices != null) {
				length = materials.length;
				var material:Material;
				for (i = materialFaceIndices.length-1; i>=0; i--) {
					var materialFaceIndex:MaterialFaceIndex = materialFaceIndices[i];
					var name:String = materialFaceIndex.materialName;
					for (var j:int = 0; j<length; j++) {
						material = materials[j];
						if (material.name != null && material.name == name) {
							var n:int = materialFaceIndex.faceIndexLength;
							for (var k:int = 0; k<n; k++) {
								faceInfos[materialFaceIndex.getIndex(k)].material = material;
							}
							break;
						}
					}
				}
			}
		}
	}
}