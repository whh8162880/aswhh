package asgl.files.models {
	import __AS3__.vec.Vector;
	
	import asgl.data.indices.FaceUVIndex;
	import asgl.data.indices.FaceVertexIndex;
	import asgl.events.FileEvent;
	import asgl.files.AbstractEncoder;
	import asgl.math.UV;
	import asgl.math.Vertex3D;
	import asgl.mesh.MeshObject;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class OBJEncoder extends AbstractEncoder {
		/**
		 * need meshObject elenemt:
		 * 	must:meshObject.vertices, meshObject.faceVertexIndices.
		 * 	includeUV:meshObject.uvs, if has faceUVIndices, use it, else use faceVertexIndices.
		 */
		public function encode(meshObjects:Vector.<MeshObject>, coordinatesTransform:Boolean=false, includeUV:Boolean=true, MTLname:String=null):void {
			try {
				var string:String = '# ASGL OBJENCODER EXPORT\n#';
				if (MTLname != null) string += '\nmtllib ./'+MTLname+'.mtl\ng';
				var length:int = meshObjects.length;
				var vertexOffset:int = 0;
				var uvOffset:int = 0;
				for (var i:int = 0; i<length; i++) {
					var mo:MeshObject = meshObjects[i];
					string += '\n# object '+mo.name+' to come ...\n#\n';
					var list:Vector.<FaceVertexIndex>;
					var list3:Vector.<Vertex3D> = mo.vertices;
					var list2:Vector.<FaceUVIndex>;
					var total:int = list3.length;
					for (var j:int = 0; j<total; j++) {
						var v:Vertex3D = list3[j];
						if (coordinatesTransform) {
							string += 'v '+v.localX.toString()+' '+v.localZ.toString()+' '+v.localY+'\n';
						} else {
							string += 'v '+v.localX.toString()+' '+v.localY.toString()+' '+v.localZ+'\n';
						}
					}
					string += '# '+total.toString()+' vertices\n';
					if (includeUV && mo.uvs != null) {
						string += '\n';
						var uvs:Vector.<UV> = mo.uvs;
						total = uvs.length;
						for (j = 0; j<total; j++) {
							var uv:UV = uvs[j];
							string += 'vt '+uv.u.toString()+' '+uv.v+' 0\n';
						}
						string += '# '+total.toString()+' texture vertices\n';
					}
					string += '\ng '+mo.name+'\n';
					list = mo.faceVertexIndices;
					total = list.length;
					var fvi:FaceVertexIndex;
					var fuvi:FaceUVIndex;
					var k:int;
					if (includeUV && mo.uvs != null) {
						if (mo.faceUVIndices == null) {
							for (j = 0; j<total; j++) {
								fvi = list[j];
								string += 'f';
								var index:int;
								if (coordinatesTransform) {
									index = fvi.getIndex(1)+1;
									string += ' '+(index+vertexOffset).toString()+'/'+(index+uvOffset).toString();
									index = fvi.getIndex(0)+1;
									string += ' '+(index+vertexOffset).toString()+'/'+(index+uvOffset).toString();
								} else {
									index = fvi.getIndex(0)+1;
									string += ' '+(index+vertexOffset).toString()+'/'+(index+uvOffset).toString();
									index = fvi.getIndex(1)+1;
									string += ' '+(index+vertexOffset).toString()+'/'+(index+uvOffset).toString();
								}
								index = fvi.getIndex(2)+1;
								string += ' '+(index+vertexOffset).toString()+'/'+(index+uvOffset).toString();
								string += '\n';
							}
							vertexOffset += mo.vertices.length;
							uvOffset += mo.uvs.length;
						} else {
							list2 = mo.faceUVIndices;
							for (j = 0; j<total; j++) {
								fvi = list[j];
								fuvi = list2[j];
								string += 'f';
								if (coordinatesTransform) {
									string += ' '+(fvi.getIndex(1)+1+vertexOffset).toString()+'/'+(fuvi.getIndex(1)+1+uvOffset).toString();
									string += ' '+(fvi.getIndex(0)+1+vertexOffset).toString()+'/'+(fuvi.getIndex(0)+1+uvOffset).toString();
								} else {
									string += ' '+(fvi.getIndex(0)+1+vertexOffset).toString()+'/'+(fuvi.getIndex(0)+1+uvOffset).toString();
									string += ' '+(fvi.getIndex(1)+1+vertexOffset).toString()+'/'+(fuvi.getIndex(1)+1+uvOffset).toString();
								}
								string += ' '+(fvi.getIndex(2)+1+vertexOffset).toString()+'/'+(fuvi.getIndex(2)+1+uvOffset).toString();
								string += '\n';
							}
							vertexOffset += mo.vertices.length;
							uvOffset += mo.uvs.length;
						}
					} else {
						for (j = 0; j<total; j++) {
							fvi = list[j];
							if (coordinatesTransform){
								string += 'f '+(fvi.getIndex(1)+1+vertexOffset).toString()+' '+(fvi.getIndex(0)+1+vertexOffset).toString()+' '+(fvi.getIndex(2)+1+vertexOffset).toString()+'\n';
							} else {
								string += 'f '+(fvi.getIndex(0)+1+vertexOffset).toString()+' '+(fvi.getIndex(1)+1+vertexOffset).toString()+' '+(fvi.getIndex(2)+1+vertexOffset).toString()+'\n';
							}
						}
						vertexOffset += mo.vertices.length;
					}
					string += '# '+total+' faces\n\ng';
					_bytes = new ByteArray();
					_bytes.endian = Endian.LITTLE_ENDIAN;
					_bytes.writeUTFBytes(string);
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