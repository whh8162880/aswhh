package asgl.files.models {
	import __AS3__.vec.Vector;
	
	import asgl.data.indices.FaceVertexIndex;
	import asgl.events.FileEvent;
	import asgl.files.AbstractEncoder;
	import asgl.materials.Material;
	import asgl.math.UV;
	import asgl.math.Vertex3D;
	import asgl.mesh.MeshObject;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	public class ASEEncoder extends AbstractEncoder {
		/**
		 * need meshObject elenemt:
		 * 	must:meshObject.vertices, meshObject.faceVertexIndices.
		 * 	useUV:meshObject.uvs, if has faceUVIndices, use it, else use faceVertexIndices.
		 *  useMaterial: meshObject.material.
		 */
		public function encode(meshObjects:Vector.<MeshObject>, coordinatesTransform:Boolean=false, includeMaterial:Boolean=true, includeUV:Boolean=true):void {
			try {
				var string:String = '*ASGL ASEENCODER EXPORT';
				var length:int = meshObjects.length;
				var temp:String = '';
				var materialArray:Array = [];
				var j:int;
				var mat:Material;
				for (var i:int = 0; i<length; i++) {
					var mo:MeshObject = meshObjects[i];
					temp += '\n*GEOMOBJECT {'
					temp += '\n	*NODE_NAME "'+mo.name+'"';
					temp += '\n	*MESH {'
					var vertexArray:Vector.<Vertex3D> = mo.vertices;
					var totalVertices:int = vertexArray.length;
					temp += '\n		*MESH_NUMVERTEX '+totalVertices;
					var faceVertexIndexArray:Vector.<FaceVertexIndex> = mo.faceVertexIndices;
					var totalFaces:int = faceVertexIndexArray.length;
					temp += '\n		*MESH_NUMFACES '+totalFaces;
					temp += '\n		*MESH_VERTEX_LIST {';
					for (j = 0; j<totalVertices; j++){
						var v:Vertex3D = vertexArray[j];
						if (coordinatesTransform) {
							temp += '\n			*MESH_VERTEX    '+j+'	'+v.localX+'	'+v.localZ+'	'+v.localY;
						} else {
							temp += '\n			*MESH_VERTEX    '+j+'	'+v.localX+'	'+v.localY+'	'+v.localZ;
						}
					}
					temp += '\n		}';//vertexList end
					temp += '\n		*MESH_FACE_LIST {';
					for (j = 0; j<totalFaces; j++) {
						var fvi:FaceVertexIndex = faceVertexIndexArray[j];
						if (coordinatesTransform) {
							temp += '\n			*MESH_FACE    '+j+':    A:    '+fvi.getIndex(0)+' B:    '+fvi.getIndex(2)+' C:    '+fvi.getIndex(1)+' AB:    1 BC:    0 CA:    1	 *MESH_SMOOTHING 1 	*MESH_MTLID 0';
						} else {
							temp += '\n			*MESH_FACE    '+j+':    A:    '+fvi.getIndex(0)+' B:    '+fvi.getIndex(1)+' C:    '+fvi.getIndex(2)+' AB:    1 BC:    0 CA:    1	 *MESH_SMOOTHING 1 	*MESH_MTLID 0';
						}
					}
					temp += '\n		}';//faceList end
					if (includeUV && mo.uvs != null) {
						var uvArray:Vector.<UV> = mo.uvs;
						var totalUV:int = uvArray.length;
						temp += '\n		*MESH_NUMTVERTEX '+totalUV;
						temp += '\n		*MESH_TVERTLIST {';
						for (j = 0; j<totalUV; j++) {
							var uv:UV = uvArray[j];
							temp += '\n			*MESH_TVERT '+j+'	'+uv.u+'	'+uv.v+'	0';
						}
						temp += '\n		}';//tvertList end
						temp += '\n		*MESH_NUMTVFACES '+totalFaces;
						var list:Object = mo.faceUVIndices;
						if (list == null) list = mo.faceVertexIndices;
						for (j = 0; j<totalFaces; j++) {
							var uvIndex:Object = list[j];
							if (coordinatesTransform) {
								temp += '\n			*MESH_TFACE '+j+'	'+uvIndex.getIndex(0)+'	'+uvIndex.getIndex(2)+'	'+uvIndex.getIndex(1);
							} else {
								temp += '\n			*MESH_TFACE '+j+'	'+uvIndex.getIndex(0)+'	'+uvIndex.getIndex(1)+'	'+uvIndex.getIndex(2);
							}
						}
						temp += '\n		}';
					}
					temp += '\n	}'//mesh end
					if (includeMaterial && mo.material != null) {
						mat = mo.material;
						var index:int = materialArray.indexOf(mat);
						if (index == -1) {
							materialArray.push(mat);
							index = materialArray.length-1;
						}
						temp += '\n	*MATERIAL_REF '+index;
					}
					temp += '\n}';
				}
				if (materialArray.length != 0) {
					string += '\n*MATERIAL_LIST {';
					var totalMaterials:int = materialArray.length;
					string += '\n	*MATERIAL_COUNT '+totalMaterials;
					for (j = 0; j<totalMaterials; j++){
						string += '\n	*MATERIAL '+j+' {';
						mat = materialArray[j];
						string += '\n		*MATERIAL_NAME "'+mat.name+'"';
						string += '\n	}';
					}
					string += '\n}';
				}
				string += temp;
				_bytes = new ByteArray();
				_bytes.endian = Endian.LITTLE_ENDIAN;
				_bytes.writeMultiByte(string, characterSet);
				_isCorrectFormat = true;
				this.dispatchEvent(new FileEvent(FileEvent.COMPLETE));
			} catch (e:Error) {
				clear();
				this.dispatchEvent(new FileEvent(FileEvent.ERROR, e));
			}
		}
	}
}