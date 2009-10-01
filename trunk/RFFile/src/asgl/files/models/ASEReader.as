package asgl.files.models {
	import __AS3__.vec.Vector;
	
	import asgl.data.indices.FaceUVIndex;
	import asgl.data.indices.FaceVertexIndex;
	import asgl.data.indices.MaterialFaceIndex;
	import asgl.events.FileEvent;
	import asgl.files.AbstractFile;
	import asgl.math.UV;
	import asgl.math.Vertex3D;
	import asgl.mesh.MeshObject;
	
	public class ASEReader extends AbstractFile {
		public var meshObjects:Vector.<MeshObject>;
		public function ASEReader(data:String=null, coordinatesTransform:Boolean=false):void {
			if (data == null) {
				clear();
			} else {
				read(data, coordinatesTransform);
			}
		}
		public override function clear():void {
			super.clear();
			meshObjects = new Vector.<MeshObject>();
		}
		public function read(data:String, coordinatesTransform:Boolean=false):void {
			clear();
			try {
				var list:Array = data.split('\r\n');
				var length:int = list.length;
				var line:String;
				var materialArray:Array = [];
				while ((line = list.shift())) {
					var content:String;
					line = line.substr(line.indexOf('*')+1);
					if(line.indexOf('}')>=0) line = '';
					var meshObject:MeshObject;
					switch (line.substr(0,line.indexOf(' '))) {
						case 'GEOMOBJECT' : {
							break;
						}
						case 'MATERIAL_NAME' : {
							materialArray.push(line.substr(15, line.length-1));
							break;
						}
						case 'MATERIAL_REF' : {
							var materialFaceIndexList:Vector.<MaterialFaceIndex> = meshObject.materialFaceIndices;
							if (materialFaceIndexList == null) {
								materialFaceIndexList = new Vector.<MaterialFaceIndex>();
								meshObject.materialFaceIndices = materialFaceIndexList;
							}
							var materialFaceIndex:MaterialFaceIndex = new MaterialFaceIndex(materialArray[int(line.substr(13))]);
							var totalFaces:int = meshObject.faceVertexIndices.length;
							for (var i:int = 0; i<totalFaces; i++) {
								materialFaceIndex.addIndex(i);
							}
							materialFaceIndexList.push(materialFaceIndex);
							break;
						}
						case 'MESH_VERTEX_LIST' : {
							meshObject = new MeshObject();
							meshObjects.push(meshObject);
							var vertexList:Vector.<Vertex3D> = meshObject.vertices;
							while((content = list.shift()).indexOf('}')<0) {
								content = content.split('*')[1];
								var vcl:Array = content.split('\t');
								if (coordinatesTransform) {
									vertexList.push(new Vertex3D(vcl[1], vcl[3], vcl[2]));
								} else {
									vertexList.push(new Vertex3D(vcl[1], vcl[2], vcl[3]));
								}
							}
							break;
						}
						case 'MESH_FACE_LIST' : {
							var faceVertexIndexList:Vector.<FaceVertexIndex> = meshObject.faceVertexIndices;
							while((content = list.shift()).indexOf('}')<0) {
								content = content.split('*')[1];
								var fvil:Array = content.split('\t')[0].split(':');
								if (coordinatesTransform) {
									faceVertexIndexList.push(new FaceVertexIndex(int(fvil[3].substr(0, fvil[3].lastIndexOf(' '))), int(fvil[2].substr(0, fvil[2].lastIndexOf(' '))), int(fvil[4].substr(0, fvil[4].lastIndexOf(' ')))));
								} else {
									faceVertexIndexList.push(new FaceVertexIndex(int(fvil[2].substr(0, fvil[2].lastIndexOf(' '))), int(fvil[3].substr(0, fvil[3].lastIndexOf(' '))), int(fvil[4].substr(0, fvil[4].lastIndexOf(' ')))));
								}
							}
							break;
						}
						case 'MESH_TVERTLIST' : {
							var uvList:Vector.<UV> = new Vector.<UV>();
							var uvCount:int = 0;
							while((content = list.shift()).indexOf('}')<0) {
								content = content.split('*')[1];
								var uvl:Array = content.split('\t');
								uvList.push(new UV(uvl[1], uvl[2]));
								uvCount++;
							}
							if (uvCount>0) meshObject.uvs = uvList;
							break;
						}
						case 'MESH_TFACELIST' : {
							var faceUVIndexList:Vector.<FaceUVIndex> = new Vector.<FaceUVIndex>();
							var ftuvCount:int = 0;
							while((content = list.shift()).indexOf('}')<0) {
								content = content.split('*')[1];
								var ftil:Array = content.split('\t');
								if (coordinatesTransform) {
									faceUVIndexList.push(new FaceUVIndex(ftil[2], ftil[1], ftil[3]));
								} else {
									faceUVIndexList.push(new FaceUVIndex(ftil[1], ftil[2], ftil[3]));
								}
								ftuvCount++;
							}
							if (ftuvCount>0) meshObject.faceUVIndices = faceUVIndexList;
							break;
						}
						case 'MESH_ANIMATION' : {
							var count:int = 0;
							while (true) {
								content = list.shift();
								if (content == null) break;
								var index:int = content.indexOf('}');
								//trace(count);
								if (index<0 || count != 0) {
									//if (index>=0) trace(count);
									if (index>=0) count--;
									content = content.substr(content.indexOf('*')+1);
									content = content.substr(0, content.indexOf(' '));
									if (content == 'MESH' || content == 'MESH_VERTEX_LIST' || content == 'MESH_FACE_LIST' || content == 'MESH_TVERTLIST' || content == 'MESH_TFACELIST' || content == 'MESH_NORMALS') count++;
								} else {
									break;
								}
							}
							break;
						}
					}
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