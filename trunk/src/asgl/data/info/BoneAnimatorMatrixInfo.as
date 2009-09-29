package asgl.data.info {
	import __AS3__.vec.Vector;
	
	import asgl.math.GLMatrix3D;
	
	public class BoneAnimatorMatrixInfo {
		public var boneName:String;
		public var matrices:Vector.<GLMatrix3D> = new Vector.<GLMatrix3D>();
		public var timeList:Vector.<Number> = new Vector.<Number>();
		public function clone():BoneAnimatorMatrixInfo {
			var out:BoneAnimatorMatrixInfo = new BoneAnimatorMatrixInfo();
			out.timeList = timeList.concat();
			var length:int = matrices.length;
			for (var i:int = 0; i<length; i++) {
				 out.matrices[i] = matrices[i].clone();
			}
			out.boneName = boneName;
			return out;
		}
	}
}