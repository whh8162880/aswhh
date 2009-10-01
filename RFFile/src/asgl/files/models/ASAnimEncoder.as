package asgl.files.models {
	import __AS3__.vec.Vector;
	
	import asgl.data.info.BoneAnimatorMatrixInfo;
	import asgl.events.FileEvent;
	import asgl.files.AbstractEncoder;
	import asgl.math.GLMatrix3D;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	public class ASAnimEncoder extends AbstractEncoder {
		/**
		 * @param unitTime thie unitTime>0;
		 */
		public function encode(infos:Vector.<BoneAnimatorMatrixInfo>, unitTime:uint, coordinatesTransform:Boolean=false, compress:Boolean=true):void {
			_bytes = new ByteArray();
			_bytes.endian = Endian.LITTLE_ENDIAN;
			try {
				if (unitTime == 0) unitTime = 1;
				_bytes.writeUTFBytes('ASANIM');
				_bytes.writeByte(compress ? 1 : 0);
				_bytes.writeShort(1);
				_bytes.writeShort(unitTime);
				var totalInfo:int = infos.length;
				for (var i:int = 0; i<totalInfo; i++) {
					var info:BoneAnimatorMatrixInfo = infos[i];
					_bytes.writeByte(info.boneName.length);
					_bytes.writeMultiByte(info.boneName, characterSet);
					var matrixArray:Vector.<GLMatrix3D> = info.matrices;
					var totalMatrix:int = matrixArray.length;
					_bytes.writeShort(totalMatrix);
					var currentTime:int = 0;
					var parentTime:int = -1;
					var timeList:Vector.<Number> = info.timeList;
					var totalTimes:int = timeList.length;
					var offset:int;
					for (var j:int = 0; j<totalMatrix; j++) {
						var time:uint = j>=totalTimes || isNaN(timeList[j]) ? currentTime : timeList[j];
						if (j == 0 && time != 0) offset = time;
						time -= offset;
						if (parentTime == -1) {
							parentTime = time;
						} else if (time<=parentTime) {
							continue;
						}
						if (currentTime != time) currentTime = time;
						_bytes.writeShort(currentTime);
						var matrix:GLMatrix3D = matrixArray[j];
						if (coordinatesTransform) matrix.coordinatesTransform();
						_bytes.writeFloat(matrix.a);
						_bytes.writeFloat(matrix.b);
						_bytes.writeFloat(matrix.c);
						_bytes.writeFloat(matrix.d);
						_bytes.writeFloat(matrix.e);
						_bytes.writeFloat(matrix.f);
						_bytes.writeFloat(matrix.g);
						_bytes.writeFloat(matrix.h);
						_bytes.writeFloat(matrix.i);
						_bytes.writeFloat(matrix.tx);
						_bytes.writeFloat(matrix.ty);
						_bytes.writeFloat(matrix.tz);
						if (coordinatesTransform) matrix.coordinatesTransform();
						currentTime += unitTime;
					}
				}
				if (compress) {
					var temp:ByteArray = new ByteArray();
					temp.endian = Endian.LITTLE_ENDIAN;
					temp.writeBytes(_bytes, 7, _bytes.length-7);
					temp.compress();
					_bytes.length = 7;
					_bytes.writeBytes(temp);
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