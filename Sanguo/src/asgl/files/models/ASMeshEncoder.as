package asgl.files.models {
	import __AS3__.vec.Vector;
	
	import asgl.animation.BoneAnimator;
	import asgl.data.indices.FaceUVIndex;
	import asgl.data.indices.FaceVertexIndex;
	import asgl.data.info.BoneInfo;
	import asgl.events.FileEvent;
	import asgl.files.AbstractEncoder;
	import asgl.materials.Material;
	import asgl.math.GLMatrix3D;
	import asgl.math.UV;
	import asgl.math.Vertex3D;
	import asgl.mesh.MeshObject;
	import asgl.mesh.TriangleFace;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	
	public class ASMeshEncoder extends AbstractEncoder {
		/**
		 * need meshObject elenemt:
		 * 	must:meshObject.vertices, meshObject.faceVertexIndices.
		 * 	includeUV:uvs, if has meshObject.faceUVIndices use it, else use meshObject.faceVertexIndices.
		 *  includeMaterial: if has meshObject.material, use it, else use face.material.
		 */
		public function encode(meshObjects:Vector.<MeshObject>, coordinatesTransform:Boolean=false, compress:Boolean=true, includeMaterial:Boolean=true, includeUV:Boolean=true, boneAnimator:BoneAnimator=null):void {
			_bytes = new ByteArray();
			_bytes.endian = Endian.LITTLE_ENDIAN;
			try {
				_bytes.writeUTFBytes('ASMESH');
				_bytes.writeByte(compress ? 1: 0);
				var isBoneAnimator:Boolean = boneAnimator != null;
				_bytes[6] = _bytes[6]|(isBoneAnimator ? 4 : 0);
				_bytes.writeShort(1);
				_bytes.writeShort(ASMeshChunk.MAIN);
				_bytes.writeUnsignedInt(0);
				
				_bytes.writeShort(ASMeshChunk.PROPERTY);
				_bytes.writeUnsignedInt(4);
				
				var totalMeshs:int = meshObjects.length;
				for (var i:int = 0; i<totalMeshs; i++) {
					var mo:MeshObject = meshObjects[i];
					_bytes.writeShort(ASMeshChunk.MESH);
					_bytes.writeUnsignedInt(0);
					var pos:uint = _bytes.position;
					_bytes.writeByte(mo.name.length);
					_bytes.writeMultiByte(mo.name, characterSet);
					_bytes.position = pos-4;
					_bytes.writeUnsignedInt(_bytes.length-pos);
					_bytes.position = _bytes.length;
					
					var vertexArray:Vector.<Vertex3D> = mo.vertices;
					var totalVertices:int = vertexArray.length;
					_bytes.writeShort(ASMeshChunk.MESH_VERTEX_LIST);
					_bytes.writeUnsignedInt(0);
					pos = _bytes.position;
					_bytes.writeShort(totalVertices);
					for (var j:int = 0; j<totalVertices; j++) {
						var v:Vertex3D = vertexArray[j];
						if (isBoneAnimator) {
							_bytes.writeFloat(v.sourceX);
							if (coordinatesTransform) {
								_bytes.writeFloat(v.sourceZ);
								_bytes.writeFloat(v.sourceY);
							} else {
								_bytes.writeFloat(v.sourceY);
								_bytes.writeFloat(v.sourceZ);
							}
						} else {
							_bytes.writeFloat(v.localX);
							if (coordinatesTransform) {
								_bytes.writeFloat(v.localZ);
								_bytes.writeFloat(v.localY);
							} else {
								_bytes.writeFloat(v.localY);
								_bytes.writeFloat(v.localZ);
							}
						}
					}
					_bytes.position = pos-4;
					_bytes.writeUnsignedInt(_bytes.length-pos);
					_bytes.position = _bytes.length;
					
					var fviArray:Vector.<FaceVertexIndex> = mo.faceVertexIndices;
					var faceArray:Vector.<TriangleFace> = mo.faces;
					var total:int = fviArray.length;
					var materialMap:Dictionary = new Dictionary();
					var totalMaterials:uint = 0;
					var mat:Material;
					_bytes.writeShort(ASMeshChunk.MESH_FACE_VERTEX_INDEX);
					_bytes.writeUnsignedInt(0);
					pos = _bytes.position;
					_bytes.writeShort(total);
					for (j = 0; j<total; j++) {
						var fvi:FaceVertexIndex = fviArray[j];
						if (coordinatesTransform) {
							_bytes.writeShort(fvi.getIndex(1));
							_bytes.writeShort(fvi.getIndex(0));
						} else {
							_bytes.writeShort(fvi.getIndex(0));
							_bytes.writeShort(fvi.getIndex(1));
						}
						_bytes.writeShort(fvi.getIndex(2));
						
						if (includeMaterial) {
							mat = mo.material;
							if (mat == null) {
								mat = faceArray[j].material;
							}
							if (mat != null) {
								if (materialMap[mat] == null) {
									materialMap[mat] = [];
									totalMaterials++;
								}
								materialMap[mat].push(j);
							}
						}
					}
					_bytes.position = pos-4;
					_bytes.writeUnsignedInt(_bytes.length-pos);
					_bytes.position = _bytes.length;
					
					if (includeUV && mo.uvs != null) {
						var uvArray:Vector.<UV> = mo.uvs;
						var totalUV:int = uvArray.length;
						_bytes.writeShort(ASMeshChunk.MESH_UV_LIST);
						_bytes.writeUnsignedInt(0);
						pos = _bytes.position;
						_bytes.writeShort(totalUV);
						for (j = 0; j<totalUV; j++) {
							var uv:UV = uvArray[j];
							_bytes.writeFloat(uv.u);
							_bytes.writeFloat(uv.v);
						}
						_bytes.position = pos-4;
						_bytes.writeUnsignedInt(_bytes.length-pos);
						_bytes.position = _bytes.length;
						
						if (mo.faceUVIndices != null) {
							_bytes[6] = _bytes[6]|2;
							var fuviArray:Vector.<FaceUVIndex> = mo.faceUVIndices;
							total = fuviArray.length;
							_bytes.writeShort(ASMeshChunk.MESH_FACE_UV_INDEX);
							_bytes.writeUnsignedInt(0);
							pos = _bytes.position;
							_bytes.writeShort(total);
							for (j = 0; j<total; j++) {
								var fuvi:FaceUVIndex = fuviArray[j];
								if (coordinatesTransform) {
									_bytes.writeShort(fuvi.getIndex(1));
									_bytes.writeShort(fuvi.getIndex(0));
								} else {
									_bytes.writeShort(fuvi.getIndex(0));
									_bytes.writeShort(fuvi.getIndex(1));
								}
								_bytes.writeShort(fuvi.getIndex(2));
							}
							_bytes.position = pos-4;
							_bytes.writeUnsignedInt(_bytes.length-pos);
							_bytes.position = _bytes.length;
						}
					}
					
					if (includeMaterial) {
						_bytes.writeShort(ASMeshChunk.MESH_MATERIAL_FACE_INDEX);
						_bytes.writeUnsignedInt(0);
						pos = _bytes.position;
						_bytes.writeShort(totalMaterials);
						for (var key:* in materialMap) {
							mat = key;
							_bytes.writeByte(mat.name.length);
							_bytes.writeUTFBytes(mat.name);
							var list:Array = materialMap[mat];
							total = list.length;
							_bytes.writeShort(total);
							for (j = 0; j<total; j++) {
								_bytes.writeShort(list[j]);
							}
						}
						_bytes.position = pos-4;
						_bytes.writeUnsignedInt(_bytes.length-pos);
						_bytes.position = _bytes.length;
					}
					
					if (isBoneAnimator) {
						_bytes.writeShort(ASMeshChunk.MESH_BONE);
						_bytes.writeUnsignedInt(0);
						pos = _bytes.position;
						for (j = 0; j<totalVertices; j++) {
							var boneInfoArray:Vector.<BoneInfo> = boneAnimator.getBoneInfoByVertex(vertexArray[j]);
							if (boneInfoArray == null) {
								_bytes.writeByte(0);
							} else {
								total = boneInfoArray.length;
								_bytes.writeByte(total);
								for (var k:int = 0; k<total; k++) {
									var info:BoneInfo = boneInfoArray[k];
									_bytes.writeByte(info.bone.name.length);
									_bytes.writeUTFBytes(info.bone.name);
									_bytes.writeFloat(info.weight);
									var m:GLMatrix3D = info.offsetMatrix;
									if (coordinatesTransform) m.coordinatesTransform();
									_bytes.writeFloat(m.a);
									_bytes.writeFloat(m.b);
									_bytes.writeFloat(m.c);
									_bytes.writeFloat(m.d);
									_bytes.writeFloat(m.e);
									_bytes.writeFloat(m.f);
									_bytes.writeFloat(m.g);
									_bytes.writeFloat(m.h);
									_bytes.writeFloat(m.i);
									_bytes.writeFloat(m.tx);
									_bytes.writeFloat(m.ty);
									_bytes.writeFloat(m.tz);
									if (coordinatesTransform) m.coordinatesTransform();
								}
							}
						}
						_bytes.position = pos-4;
						_bytes.writeUnsignedInt(_bytes.length-pos);
						_bytes.position = _bytes.length;
					}
				}
				if (compress) {
					var temp:ByteArray = new ByteArray();
					temp.endian = Endian.LITTLE_ENDIAN;
					temp.writeBytes(_bytes, 7, _bytes.length-7);
					temp.compress();
					_bytes.length = 7;
					_bytes.writeBytes(temp);
				}
				_isCorrectFormat = true;
				this.dispatchEvent(new FileEvent(FileEvent.COMPLETE));
			} catch (e:Error) {
				clear();
				this.dispatchEvent(new FileEvent(FileEvent.ERROR, e));
			}
		}
	}
}