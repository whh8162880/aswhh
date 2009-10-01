package asgl.files.models {
	import __AS3__.vec.Vector;
	
	import asgl.bones.Bone;
	import asgl.events.FileEvent;
	import asgl.files.AbstractFile;
	import asgl.math.GLMatrix3D;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	public class ASBoneReader extends AbstractFile {
		public var rootBones:Vector.<Bone>;
		public function ASBoneReader(bytes:ByteArray=null, coordinatesTransform:Boolean=false, boneClass:Class=null):void {
			if (bytes == null) {
				clear();
			} else {
				read(bytes, coordinatesTransform, boneClass);
			}
		}
		public override function clear():void {
			super.clear();
			rootBones = new Vector.<Bone>();
		}
		public function read(bytes:ByteArray, coordinatesTransform:Boolean=false, boneClass:Class=null):void {
			clear();
			try {
				if (boneClass == null) boneClass = Bone;
				bytes.endian = Endian.LITTLE_ENDIAN;
				bytes.position = 6;
				if (bytes.readUnsignedByte() == 1) {
					var temp:ByteArray = new ByteArray();
					temp.endian = Endian.LITTLE_ENDIAN;
					temp.writeBytes(bytes, 7, bytes.length-7);
					temp.uncompress();
					bytes = temp;
				}
				bytes.position += 2;
				var totalBones:int = bytes.readUnsignedShort();
				var length:int = bytes.readUnsignedByte();
				var boneMap:Object = {};
				var bonesNameList:Array = [];
				var name:String;
				var bone:Bone;
				var nameLength:int;
				for (var i:int = 0; i<length; i++) {
					bone = new boneClass();
					nameLength = bytes.readUnsignedByte();
					name = bytes.readMultiByte(nameLength, characterSet);
					bone.name = name;
					bonesNameList[i] = name;
					boneMap[name] = bone;
					rootBones.push(bone);
				}
				for (i = length; i<totalBones; i++) {
					bone = new boneClass();
					nameLength = bytes.readUnsignedByte();
					name = bytes.readMultiByte(nameLength, characterSet);
					bone.name = name;
					bonesNameList[i] = name;
					boneMap[name] = bone;
				}
				for (i = 0; i<totalBones; i++) {
					var max:int = bytes.readUnsignedByte()
					name = bonesNameList[i];
					bone = boneMap[name];
					for (var j:int = 0; j<max; j++) {
						bone.addChild(boneMap[bonesNameList[bytes.readUnsignedShort()]]);
					}
				}
				for (i = 0; i<length; i++) {
					var matrix:GLMatrix3D = new GLMatrix3D(bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat());
					if (coordinatesTransform) matrix.coordinatesTransform();
					boneMap[bonesNameList[i]].localMatrix = matrix;
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