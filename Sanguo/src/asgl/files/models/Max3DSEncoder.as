package asgl.files.models {
	import __AS3__.vec.Vector;
	
	import asgl.data.indices.FaceVertexIndex;
	import asgl.events.FileEvent;
	import asgl.files.AbstractEncoder;
	import asgl.math.UV;
	import asgl.math.Vertex3D;
	import asgl.mesh.MeshObject;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class Max3DSEncoder extends AbstractEncoder {
		/**
		 * need meshObject elenemt:
		 * 	must:meshObject.vertices, meshObject.faceVertexIndices.
		 * 	includeUV:uvs, index of uvs of meshObject = index of vertices of meshObject.
		 *  includeMaterial: meshObject.material.
		 */
		public function encode(meshObjects:Vector.<MeshObject>, coordinatesTransform:Boolean=false, includeMaterial:Boolean=true, includeUV:Boolean=true):void {
			try {
				_bytes = new ByteArray();
				_bytes.endian = Endian.LITTLE_ENDIAN;
				_bytes.writeShort(Max3DSChunk.MAIN3DS);
				_bytes.writeUnsignedInt(0);
				
				_bytes.writeShort(Max3DSChunk.EDIT3DS);
				var edit3DSPos:uint = _bytes.position;
				_bytes.writeUnsignedInt(0);
				
				var length:int = meshObjects.length;
				var defaultNameCount:int = 0;
				for (var i:int = 0; i<length; i++) {
					var meshObject:MeshObject = meshObjects[i];
					
					_bytes.writeShort(Max3DSChunk.EDIT_OBJECT);
					var editObjPos:uint = _bytes.position;
					_bytes.writeUnsignedInt(0);
					_bytes.writeMultiByte(meshObject.name == null ? 'Object'+(defaultNameCount++) : meshObject.name, characterSet);
					_bytes.writeByte(0);
					
					_bytes.writeShort(Max3DSChunk.OBJ_TRIMESH);
					var objTriMeshPos:uint = _bytes.position;
					_bytes.writeUnsignedInt(0);
					
					_bytes.writeShort(Max3DSChunk.TRI_VERTEX);
					var triVertexPos:uint = _bytes.position;
					_bytes.writeUnsignedInt(0);
					var vertexArray:Vector.<Vertex3D> = meshObject.vertices;
					var max:uint = vertexArray.length;
					_bytes.writeShort(max);
					for (var j:uint = 0; j<max; j++) {
						var vertex:Vertex3D = vertexArray[j];
						_bytes.writeFloat(vertex.localX);
						if (coordinatesTransform) {
							_bytes.writeFloat(vertex.localZ);
							_bytes.writeFloat(vertex.localY);
						} else {
							_bytes.writeFloat(vertex.localY);
							_bytes.writeFloat(vertex.localZ);
						}
					}
					_bytes.position = triVertexPos;
					_bytes.writeUnsignedInt(_bytes.length-triVertexPos+2);
					_bytes.position = _bytes.length;
					
					if (includeUV && meshObject.uvs != null) {
						_bytes.writeShort(Max3DSChunk.TRI_UV);
						var triUVPos:uint = _bytes.position;
						_bytes.writeUnsignedInt(0);
						var uvArray:Vector.<UV> = meshObject.uvs;
						max = uvArray.length;
						_bytes.writeShort(max);
						for (j = 0; j<max; j++) {
							var uv:UV = uvArray[j];
							_bytes.writeFloat(uv.u);
							_bytes.writeFloat(1-uv.v);
						}
						_bytes.position = triUVPos;
						_bytes.writeUnsignedInt(_bytes.length-triUVPos+2);
						_bytes.position = _bytes.length;
					}
					
					_bytes.writeShort(Max3DSChunk.TRI_FACEVERT);
					var triFaceVertPos:uint = _bytes.position;
					_bytes.writeUnsignedInt(0);
					var faceVertexIndexArray:Vector.<FaceVertexIndex> = meshObject.faceVertexIndices;
					max = faceVertexIndexArray.length;
					_bytes.writeShort(max);
					for (j = 0; j<max; j++) {
						var fvi:FaceVertexIndex = faceVertexIndexArray[j];
						if (coordinatesTransform) {
							_bytes.writeShort(fvi.getIndex(1));
							_bytes.writeShort(fvi.getIndex(0));
						} else {
							_bytes.writeShort(fvi.getIndex(0));
							_bytes.writeShort(fvi.getIndex(1));
						}
						_bytes.writeShort(fvi.getIndex(2));
						_bytes.writeShort(5);
					}
					
					if (includeMaterial && meshObject.material != null) {
						_bytes.writeShort(Max3DSChunk.TRI_FACEMAT);
						var triFaceMatPos:uint = _bytes.position;
						_bytes.writeUnsignedInt(0);
						max = meshObject.faceVertexIndices.length;
						_bytes.writeMultiByte(meshObject.material.name, characterSet);
						_bytes.writeByte(0);
						_bytes.writeShort(max);
						for (j = 0; j<max; j++) {
							_bytes.writeShort(j);
						}
						_bytes.position = triFaceMatPos;
						_bytes.writeUnsignedInt(_bytes.length-triFaceMatPos+2);
						_bytes.position = _bytes.length;
					}
					
					_bytes.position = triFaceVertPos;
					_bytes.writeUnsignedInt(_bytes.length-triFaceVertPos+2);
					
					_bytes.position = objTriMeshPos;
					_bytes.writeUnsignedInt(_bytes.length-objTriMeshPos+2);
					
					_bytes.position = editObjPos;
					_bytes.writeUnsignedInt(_bytes.length-editObjPos+2);
					_bytes.position = _bytes.length;
				}
				
				_bytes.position = edit3DSPos;
				_bytes.writeUnsignedInt(_bytes.length-edit3DSPos+2);
				_bytes.position = _bytes.length;
				
				_bytes.position = 2;
				_bytes.writeUnsignedInt(_bytes.length);
				_isCorrectFormat = true;
				this.dispatchEvent(new FileEvent(FileEvent.COMPLETE));
			} catch (e:Error){
				clear();
				this.dispatchEvent(new FileEvent(FileEvent.ERROR, e));
			}
		}
	}
}