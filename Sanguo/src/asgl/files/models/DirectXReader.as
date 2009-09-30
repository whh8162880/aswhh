package asgl.files.models {
	import __AS3__.vec.Vector;
	
	import asgl.animation.BoneAnimator;
	import asgl.bones.Bone;
	import asgl.data.indices.FaceVertexIndex;
	import asgl.data.indices.MaterialFaceIndex;
	import asgl.data.info.BoneAnimatorMatrixInfo;
	import asgl.events.FileEvent;
	import asgl.files.AbstractFile;
	import asgl.math.GLMatrix3D;
	import asgl.math.UV;
	import asgl.math.Vertex3D;
	import asgl.mesh.MeshObject;
	
	public class DirectXReader extends AbstractFile {
		public var boneAnimator:BoneAnimator;
		public var boneAnimatorMatrixInfo:Vector.<BoneAnimatorMatrixInfo>;
		public var meshObjects:Vector.<MeshObject>;
		private var _coordinatesTransform:Boolean;
		private var _boneClass:Class;
		public function DirectXReader(data:String=null, coordinatesTransform:Boolean=false, rootBones:Vector.<Bone>=null, boneClass:Class=null):void {
			if (data == null) {
				clear();
			} else {
				read(data, coordinatesTransform, rootBones, boneClass);
			}
		}
		public override function clear():void {
			super.clear();
			boneAnimator = new BoneAnimator();
			boneAnimatorMatrixInfo = new Vector.<BoneAnimatorMatrixInfo>();
			meshObjects = new Vector.<MeshObject>();
			_boneClass = null;
		}
		public function read(data:String, coordinatesTransform:Boolean=false, rootBones:Vector.<Bone>=null, boneClass:Class=null):void {
			clear();
			try {
				_coordinatesTransform = coordinatesTransform;
				_boneClass = boneClass;
				if (_boneClass == null) _boneClass = Bone;
				var tempBoneVertexList:Array = [];
				var list:Array = data.split('\n');
				var length:int = list.length;
				var vertexList:Vector.<Vertex3D>;
				var materialFaceIndex:MaterialFaceIndex;
				var bone:Bone;
				var count:int;
				var start:int;
				var end:int
				var i:int;
				var j:int;
				var index:int;
				var isReadBoneList:Boolean = false;
				if (rootBones != null) {
					isReadBoneList = true;
					var totalRootBones:int = rootBones.length;
					for (i = 0; i<totalRootBones; i++) {
						var rootBone:Bone = rootBones[i];
						boneAnimator.rootBones.push(rootBone);
						boneAnimator.addBone(rootBone);
						_readChildBoneFromBone(rootBone);
					}
				}
				for (i = 0; i<length; i++) {
					var line:String = list[i];
					if (line.indexOf('Frame')>=0) {
						if (list[i+7].indexOf(' Mesh  {')>=0 || list[i+14].indexOf(' Mesh  {')>=0) {
							var meshObject:MeshObject = new MeshObject();
							meshObjects.push(meshObject);
							meshObject.name = line.substr(6, line.lastIndexOf('{')-7);
							count = 1;
							for (j = i+1; j<length; j++) {
								i++;
								line = list[i];
								start = line.indexOf('{');
								end = line.indexOf('}');
								if (start>=0) count++;
								if (end>=0) count--;
								
								var matrix:GLMatrix3D;
								if (line.indexOf('FrameTransformMatrix {')>=0) {
									i++;
									j++;
									var marr:Array = list[i].substr(2).split(',');
									matrix = new GLMatrix3D(marr[0], marr[4], marr[8], marr[1], marr[5], marr[9], marr[2], marr[6], marr[10], marr[12], marr[13], marr[14]);
									if (_coordinatesTransform) matrix.coordinatesTransform();
									
								} else if (line.indexOf('Mesh  {')>=0) {
									i++;
									j++;
									line = list[i];
									var vn:int = int(line.substr(0, line.lastIndexOf(';')));
									vertexList = meshObject.vertices;
									for (var v:int = 0; v<vn; v++) {
										i++;
										j++;
										var varr:Array = list[i].substr(2).split(';');
										var vertex:Vertex3D;
										if (_coordinatesTransform) {
											vertex = new Vertex3D(varr[0], varr[2], varr[1]);
										} else {
											vertex = new Vertex3D(varr[0], varr[1], varr[2]);
										}
										//trace(vertex, matrix);
										vertex.sourceX = vertex.localX;
										vertex.sourceY = vertex.localY;
										vertex.sourceZ = vertex.localZ;
										vertex.transformLocalSpace(matrix);
										//vertex.sourceX = vertex.x;
										//vertex.sourceY = vertex.y;
										//vertex.sourceZ = vertex.z;
										//trace(vertex, matrix);
										vertexList.push(vertex);
									}
									i++;
									j++;
									line = list[i];
									var fn:int = int(line.substr(0, line.lastIndexOf(';')));
									var faceVertexIndexList:Vector.<FaceVertexIndex> = meshObject.faceVertexIndices;
									materialFaceIndex = new MaterialFaceIndex();
									for (var f:int = 0; f<fn; f++) {
										i++;
										j++;
										var farr:Array = list[i].split(';')[1].split(',');
										if (_coordinatesTransform) {
											faceVertexIndexList.push(new FaceVertexIndex(farr[1], farr[0], farr[2]));
										} else {
											faceVertexIndexList.push(new FaceVertexIndex(farr[0], farr[1], farr[2]));
										}
										materialFaceIndex.addIndex(f);
									}
								} else if (line.indexOf('Material ')>=0) {
									var a:int = line.indexOf('Material ')+9;
									materialFaceIndex.materialName = line.substr(a, line.lastIndexOf('}')-a-1);
									var materialFaceIndexList:Vector.<MaterialFaceIndex> = new Vector.<MaterialFaceIndex>();
									materialFaceIndexList.push(materialFaceIndex);
									meshObject.materialFaceIndices = materialFaceIndexList;
									//trace(textureName);
								} else if (line.indexOf('MeshMaterialList ')>=0) {
									i++;
									j++;
									line = list[i];
									var a2:int = int(list[i].split(';')[0]);
									var mfiList:Array = [];
									for (var k:int = 0; k<a2; k++) {
										mfiList[k] = new MaterialFaceIndex();
									}
									i++;
									j++;
									a2 = int(list[i].split(';')[0]);
									i++;
									j++;
									for (k = 0; k<a2; k++) {
										mfiList[int(list[i+k].split(',')[0])].addIndex(k);
									}
									i += a2;
									j += a2;
									a2 = mfiList.length;
									var materialFaceIndexList2:Vector.<MaterialFaceIndex> = new Vector.<MaterialFaceIndex>();
									meshObject.materialFaceIndices = materialFaceIndexList2;
									for (k = 0; k<a2; k++) {
										line = list[i+k];
										mfiList[k].materialName = line.substring(line.indexOf('{')+2, line.lastIndexOf('}')-1);
										materialFaceIndexList2.push(mfiList[k]);
									}
									a2--;
									i += a2;
									j += a2;
								} else if (line.indexOf('MeshTextureCoords  {')>=0) {
									var uvList:Vector.<UV> = new Vector.<UV>();
									meshObject.uvs = uvList;
									i++;
									j++;
									line = list[i];
									var uvn:int = int(line.substr(0, line.lastIndexOf(';')));
									for (var uv:int = 0; uv<uvn; uv++) {
										i++;
										j++;
										var uvarr:Array = list[i].substr(3).split(';');
										uvList.push(new UV(uvarr[0], uvarr[1]));
										//textureFaceIndex.addFaceIndex(uv);
									}
								} else if (line.indexOf('SkinWeights {')>=0) {
									i++;
									j++;
									line = list[i];
									index = line.indexOf('"')+1;
									var boneName:String = line.substr(index, line.lastIndexOf('"')-index)
									bone = boneAnimator.getBoneByName(boneName);
									//trace(boneName);
									var arr:Array;
									if (bone == null) {
										//trace(boneName);
										arr = [boneName];
										tempBoneVertexList.push(arr);
										//arr = tempBoneVertexList[tempBoneVertexList.length-1];
									}
									
									i++;
									j++;
									vertexList = meshObject.vertices;
									var bn:int = int(list[i].split(';')[0]);
									
									var blmarr:Array = list[i+bn*2+1].split(';')[0].split(' ');
									blmarr = blmarr[blmarr.length-1].split(',');
									matrix = new GLMatrix3D(blmarr[0], blmarr[4], blmarr[8], blmarr[1], blmarr[5], blmarr[9], blmarr[2], blmarr[6], blmarr[10], blmarr[12], blmarr[13], blmarr[14]);
									if (_coordinatesTransform) matrix.coordinatesTransform();
									//if (bone != null && bone.offsetMatrix == null) bone.offsetMatrix = matrix;
									var kk:int = 0;
									for (var b:int = 0; b<bn; b++) {
										i++;
										j++;
										var l1:String = list[i];
										var l2:String = list[i+bn];
										var bv:Vertex3D = vertexList[int(l1.substr(0, l1.length-1))];
										//bv.transform.matrix = matrix;
										var bvw:Number = Number(l2.substr(0, l2.length-1));
										if (bone == null) {
											kk++;
											arr.push([bv, bvw, matrix]);
										} else {
											boneAnimator.addVertex(bv, bvw, bone, matrix);
											//bone.addVertex(bv, bvw);
										}
									}
								}
								
								if (count == 0) break;
							}
						} else if (list[i+7].substr(0, 7) == ' Frame ') {
							bone = new _boneClass();
							if (!isReadBoneList) boneAnimator.rootBones.push(bone);
								
							i = _readBoneFromModel(i, length, list, bone, isReadBoneList);
						}
					} else if (line.substr(0, 13) == 'AnimationSet ') {
						count = 1;
						for (j = i+1; j<length; j++) {
							i++;
							line = list[i];
							start = line.indexOf('{');
							end = line.indexOf('}');
							if (start>=0) count++;
							if (end>=0) count--;
							
							if (line.indexOf(' Animation ')>=0) {
								count++;
								i += 2;
								j += 2;
								line = list[i];
								index = line.indexOf('{ ');
								var info:BoneAnimatorMatrixInfo = new BoneAnimatorMatrixInfo();
								boneAnimatorMatrixInfo.push(info);
								info.boneName = line.substr(index+2, line.lastIndexOf(' }')-index-2);
								var matrixList:Vector.<GLMatrix3D> = info.matrices;
								var timeList:Vector.<Number> = info.timeList;
								
								while (true) {
									i++;
									j++;
									if (list[i].indexOf(' AnimationKey {')>=0) {
										i += 2;
										j += 2;
										break;
									}
								}
								
								var max:int = int(list[i].split(';')[0]);
								for (var m:int = 0; m<max; m++) {
									i++;
									var temparr:Array = list[i].split(';');
									var bmarr:Array = temparr[2].split(',');
									var mat:GLMatrix3D = new GLMatrix3D(bmarr[0], bmarr[4], bmarr[8], bmarr[1], bmarr[5], bmarr[9], bmarr[2], bmarr[6], bmarr[10], bmarr[12], bmarr[13], bmarr[14]);
									if (_coordinatesTransform) mat.coordinatesTransform();
									matrixList[m] = mat;
									timeList[m] = int(temparr[0]);
								}
								j += max;
							}
							
							if (count == 0) break;
						}
					}
				}
				for (i = tempBoneVertexList.length-1; i>=0; i--) {
					var bvarr:Array = tempBoneVertexList[i];
					bone = boneAnimator.getBoneByName(bvarr[0]);
					if (bone == null) {
						continue;
					} else {
						//if (bone.offsetMatrix == null) bone.offsetMatrix = bvarr[j][2];
					}
					for (j = bvarr.length-1; j>=1; j--) {
						boneAnimator.addVertex(bvarr[j][0], bvarr[j][1], bone, bvarr[j][2]);
						//bone.addVertex(bvarr[j][0], bvarr[j][1]);
					}
				}
				_boneClass = null;
				_isCorrectFormat = true;
				this.dispatchEvent(new FileEvent(FileEvent.COMPLETE));
			} catch (e:Error) {
				clear();
				this.dispatchEvent(new FileEvent(FileEvent.ERROR, e));
			}
		}
		private function _readBoneFromModel(i:int, length:int, list:Array, bone:Bone, isReadBoneList:Boolean):int {
			var line:String;
			var count:int = 1;
			if (!isReadBoneList) {
				var name:String = list[i].split('Frame')[1];
				bone.name = name.substr(1, name.length-3);
				//trace(bone.name);
				boneAnimator.addBone(bone);
				
				
				var marr:Array = list[i+4].split(' ');
				marr = marr[marr.length-1].split(',');
				var matrix:GLMatrix3D = new GLMatrix3D(marr[0], marr[4], marr[8], marr[1], marr[5], marr[9], marr[2], marr[6], marr[10], marr[12], marr[13], marr[14]);
				if (_coordinatesTransform) matrix.coordinatesTransform();
				bone.localMatrix = matrix;
			}
			
			for (var j:int = i+1; j<length; j++) {
				i++;
				line = list[i];
				var start:int = line.indexOf('{');
				var end:int = line.indexOf('}');
				if (start>=0) count++;
				if (end>=0) count--;
				
				if (line.indexOf('Frame')>=0) {
					var header:String = line.split('Frame')[1];
					if (header != ' {' && header != 'TransformMatrix {') {
						var childBone:Bone = new _boneClass();
						if (!isReadBoneList) bone.addChild(childBone);
						i = _readBoneFromModel(i, length, list, childBone, isReadBoneList);
						count--;
					}
				}
				
				if (count == 0) break;
			}
			return i;
		}
		private function _readChildBoneFromBone(parentBone:Bone):void {
			var count:int = 0;
			while (true) {
				var childBone:Bone = parentBone.getChildAt(count) as Bone;
				if (childBone == null) {
					break;
				} else {
					count++;
					boneAnimator.addBone(childBone);
					_readChildBoneFromBone(childBone);
				}
			}
		}
	}
}