package asgl.files.models {
	import __AS3__.vec.Vector;
	
	import asgl.data.info.BoneAnimatorMatrixInfo;
	import asgl.events.FileEvent;
	import asgl.files.AbstractFile;
	import asgl.math.GLMatrix3D;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class ASAnimReader extends AbstractFile {
		public var boneAnimatorMatrixInfo:Vector.<BoneAnimatorMatrixInfo>;
		public function ASAnimReader(bytes:ByteArray=null, coordinatesTransform:Boolean=false):void {
			if (bytes == null) {
				clear();
			} else {
				read(bytes, coordinatesTransform);
			}
		}
		public override function clear():void {
			super.clear();
			boneAnimatorMatrixInfo = new Vector.<BoneAnimatorMatrixInfo>();
		}
		public function read(bytes:ByteArray, coordinatesTransform:Boolean=false):void {
			clear();
			try {
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
				var total:int;
				var j:int;
				var m0:GLMatrix3D;
				var m1:GLMatrix3D;
				var unitTime:int = bytes.readUnsignedShort();
				var length:int = bytes.length;
				while (bytes.bytesAvailable>0) {
					var info:BoneAnimatorMatrixInfo = new BoneAnimatorMatrixInfo();
					boneAnimatorMatrixInfo.push(info);
					var boneNameLength:int = bytes.readUnsignedByte();
					info.boneName = bytes.readMultiByte(boneNameLength, characterSet);
					var matrixArray:Vector.<GLMatrix3D> = new Vector.<GLMatrix3D>();
					info.matrices = matrixArray;
					var n:int = bytes.readUnsignedShort();
					var currentTime:int = 0;
					var timeList:Vector.<Number> = info.timeList;
					for (var i:int = 0; i<n; i++) {
						var time:int = bytes.readUnsignedShort();
						var k:Number = time/unitTime;
						var intK:int = int(k);
						if (intK == k) {
							timeList.push(time);
							var matrix:GLMatrix3D = new GLMatrix3D(bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat());
							if (coordinatesTransform) matrix.coordinatesTransform();
							matrixArray.push(matrix);
							
							if (currentTime<time) {
								m0 = matrixArray[matrixArray.length-2];
								m1 = matrixArray[matrixArray.length-1];
								total = (time-currentTime)/unitTime+1;
								for (j = 1; j<total; j++) {
									timeList.splice(timeList.length-1, 0, currentTime+(j-1)*unitTime);
									matrixArray.splice(matrixArray.length-1, 0, GLMatrix3D.interpolation(m0, m1, j/total));
								}
							}
							currentTime = time;
						} else if (intK>currentTime) {
							m0 = matrixArray[matrixArray.length-1];
							m1 = new GLMatrix3D(bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat(), bytes.readFloat());
							if (coordinatesTransform) m1.coordinatesTransform();
							var max:Number = (time-currentTime)/unitTime+1;
							total = int(max);
							for (j = 1; j<total; j++) {
								timeList.push(currentTime+(j-1)*unitTime);
								matrixArray.push(GLMatrix3D.interpolation(m0, m1, j/total));
							}
							currentTime = intK;
						}
						currentTime += unitTime;
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