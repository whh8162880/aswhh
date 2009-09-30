package asgl.files.models {
	import __AS3__.vec.Vector;
	
	import asgl.animation.BoneAnimator;
	import asgl.bones.Bone;
	import asgl.data.indices.FaceUVIndex;
	import asgl.data.indices.FaceVertexIndex;
	import asgl.data.indices.MaterialFaceIndex;
	import asgl.events.FileEvent;
	import asgl.files.AbstractFile;
	import asgl.math.GLMatrix3D;
	import asgl.math.UV;
	import asgl.math.Vertex3D;
	import asgl.mesh.MeshObject;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class ASMeshReader extends AbstractFile {
		public static const BONE_MESH:String = 'boneMesh';
		public static const STATIC_MESH:String = 'staticMesh';
		public var boneAnimator:BoneAnimator;
		public var meshObjects:Vector.<MeshObject>;
		private static var _boneIndex:int;
		private var _meshType:String;
		public function ASMeshReader(bytes:ByteArray=null, coordinatesTransform:Boolean=false, rootBones:Vector.<Bone>=null):void {
			if (bytes == null) {
				clear();
			} else {
				read(bytes, coordinatesTransform, rootBones);
			}
		}
		public function get meshType():String {
			return _meshType;
		}
		public override function clear():void {
			super.clear();
			boneAnimator = new BoneAnimator();
			meshObjects = new Vector.<MeshObject>();
			_meshType = null;
		}
		public function read(bytes:ByteArray, coordinatesTransform:Boolean=false, rootBones:Vector.<Bone>=null):void {
			clear();
			try {
				bytes.endian = Endian.LITTLE_ENDIAN;
				bytes.position = 6;
				var mainProperty:uint = bytes.readUnsignedByte();
				_meshType = (mainProperty>>2&1) == 0 ? STATIC_MESH : BONE_MESH;
				var isBoneMesh:Boolean = _meshType == BONE_MESH;
				if (mainProperty&1 == 1) {
					var temp:ByteArray = new ByteArray();
					temp.endian = Endian.LITTLE_ENDIAN;
					temp.writeBytes(bytes, 7, bytes.length-7);
					temp.uncompress();
					bytes = temp;
				}
				bytes.position += 2;
				var vertexArray:Vector.<Vertex3D>;
				var bone:Bone;
				var mo:MeshObject;
				var total:int;
				var max:int;
				var i:int;
				var j:int;
				var index0:int;
				var index1:int;
				var v:Vertex3D;
				while (bytes.bytesAvailable>5) {
					var chunk:uint = bytes.readUnsignedShort();
					var length:uint = bytes.readUnsignedInt();
					var pos:uint = bytes.position;
					switch (chunk) {
						case ASMeshChunk.MAIN: {
							break;
						}
						case ASMeshChunk.PROPERTY: {
							break;
						}
						case ASMeshChunk.MESH: {
							var nameLength:int = bytes.readUnsignedByte();
							mo = new MeshObject(bytes.readMultiByte(nameLength, characterSet));
							meshObjects.push(mo);
							break;
						}
						case ASMeshChunk.MESH_VERTEX_LIST: {
							vertexArray = mo.vertices;
							total = bytes.readUnsignedShort();
							for (i = 0; i<total; i++) {
								v = new Vertex3D();
								vertexArray[i] = v;
								if (isBoneMesh) {
									v.sourceX = bytes.readFloat();
									if (coordinatesTransform) {
										v.sourceZ = bytes.readFloat();
										v.sourceY = bytes.readFloat();
									} else {
										v.sourceY = bytes.readFloat();
										v.sourceZ = bytes.readFloat();
									}
								} else {
									v.localX = bytes.readFloat();
									if (coordinatesTransform) {
										v.localZ = bytes.readFloat();
										v.localY = bytes.readFloat();
									} else {
										v.localY = bytes.readFloat();
										v.localZ = bytes.readFloat();
									}
								}
							}
							break;
						}
						case ASMeshChunk.MESH_UV_LIST: {
							mo.uvs = new Vector.<UV>();
							var uvArray:Vector.<UV> = mo.uvs;
							total = bytes.readUnsignedShort();
							for (i = 0; i<total; i++) {
								uvArray[i] = new UV(bytes.readFloat(), bytes.readFloat());
							}
							break;
						}
						case ASMeshChunk.MESH_FACE_VERTEX_INDEX: {
							var fviArray:Vector.<FaceVertexIndex> = mo.faceVertexIndices;
							total = bytes.readUnsignedShort();
							for (i = 0; i<total; i++) {
								index0 = bytes.readUnsignedShort();
								index1 = bytes.readUnsignedShort();
								if (coordinatesTransform) {
									fviArray[i] = new FaceVertexIndex(index1, index0, bytes.readUnsignedShort());
								} else {
									fviArray[i] = new FaceVertexIndex(index0, index1, bytes.readUnsignedShort());
								}
							}
							break;
						}
						case ASMeshChunk.MESH_FACE_UV_INDEX: {
							mo.faceUVIndices = new Vector.<FaceUVIndex>();
							var fuvi:Vector.<FaceUVIndex> = mo.faceUVIndices;
							total = bytes.readUnsignedShort();
							for (i = 0; i<total; i++) {
								index0 = bytes.readUnsignedShort();
								index1 = bytes.readUnsignedShort();
								if (coordinatesTransform) {
									fuvi[i] = new FaceUVIndex(index1, index0, bytes.readUnsignedShort());
								} else {
									fuvi[i] = new FaceUVIndex(index0, index1, bytes.readUnsignedShort());
								}
							}
							break;
						}
						case ASMeshChunk.MESH_MATERIAL_FACE_INDEX: {
							if (mo.materialFaceIndices == null) mo.materialFaceIndices = new Vector.<MaterialFaceIndex>();
							total = bytes.readShort();
							for (i = 0; i<total; i++) {
								var mfi:MaterialFaceIndex = new MaterialFaceIndex(bytes.readUTFBytes(bytes.readUnsignedByte()));
								max = bytes.readShort();
								for (j = 0; j<max; j++) {
									mfi.addIndex(bytes.readShort());
								}
								mo.materialFaceIndices.push(mfi);
							}
							break;
						}
						case ASMeshChunk.MESH_BONE: {
							if (isBoneMesh) {
								boneAnimator.rootBones = rootBones;
								max = rootBones.length;
								for (i = 0; i<max; i++) {
									bone = rootBones[i];
									boneAnimator.addBone(bone);
									_addBone(bone);
								}
								total = vertexArray.length;
								for (i = 0; i<total; i++) {
									v = vertexArray[i];
									max = bytes.readUnsignedByte();
									for (j = 0; j<max; j++) {
										bone = boneAnimator.getBoneByName(bytes.readUTFBytes(bytes.readUnsignedByte()));
										var weight:Number = bytes.readFloat();
										var m:GLMatrix3D = new GLMatrix3D(bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat());
										if (coordinatesTransform) m.coordinatesTransform();
										boneAnimator.addVertex(v, weight, bone, m);
									}
								}
							}
							break;
						}
						default : {
							bytes.position = pos;
							bytes.position += length;
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
		private function _addBone(bone:Bone):void {
			var total:int = bone.totalChildBones;
			for (var i:int = 0; i<total; i++) {
				var child:Bone = bone.getChildBoneAt(i);
				boneAnimator.addBone(child);
				_addBone(child);
			}
		}
	}
}