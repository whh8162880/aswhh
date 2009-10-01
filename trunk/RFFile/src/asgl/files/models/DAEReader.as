package asgl.files.models {
	import __AS3__.vec.Vector;
	
	import asgl.data.indices.FaceUVIndex;
	import asgl.data.indices.FaceVertexIndex;
	import asgl.data.indices.MaterialFaceIndex;
	import asgl.events.FileEvent;
	import asgl.files.AbstractFile;
	import asgl.math.Coordinates3D;
	import asgl.math.GLMatrix3D;
	import asgl.math.Quaternion;
	import asgl.math.UV;
	import asgl.math.Vertex3D;
	import asgl.mesh.MeshObject;
	
	import flash.geom.Vector3D;
	
	public class DAEReader extends AbstractFile {
		public var meshObjects:Vector.<MeshObject>;
		public function DAEReader(data:String=null, coordinatesTransform:Boolean=false):void {
			if (data == null) {
				clear();
			} else {
				read(data, coordinatesTransform);
			}
		}
		public function get materialNameList():Array {
			return hide::cloneList();
		}
		public override function clear():void {
			super.clear();
			meshObjects = new Vector.<MeshObject>();
			_list = [];
		}
		public function read(data:String, coordinatesTransform:Boolean=false):void {
			clear();
			try {
				var index:int = data.indexOf('xmlns');
				var list:Array;
				if (index != -1) {
					list = data.split('xmlns');
					data = list[0];
					index = list[1].indexOf('>');
					data += list[1].substr(index);
				}
				var xmlData:XML = new XML(data);
				var xml:XML;
				var xmlList:XMLList;
				var max:int;
				var i:int;
				var j:int;
				var id:String;
				var meshObject:MeshObject;
				if (xmlData.library_geometries.length() != 0) {
					max = xmlData.library_geometries.geometry.length();
					for (i = 0; i<max; i++) {
						xml = xmlData.library_geometries.geometry[i];
						meshObject = new MeshObject();
						meshObjects.push(meshObject);
						meshObject.name = xml.@name;
						id = xml.@id;
						meshObject.name = xml.@name;
						var vertexArray:Array = xml.mesh[0].source.(@id == (id+'-positions'))[0].float_array[0].(@id == (id+'-positions-array'))[0].toString().split(' ');
						var totalVertices:int = vertexArray.length/3;
						var vertexList:Vector.<Vertex3D> = meshObject.vertices;
						for (j = 0; j<totalVertices; j++) {
							index = j*3;
							if (coordinatesTransform) {
								vertexList.push(new Vertex3D(vertexArray[index], vertexArray[index+2], vertexArray[index+1]));
							} else {
								vertexList.push(new Vertex3D(vertexArray[index], vertexArray[index+1], vertexArray[index+2]));
							}
						}
						var mapKey:String = '-map-channel1';
						var hasUV:Boolean = xml.mesh[0].source.(@id == (id+mapKey)).length() == 1;
						if (!hasUV) {
							mapKey = '-map1';
							hasUV = xml.mesh[0].source.(@id == (id+mapKey)).length() == 1;
						}
						if (hasUV) {
							var uvList:Vector.<UV> = new Vector.<UV>();
							meshObject.uvs = uvList;
							var uvArray:Array = xml.mesh[0].source.(@id == (id+mapKey))[0].float_array[0].(@id == (id+mapKey+'-array'))[0].toString().split(' ');
							var totalUV:int = uvArray.length/xml.mesh[0].source.(@id == (id+mapKey))[0].technique_common[0].accessor[0].@stride;
							for (j = 0; j<totalUV; j++) {
								index = j*3;
								uvList.push(new UV(uvArray[index], uvArray[index+1]));
							}
						}
						var indexArray:Array = xml.mesh[0].triangles[0].p[0].toString().split(' ');
						var totalFaces:int;
						var faceVertexIndexList:Vector.<FaceVertexIndex> = meshObject.faceVertexIndices;
						
						var num:int = xml.mesh[0].triangles[0].input.length();
						var vertexOffset:int = xml.mesh[0].triangles[0].input.(@semantic == 'VERTEX')[0].@offset;
						var uvOffset:int;
						var faceUVIndexList:Vector.<FaceUVIndex>;
						if (hasUV) {
							uvOffset = xml.mesh[0].triangles[0].input.(@semantic == 'TEXCOORD')[0].@offset;
							faceUVIndexList = new Vector.<FaceUVIndex>();
							meshObject.faceUVIndices = faceUVIndexList;
						}
						totalFaces = indexArray.length/(num*2);
						var d:int = num*3;
						num--;
						for (j = 0; j<totalFaces; j++) {
							var c:int = j*d;
							index = vertexOffset+c;
							if (coordinatesTransform) {
								faceVertexIndexList.push(new FaceVertexIndex(indexArray[index+1+num], indexArray[index], indexArray[index+2+num*2]));
							} else {
								faceVertexIndexList.push(new FaceVertexIndex(indexArray[index], indexArray[index+1+num], indexArray[index+2+num*2]));
							}
							if (hasUV) {
								index = uvOffset+c;
								if (coordinatesTransform) {
									faceUVIndexList.push(new FaceUVIndex(indexArray[index+1+num], indexArray[index], indexArray[index+2+num*2]));
								} else {
									faceUVIndexList.push(new FaceUVIndex(indexArray[index], indexArray[index+1+num], indexArray[index+2+num*2]));
								}
							}
						}
						if (hasUV) {
							var materialFaceIndexList:Vector.<MaterialFaceIndex> = new Vector.<MaterialFaceIndex>();
							meshObject.materialFaceIndices = materialFaceIndexList;
							var name:String = xml.mesh[0].triangles[0].@material;
							var materialFaceIndex:MaterialFaceIndex = new MaterialFaceIndex(name);
							_list.push(name);
							materialFaceIndexList.push(materialFaceIndex);
							for (j = 0; j<totalFaces; j++) {
								materialFaceIndex.addIndex(j);
							}
						}
					}
				}
				if (xmlData.library_visual_scenes.length() != 0 && xmlData.library_visual_scenes.visual_scene.length() != 0) _readCoord(null, xmlData.library_visual_scenes.visual_scene[0], coordinatesTransform);
				_isCorrectFormat = true;
				this.dispatchEvent(new FileEvent(FileEvent.COMPLETE));
			} catch (e:Error) {
				clear();
				this.dispatchEvent(new FileEvent(FileEvent.ERROR, e));
			}
		}
		private function _readCoord(coord:Coordinates3D, node:XML, coordinatesTransform:Boolean):void {
			var coordXMLList:XMLList = node.node;
			var length:int = coordXMLList.length();
			for (var i:int = 0; i<length; i++) {
				var coordXML:XML = coordXMLList[i];
				var childCoord:Coordinates3D = new Coordinates3D();
				childCoord.name = coordXML.@name;
				if (coord != null) coord.addChild(childCoord);
				var matrix:GLMatrix3D = new GLMatrix3D();
				var rotateXMLList:XMLList = coordXML.rotate;
				var total:int = rotateXMLList.length();
				var value:String;
				var valueList:Array;
				var sid:String;
				var q:Quaternion;
				for (var j:int = 0; j<total; j++) {
					var rotateXML:XML = rotateXMLList[j];
					sid = rotateXML.@sid;
					if (q == null) q = new Quaternion();
					if (sid == '') {
						value = rotateXML;
						valueList = value.split(' ');
						q.setValue(new Vector3D(valueList[0], valueList[1], valueList[2]), valueList[3]);
						matrix.copy(q.matrix);
					} else if (sid == 'rotateX') {
						value = rotateXML;
						valueList = value.split(' ');
						q.setValue(new Vector3D(valueList[0], valueList[1], valueList[2]), valueList[3]);
						matrix.concat(q.matrix);
					} else if (sid == 'rotateY') {
						value = rotateXML;
						valueList = value.split(' ');
						q.setValue(new Vector3D(valueList[0], valueList[1], valueList[2]), valueList[3]);
						matrix.concat(q.matrix);
					} else if (sid == 'rotateZ') {
						value = rotateXML;
						valueList = value.split(' ');
						q.setValue(new Vector3D(valueList[0], valueList[1], valueList[2]), valueList[3]);
						matrix.concat(q.matrix);
					}
				}
				var translateXMLList:XMLList = coordXML.translate;
				total = translateXMLList.length();
				for (j = 0; j<total; j++) {
					var translateXML:XML = translateXMLList[j];
					sid = translateXML.@sid;
					if (sid == '') sid = 'translate';
					if (sid == 'translate') {
						value = translateXML;
						valueList = value.split(' ');
						matrix.tx = valueList[0];
						matrix.ty = valueList[1];
						matrix.tz = valueList[2];
					}
				}
				var matrixXMLList:XMLList = coordXML.matrix;
				total = matrixXMLList.length();
				for (j = 0; j<total; j++) {
					var matrixXML:XML = matrixXMLList[j];
					value = matrixXML;
					valueList = value.split(' ');
					matrix.setValue(valueList[0], valueList[1], valueList[2], valueList[4], valueList[5], valueList[6], valueList[8], valueList[9], valueList[10], valueList[12], valueList[13], valueList[14]);
				}
				var scaleXMLList:XMLList = coordXML.scale;
				total = scaleXMLList.length();
				for (j = 0; j<total; j++) {
					var scaleXML:XML = scaleXMLList[j];
					value = scaleXML;
					valueList = value.split(' ');
					if (coordinatesTransform) {
						_scaleVertices(childCoord, valueList[0], valueList[2], valueList[1]);
					} else {
						_scaleVertices(childCoord, valueList[0], valueList[1], valueList[2]);
					}
				}
				if (coordinatesTransform) matrix.coordinatesTransform();
				childCoord.localMatrix = matrix;
				_transformVertices(childCoord);
				_readCoord(childCoord, coordXML, coordinatesTransform);
			}
		}
		private function _scaleVertices(coord:Coordinates3D, scaleX:Number, scaleY:Number, scaleZ:Number):void {
			var length:int = meshObjects.length;
			for (var i:int = 0; i<length; i++) {
				var mo:MeshObject = meshObjects[i];
				if (mo.name == coord.name) {
					var vertexList:Vector.<Vertex3D> = mo.vertices;
					var max:int = vertexList.length;
					for (var j:int = 0; j<max; j++) {
						var v:Vertex3D = vertexList[j];
						v.localX *= scaleX;
						v.localY *= scaleY;
						v.localZ *= scaleZ;
					}
					break;
				}
			}
		}
		private function _transformVertices(coord:Coordinates3D):void {
			var length:int = meshObjects.length;
			for (var i:int = 0; i<length; i++) {
				var mo:MeshObject = meshObjects[i];
				if (mo.name == coord.name) {
					var m:GLMatrix3D = coord.worldMatrix;
					var vertexList:Vector.<Vertex3D> = mo.vertices;
					var max:int = vertexList.length;
					for (var j:int = 0; j<max; j++) {
						var v:Vertex3D = vertexList[j];
						var x:Number = v.localX;
						var y:Number = v.localY;
						var z:Number = v.localZ;
						v.localX = x*m.a+y*m.b+z*m.c+m.tx;
						v.localY = x*m.d+y*m.e+z*m.f+m.ty;
						v.localZ = x*m.g+y*m.h+z*m.i+m.tz;
					}
					break;
				}
			}
		}
	}
}