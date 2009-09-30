package asgl.files.models {
	import __AS3__.vec.Vector;
	
	import asgl.animation.BoneAnimator;
	import asgl.bones.Bone;
	import asgl.data.indices.FaceVertexIndex;
	import asgl.data.indices.MaterialFaceIndex;
	import asgl.events.FileEvent;
	import asgl.files.AbstractFile;
	import asgl.math.GLMatrix3D;
	import asgl.math.Quaternion;
	import asgl.math.UV;
	import asgl.math.Vertex3D;
	import asgl.mesh.MeshObject;
	
	public class MD5MeshReader extends AbstractFile {
		public var boneAnimator:BoneAnimator;
		public var meshObjects:Vector.<MeshObject>;
		private var _boneList:Array;
		private var _coordinatesTransform:Boolean;
		public function MD5MeshReader(data:String=null, coordinatesTransform:Boolean=false):void {
			if (data == null) {
				clear();
			} else {
				read(data, coordinatesTransform);
			}
		}
		public override function clear():void {
			super.clear();
			_boneList = [];
			_coordinatesTransform = false;
			boneAnimator = new BoneAnimator();
			meshObjects = new Vector.<MeshObject>();
		}
		public function read(data:String, coordinatesTransform:Boolean=false):void {
			clear();
			try {
				_coordinatesTransform = coordinatesTransform;
				var dataList:Array = data.split('\n');
				var mainLength:int = dataList.length;
				var index:int;
				var j:int;
				var max:int;
				var list:Array;
				var vertexWeightInfoList:Array = [];
				var bone:Bone;
				var vertexList:Vector.<Vertex3D>;
				for (var i:int = 0; i<mainLength; i++) {
					var line:String = dataList[i];
					if (line.indexOf('joints {') != -1) {
						while (true) {
							i++;
							line = dataList[i];
							if (line.indexOf('}') != 0) {
								bone = new Bone();
								index = line.lastIndexOf('"');
								var name:String = line.substring(line.indexOf('"')+1, index);
								bone.name = name
								line = line.substr(index+1);
								index = line.indexOf('(');
								var node:int = int(line.substr(0, index));
								if (node == -1) boneAnimator.rootBones.push(bone);
								list = line.substring(index+1, line.indexOf(')')).split(' ');
								_removeEmptyArrayElement(list);
								var boneInfoList:Array = [bone, node, list[0], list[1], list[2]];
								_boneList.push(name, boneInfoList);
								line = line.substr(line.indexOf(')')+1);
								list = line.substring(line.indexOf('(')+1, line.lastIndexOf(')')).split(' ');
								_removeEmptyArrayElement(list);
								boneInfoList.push(list[0], list[1], list[2]);
								boneAnimator.addBone(bone);
							} else {
								max = _boneList.length;
								for (j = 1; j<max; j+=2) {
									list = _boneList[j];
									index = list[1];
									if (index != -1) _boneList[index*2+1][0].addChildBone(list[0]);
								}
								max = boneAnimator.rootBones.length;
								for (j = 0; j<max; j++) {
									_setBone(boneAnimator.rootBones[j]);
								}
								break;
							}
						}
					} else if (line.indexOf('mesh {') != -1) {
						var meshObject:MeshObject = new MeshObject();
						meshObjects.push(meshObject);
						var materialFaceIndex:MaterialFaceIndex = null;
						while (true) {
							i++;
							line = dataList[i];
							if (line.indexOf('}') != 0) {
								if (line.indexOf('// meshes:') != -1) {
									meshObject.name = line.substr(line.indexOf('// meshes:')+11);
								} else if (line.indexOf('shader') != -1) {
									var materialFaceIndexList:Vector.<MaterialFaceIndex> = meshObject.materialFaceIndices;
									if (materialFaceIndexList == null) {
										materialFaceIndexList = new Vector.<MaterialFaceIndex>();
										meshObject.materialFaceIndices = materialFaceIndexList;
									}
									materialFaceIndex = new MaterialFaceIndex(line.substring(line.indexOf('"')+1, line.lastIndexOf('"')));
									materialFaceIndexList.push(materialFaceIndex);
								} else if (line.indexOf('numverts') != -1) {
									max = int(line.substr(line.indexOf('numverts')+8));
									vertexList = meshObject.vertices;
									var uvList:Vector.<UV> = new Vector.<UV>();
									meshObject.uvs = uvList;
									for (j = 0; j<max; j++) {
										i++;
										line = dataList[i];
										vertexList.push(new Vertex3D());
										index = line.lastIndexOf(')');
										list = line.substring(line.indexOf('(')+1, index).split(' ');
										_removeEmptyArrayElement(list);
										uvList.push(new UV(list[0], list[1]));
										list = line.substr(index+1).split(' ');
										_removeEmptyArrayElement(list);
										vertexWeightInfoList.push(list);
									}
								} else if (line.indexOf('numtris') != -1) {
									max = int(line.substr(line.indexOf('numtris')+7));
									var faceVertexIndexList:Vector.<FaceVertexIndex> = meshObject.faceVertexIndices;
									for (j = 0; j<max; j++) {
										i++;
										line = dataList[i];
										list = line.substr(line.indexOf('tri')+3).split(' ');
										_removeEmptyArrayElement(list);
										if (_coordinatesTransform) {
											faceVertexIndexList.push(new FaceVertexIndex(list[2], list[1], list[3]));
										} else {
											faceVertexIndexList.push(new FaceVertexIndex(list[1], list[2], list[3]));
										}
										if (materialFaceIndex != null) materialFaceIndex.addIndex(j);
									}
								} else if (line.indexOf('numweights') != -1) {
									max = int(line.substr(line.indexOf('numweights')+10));
									var weightList:Array = [];
									for (j = 0; j<max; j++) {
										i++;
										line = dataList[i];
										index = line.indexOf('(');
										list = line.substring(line.indexOf('weight')+6, index).split(' ');
										_removeEmptyArrayElement(list);
										var infoList:Array = [list[1], list[2]];
										weightList.push(infoList);
										list = line.substring(index+1, line.lastIndexOf(')')).split(' ');
										_removeEmptyArrayElement(list);
										infoList.push(list[0], list[1], list[2]);
									}
									max = vertexWeightInfoList.length;
									for (j = 0; j<max; j++) {
										index = vertexWeightInfoList[j][0];
										var length:int = vertexWeightInfoList[j][1];
										var x:Number = 0;
										var y:Number = 0;
										var z:Number = 0;
										for (var m:int = 0; m<length; m++) {
											list = weightList[index+m];
											var weight:Number = list[1];
											x += weight*list[2];
											if (_coordinatesTransform) {
												y += weight*list[4];
												z += weight*list[3];
											} else {
												y += weight*list[3];
												z += weight*list[4];
											}
										}
										var vertex:Vertex3D = vertexList[j];
										vertex.sourceX = x;
										vertex.sourceY = y;
										vertex.sourceZ = z;
										for (m = 0; m<length; m++) {
											list = weightList[index+m];
											bone = _boneList[list[0]*2+1][0];
											boneAnimator.addVertex(vertex, list[1], bone, new GLMatrix3D());
										}
									}
								}
							} else {
								break;
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
		private function _removeEmptyArrayElement(list:Array):void {
			var length:int = list.length;
			for (var i:int = 0; i<length; i++) {
				if (list[i] == '') {
					list.splice(i, 1);
					i--;
					length--;
				}
			}
		}
		private function _setBone(bone:Bone):void {
			var list:Array = _boneList[_boneList.indexOf(bone.name)+1];
			var q:Quaternion = new Quaternion(list[5], list[6], list[7]);
			q.computeW();
			var matrix:GLMatrix3D = q.matrix;
			matrix.tx = list[2];
			matrix.ty = list[3];
			matrix.tz = list[4];
			if (_coordinatesTransform) matrix.coordinatesTransform();
			bone.worldMatrix = matrix;
			var index:int;
			while (true) {
				var child:Bone = bone.getChildAt(index) as Bone;
				if (child == null) {
					break;
				} else {
					_setBone(child);
					index++;
				}
			}
		}
	}
}