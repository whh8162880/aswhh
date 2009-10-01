package asgl.files.models {
	import __AS3__.vec.Vector;
	
	import asgl.bones.Bone;
	import asgl.events.FileEvent;
	import asgl.files.AbstractEncoder;
	import asgl.math.GLMatrix3D;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	public class ASBoneEncoder extends AbstractEncoder {
		private var _totalBones:int;
		private var _boneMap:Object;
		private var _boneMap2:Object;
		public function encode(rootBones:Vector.<Bone>, coordinatesTransform:Boolean=false, compress:Boolean=true):void {
			_bytes = new ByteArray();
			_bytes.endian = Endian.LITTLE_ENDIAN;
			try {
				_bytes.writeUTFBytes('ASBONE');
				_bytes.writeByte(compress ? 1: 0);
				_bytes.writeShort(1);
				_boneMap = {};
				_boneMap2 = {};
				_totalBones = 0;
				var bone:Bone;
				var rootBoneNameList:Array = [];
				var length:int = rootBones.length;
				for (var i:int = 0; i<length; i++) {
					_totalBones++;
					bone = rootBones[i];
					_boneMap[bone.name] = [];
					_boneMap2[bone.name] = bone;
					rootBoneNameList[i] = bone.name;
					_readChildrenBones(bone);
				}
				_bytes.writeShort(_totalBones);
				_bytes.writeByte(length);
				var name:String;
				var nameList:Array = [];
				for (i = 0; i<length; i++) {
					name = rootBoneNameList[i];
					nameList.push(name);
					_bytes.writeByte(name.length);
					_bytes.writeMultiByte(name, characterSet);
				}
				for (name in _boneMap) {
					if (rootBoneNameList.indexOf(name) == -1) {
						nameList.push(name);
						_bytes.writeByte(name.length);
						_bytes.writeMultiByte(name, characterSet);
					}
				}
				length = _totalBones;
				for (i = 0; i<length; i++) {
					var list:Array = _boneMap[nameList[i]];
					var max:int = list.length;
					_bytes.writeByte(max);
					for (var j:int = 0; j<max; j++) {
						_bytes.writeShort(nameList.indexOf(list[j]));
					}
				}
				for (i = 0; i<length; i++) {
					bone = _boneMap2[nameList[i]];
					var m:GLMatrix3D = bone.localMatrix;
					if (coordinatesTransform) m.coordinatesTransform();
					_bytes.writeFloat(m.a);
					_bytes.writeFloat(m.b);
					_bytes.writeFloat(m.c);
					_bytes.writeFloat(m.d);
					_bytes.writeFloat(m.e);
					_bytes.writeFloat(m.f);
					_bytes.writeFloat(m.g);
					_bytes.writeFloat(m.h);
					_bytes.writeFloat(m.i);
					_bytes.writeFloat(m.tx);
					_bytes.writeFloat(m.ty);
					_bytes.writeFloat(m.tz);
				}
				if (compress) {
					var temp:ByteArray = new ByteArray();
					temp.endian = Endian.LITTLE_ENDIAN;
					temp.writeBytes(_bytes, 7, _bytes.length-7);
					temp.compress();
					_bytes.length = 7;
					_bytes.writeBytes(temp);
				}
				_boneMap = null;
				_boneMap2 = null;
				_isCorrectFormat = true;
				this.dispatchEvent(new FileEvent(FileEvent.COMPLETE));
			} catch (e:Error) {
				_boneMap = null;
				_boneMap2 = null;
				clear();
				this.dispatchEvent(new FileEvent(FileEvent.ERROR, e));
			}
		}
		private function _readChildrenBones(bone:Bone):void {
			var list:Array = _boneMap[bone.name];
			var index:int = 0;
			while (true) {
				var childBone:Bone = bone.getChildBoneAt(index);
				if (childBone == null) {
					break;
				} else {
					_totalBones++;
					list[index] = childBone.name;
					_boneMap[childBone.name] = [];
					_boneMap2[childBone.name] = childBone;
					_readChildrenBones(childBone);
					index++;
				}
			}
		}
	}
}