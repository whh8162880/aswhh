package asgl.files.models {
	import __AS3__.vec.Vector;
	
	import asgl.data.indices.FaceVertexIndex;
	import asgl.data.indices.MaterialFaceIndex;
	import asgl.data.info.Camera3DInfo;
	import asgl.events.FileEvent;
	import asgl.files.AbstractFile;
	import asgl.math.UV;
	import asgl.math.Vertex3D;
	import asgl.mesh.MeshObject;
	import asgl.mesh.MeshObjectType;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class Max3DSReader extends AbstractFile {
		public var meshObjects:Vector.<MeshObject>;
		private var _bytes:ByteArray;
		private var _totalFaces:int;
		private var _totalFrames:int;
		private var _version:int;
		public function Max3DSReader(bytes:ByteArray=null, coordinatesTransform:Boolean=false):void {
			if (bytes == null) {
				clear();
			} else {
				read(bytes, coordinatesTransform);
			}
		}
		public function get materialNameList():Array {
			return hide::cloneList();
		}
		public function get totalFaces():int {
			return _totalFaces;
		}
		public function get totalFrames():int {
			return _totalFrames;
		}
		public function get version():int {
			return _version;
		}
		public override function clear():void {
			super.clear();
			meshObjects = new Vector.<MeshObject>();
			_totalFaces = 0;
			_totalFrames = 0;
			_version = 0;
			_list = [];
		}
		public function read(bytes:ByteArray, coordinatesTransform:Boolean=false):void {
			clear();
			try {
				bytes.position = 0;
				_bytes = bytes;
				_bytes.endian = Endian.LITTLE_ENDIAN;
				var max:int;
				var i:int;
				var str:String;
				var postiion:int;
				var meshObject:MeshObject;
				var maxLength:int = _bytes.length;
				while(_bytes.position<maxLength) {
					var header:uint = _bytes.readUnsignedShort();
					var length:uint = _bytes.readUnsignedInt();
					var index1:int;
					var index2:int;
					var sourceX:Number;
					var sourceY:Number;
					var sourceZ:Number;
					switch (header) {
						case Max3DSChunk.MAIN3DS: {
							break;
						}
						case Max3DSChunk.EDIT3DS: {
							break;
						}
						case Max3DSChunk.VERSION: {
							postiion = _bytes.position;
							_version = _bytes.readUnsignedShort();
							_bytes.position = postiion+length-6;
							break;
						}
						case Max3DSChunk.LIGHT: {
							meshObject.type = MeshObjectType.LIGHT;
							_bytes.readFloat();
							_bytes.readFloat();
							_bytes.readFloat();
							break;
						}
						case Max3DSChunk.EDIT_MATERIAL: {
							break;
						}
						case Max3DSChunk.MAT_NAME: {
							str = _readString();
							break;
						}
						case Max3DSChunk.MAT_MAP: {
							break;
						}
						case Max3DSChunk.MAT_PATH: {
							str = _readString();
							break;
						}
						case Max3DSChunk.OBJ_TRIMESH: {
							break;
						}
						case Max3DSChunk.OBJ_CAMERA: {
							meshObject.type = MeshObjectType.CAMERA;
							var cameraInfo:Camera3DInfo = new Camera3DInfo();
							sourceX = _bytes.readFloat();
							sourceY = _bytes.readFloat();
							sourceZ = _bytes.readFloat();
							if (coordinatesTransform) {
								cameraInfo.origin = new Vertex3D(sourceX, sourceZ, sourceY);
							} else {
								cameraInfo.origin = new Vertex3D(sourceX, sourceY, sourceZ);
							}
							sourceX = _bytes.readFloat();
							sourceY = _bytes.readFloat();
							sourceZ = _bytes.readFloat();
							if (coordinatesTransform) {
								cameraInfo.target = new Vertex3D(sourceX, sourceZ, sourceY);
							} else {
								cameraInfo.target = new Vertex3D(sourceX, sourceY, sourceZ);
							}
							cameraInfo.angle = _bytes.readFloat();
							cameraInfo.viewAngle = _bytes.readFloat();
							meshObject.cameraInfo = cameraInfo;
							break;
						}
						case Max3DSChunk.EDIT_OBJECT: {
							meshObject = new MeshObject();
							meshObject.name = _readString()
							meshObjects.push(meshObject);
							break;
						}
						//EDIT_OBJECT START:
						case Max3DSChunk.TRI_VERTEX: {
							max = _bytes.readShort();
							for (i = 0; i<max; i++) {
								sourceX = _bytes.readFloat();
								sourceY = _bytes.readFloat();
								sourceZ = _bytes.readFloat();
								if (coordinatesTransform) {
									meshObject.vertices.push(new Vertex3D(sourceX, sourceZ, sourceY));
								} else {
									meshObject.vertices.push(new Vertex3D(sourceX, sourceY, sourceZ));
								}
							}
							break;
						}
						case Max3DSChunk.TRI_FACEVERT: {
							max = _bytes.readShort();
							_totalFaces += max;
							for (i = 0; i<max; i++) {
								index1 = _bytes.readShort();
								index2 = _bytes.readShort();
								if (coordinatesTransform) {
									meshObject.faceVertexIndices.push(new FaceVertexIndex(index2, index1, _bytes.readShort()));
								} else {
									meshObject.faceVertexIndices.push(new FaceVertexIndex(index1, index2, _bytes.readShort()));
								}
								_bytes.readShort();
							}
							break;
						}
						case Max3DSChunk.TRI_FACEMAT: {
							var materialName:String = _readString();
							if (_list.indexOf(materialName) == -1) _list.push(materialName);
							var materialFaceIndex:MaterialFaceIndex = new MaterialFaceIndex(materialName);
							max = _bytes.readShort();
							for (i = 0; i<max; i++) {
								materialFaceIndex.addIndex(_bytes.readShort());
							}
							if (meshObject.materialFaceIndices == null) meshObject.materialFaceIndices = new Vector.<MaterialFaceIndex>();
							meshObject.materialFaceIndices.push(materialFaceIndex);
							break;
						}
						case Max3DSChunk.TRI_UV: {
							meshObject.type = MeshObjectType.OBJECT;
							max = _bytes.readShort();
							var uvList:Vector.<UV> = new Vector.<UV>();
							meshObject.uvs = uvList;
							for (i = 0; i<max; i++) {
								uvList.push(new UV(_bytes.readFloat(), 1-_bytes.readFloat()));
							}
							break;
						}
						case Max3DSChunk.TRI_LOCAL: {
							_bytes.readFloat();
							_bytes.readFloat();
							_bytes.readFloat();
							_bytes.readFloat();
							_bytes.readFloat();
							_bytes.readFloat();
							_bytes.readFloat();
							_bytes.readFloat();
							_bytes.readFloat();
							_bytes.readFloat();
							_bytes.readFloat();
							_bytes.readFloat();
							break;
						}
						//EDIT_OBJECT END:
						case Max3DSChunk.KEYF3DS: {
							break;
						}
						//KEYF3DS START:
						case Max3DSChunk.KEYF_OBJDES: {
							break;
						}
						case Max3DSChunk.KEYF_FRAMES: {
							_bytes.readUnsignedInt();
							_totalFrames = _bytes.readUnsignedInt();
							break;
						}
						case Max3DSChunk.KEYF_OBJHIERARCH: {
							_readString();
							//not use
							_bytes.readShort();
							_bytes.readShort();
							//
							_bytes.readShort();
							break;
						}
						case 0xb011: {
							//trace('0xb011');
							break;
						}
						case Max3DSChunk.KEYF_PIVOTPOINT: {
							_bytes.readFloat();
							_bytes.readFloat();
							_bytes.readFloat();
							break;
						}
						case 0xb014: {
							//trace('0xb014');
							break;
						}
						case 0xb015: {
							//trace('0xb015');
							break;
						}
						case Max3DSChunk.KEYF_OBJPIVOT: {
							//not use
							_bytes.readShort();
							_bytes.readShort();
							_bytes.readShort();
							_bytes.readShort();
							_bytes.readShort();
							//
							max = _bytes.readShort();
							for (i = 0; i<max; i++) {
								_bytes.readShort();
								_bytes.readUnsignedInt();
								_bytes.readFloat();
								_bytes.readFloat();
								_bytes.readFloat();
							}
							break;
						}
						case 0xb021: {
							//trace('0xb021');
							break;
						}
						case 0xb022: {
							//trace('0xb022');
							break;
						}
						case 0xb030: {
							_bytes.readShort();
							break;
						}
						//KEYF3DS END:
						default : {
							//trace(header.toString(16));
							//trace(_byteArray.readUTFBytes(length-6));
							_bytes.position += length-6;
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
		private function _readString():String {
			var n:int;
			var str:String = '';
			do {
				n = _bytes.readByte();
				if (n == 0) {
					break;
				}
				str += String.fromCharCode(n);
			} while (true);
			return str;
		}
	}
}