package asgl.files.models {
	import __AS3__.vec.Vector;
	
	import asgl.animation.KeyFrame;
	import asgl.animation.KeyFrameAnimator;
	import asgl.data.indices.FaceUVIndex;
	import asgl.data.indices.FaceVertexIndex;
	import asgl.events.FileEvent;
	import asgl.files.AbstractFile;
	import asgl.math.UV;
	import asgl.math.Vertex3D;
	import asgl.mesh.MeshObject;
	import asgl.mesh.MeshObjectType;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class MD2Reader extends AbstractFile {
		public var keyFrameAnimator:KeyFrameAnimator;
		private var _ident:int;
		private var _version:int;
		private var _skinWidth:int;
		private var _skinHeight:int;
		private var _frameSize:int;
		private var _totalSkins:int;
		private var _totalVertices:int;
		private var _totalTextureUVes:int;
		private var _totalFaces:int;
		private var _totalFrames:int;
		private var _ofs_skins:int;
		private var _offsetTextureUVes:int;
		private var _offsetFace:int;
		private var _offsetFrames:int;
		public function MD2Reader(bytes:ByteArray=null, coordinatesTransform:Boolean=false):void {
			if (bytes == null) {
				clear();
			} else {
				read(bytes, coordinatesTransform);
			}
		}
		public function get skinHeight():int {
			return _skinHeight;
		}
		public function get skinWidth():int {
			return _skinWidth;
		}
		public function get totalFaces():int {
			return _totalFaces;
		}
		public function get totalFrames():int {
			return _totalFrames;
		}
		public function get totalSkins():int {
			return _totalSkins;
		}
		public function get totalVertices():int {
			return _totalVertices;
		}
		public function get version():int {
			return _version;
		}
		public override function clear():void {
			super.clear();
			keyFrameAnimator = new KeyFrameAnimator();
			_skinHeight = 0;
			_skinWidth = 0;
			_totalFaces = 0;
			_totalFrames = 0;
			_totalSkins = 0;
			_totalVertices = 0;
			_version = 0;
		}
		public function read(bytes:ByteArray, coordinatesTransform:Boolean=false):void {
			clear();
			try {
				bytes.endian = Endian.LITTLE_ENDIAN;
				bytes.position = 0;
				_ident = bytes.readUnsignedInt();
				_version = bytes.readUnsignedInt();
				_skinWidth = bytes.readUnsignedInt();
				_skinHeight = bytes.readUnsignedInt();
				_frameSize = bytes.readUnsignedInt();
				_totalSkins = bytes.readUnsignedInt();
				_totalVertices = bytes.readUnsignedInt();
				_totalTextureUVes = bytes.readUnsignedInt();
				_totalFaces = bytes.readUnsignedInt();
				bytes.readUnsignedInt();
				_totalFrames = bytes.readUnsignedInt();
				_ofs_skins = bytes.readUnsignedInt();
				_offsetTextureUVes = bytes.readUnsignedInt();
				_offsetFace = bytes.readUnsignedInt();
				_offsetFrames = bytes.readUnsignedInt();
				bytes.readUnsignedInt();
				bytes.readUnsignedInt();
				
				var faceUVIndexList:Vector.<FaceUVIndex> = new Vector.<FaceUVIndex>();
				var faceVertexIndexList:Vector.<FaceVertexIndex> = new Vector.<FaceVertexIndex>();
				var uvList:Vector.<UV> = new Vector.<UV>();
				var vertexIndex1:int;
				var vertexIndex2:int;
				var vertexIndex3:int;
				var uvIndex1:int;
				var uvIndex2:int;
				var sourceX:Number;
				var sourceY:Number;
				var sourceZ:Number;
				
				bytes.position = _offsetTextureUVes;
				for (var i:int = 0; i<_totalTextureUVes; i++) {
					uvList.push(new UV(bytes.readUnsignedShort()/_skinWidth, bytes.readUnsignedShort()/_skinHeight));
				}
				
				bytes.position = _offsetFace;
				for (i = 0; i<_totalFaces; i++) {
					vertexIndex1 = bytes.readUnsignedShort();
					vertexIndex2 = bytes.readUnsignedShort();
					vertexIndex3 = bytes.readUnsignedShort();
					uvIndex1 = bytes.readUnsignedShort();
					uvIndex2 = bytes.readUnsignedShort();
					if (coordinatesTransform) {
						faceVertexIndexList.push(new FaceVertexIndex(vertexIndex2, vertexIndex1, vertexIndex3));
						faceUVIndexList.push(new FaceUVIndex(uvIndex2, uvIndex1, bytes.readUnsignedShort()));
					} else {
						faceVertexIndexList.push(new FaceVertexIndex(vertexIndex1, vertexIndex2, vertexIndex3));
						faceUVIndexList.push(new FaceUVIndex(uvIndex1, uvIndex2, bytes.readUnsignedShort()));
					}
				}
				
				bytes.position = _offsetFrames;
				for (i = 0; i<_totalFrames; i++) {
					var frame:KeyFrame = new KeyFrame();
					var meshObject:MeshObject = new MeshObject();
					meshObject.type = MeshObjectType.OBJECT;
					frame.meshObjects.push(meshObject);
					meshObject.faceUVIndices = faceUVIndexList;
					meshObject.faceVertexIndices = faceVertexIndexList;
					meshObject.uvs = uvList;
					
					var sx:Number = bytes.readFloat();
					var sy:Number = bytes.readFloat();
					var sz:Number = bytes.readFloat();
					var tx:Number = bytes.readFloat();
					var ty:Number = bytes.readFloat();
					var tz:Number = bytes.readFloat();
					
					frame.name = bytes.readMultiByte(16, characterSet);
					keyFrameAnimator.addKeyFrame(frame);
					var vertexList:Vector.<Vertex3D> = meshObject.vertices;
					for (var j:int = 0; j<_totalVertices; j++) {
						sourceX = bytes.readUnsignedByte()*sx+tx;
						sourceY = bytes.readUnsignedByte()*sy+ty;
						sourceZ = bytes.readUnsignedByte()*sz+tz;
						if (coordinatesTransform) {
							vertexList.push(new Vertex3D(sourceX, sourceZ, sourceY));
						} else {
							vertexList.push(new Vertex3D(sourceX, sourceY, sourceZ));
						}
						bytes.readUnsignedByte();
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