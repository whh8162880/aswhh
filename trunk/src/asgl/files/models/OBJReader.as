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
	
	public class OBJReader extends AbstractFile {
		public var meshObjects:Vector.<MeshObject>;
		public function OBJReader(bytes:String, coordinatesTransform:Boolean=false, mtl:MTLReader=null):void {
			if (bytes == null) {
				clear();
			} else {
				read(bytes, coordinatesTransform);
			}
		}
		public override function clear():void {
			super.clear();
			meshObjects = new Vector.<MeshObject>();
		}
		public function read(file:String, coordinatesTransform:Boolean=false, mtl:MTLReader=null):void {
			clear();
			try {
				var fileList:Array = file.split('\n');
				var length:int = fileList.length;
				var meshObject:MeshObject;
				var list:Array;
				var max:int;
				var j:int;
				var vn:int;
				var uvn:int;
				for (var i:int = 0; i<length; i++) {
					var line:String = fileList[i];
					if (line.indexOf('#') != -1) {
						if (line.indexOf(' object ') != -1) {
							meshObject = new MeshObject();
							meshObjects.push(meshObject);
							meshObject.name = line.substr(9, line.lastIndexOf(' to come ...')-9);
						} else if (line.indexOf(' texture vertices') != -1) {
							max = int(line.substr(2, line.length-19));
							var uvList:Vector.<UV> = new Vector.<UV>();
							meshObject.uvs = uvList;
							for (j = 0; j<max; j++) {
								line = fileList[i-max+j];
								list = line.split(' ');
								uvList.push(new UV(list[2], list[3]));
							}
						} else if (line.indexOf(' vertices') != -1) {
							max = int(line.substr(2, line.length-11));
							var vertexList:Vector.<Vertex3D> = meshObject.vertices;
							for (j = 0; j<max; j++) {
								line = fileList[i-max+j];
								list = line.split(' ');
								if (coordinatesTransform) {
									vertexList.push(new Vertex3D(list[2], list[4], list[3]));
								} else {
									vertexList.push(new Vertex3D(list[2], list[3], list[4]));
								}
							}
						} else if (line.indexOf(' faces') != -1) {
							max = int(line.substr(2, line.length-8));
							var faceVertexIndexList:Vector.<FaceVertexIndex> = meshObject.faceVertexIndices;
							var faceUVIndexList:Vector.<FaceUVIndex> = null;
							if (meshObject.uvs != null) {
								faceUVIndexList = new Vector.<FaceUVIndex>();
								meshObject.faceUVIndices = faceUVIndexList;
							}
							var index:int = 0;
							for (j = 0; j<max; j++) {
								while (true) {
									index++;
									line = fileList[i-index];
									if (line.indexOf('f ') == 0) {
										list = line.substr(2).split(' ');
										if (line.indexOf('/') == -1) {
											list[0] += '//';
											list[1] += '//';
											list[2] += '//';
										}
										line = list[0]+'/'+list[1]+'/'+list[2];
										list = line.split('/');
										if (coordinatesTransform) {
											faceVertexIndexList.push(new FaceVertexIndex(list[3]-uvn-1, list[0]-uvn-1, list[6]-uvn-1));
											if (faceUVIndexList != null) faceUVIndexList.push(new FaceUVIndex(list[4]-vn-1, list[1]-vn-1, list[7]-vn-1));
										} else {
											faceVertexIndexList.push(new FaceVertexIndex(list[0]-vn-1, list[3]-vn-1, list[6]-vn-1));
											if (faceUVIndexList != null) faceUVIndexList.push(new FaceUVIndex(list[1]-uvn-1, list[4]-uvn-1, list[7]-uvn-1));
										}
										break;
									}
								}
							}
							vn += meshObject.vertices.length;
							if (faceUVIndexList != null) uvn += meshObject.uvs.length;
							if (mtl != null) {
								var materialFaceIndexList:Vector.<MaterialFaceIndex> = new Vector.<MaterialFaceIndex>();
								meshObject.materialFaceIndices = materialFaceIndexList;
								var materialFaceIndex:MaterialFaceIndex = new MaterialFaceIndex(mtl.materials[meshObjects.length-1].name);
								materialFaceIndexList.push(materialFaceIndex);
								for (j = 0; j<max; j++) {
									materialFaceIndex.addIndex(j);
								}
							}
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