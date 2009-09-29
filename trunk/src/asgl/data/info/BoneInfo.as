package asgl.data.info {
	import asgl.bones.Bone;
	import asgl.math.GLMatrix3D;
	
	public class BoneInfo {
		public var bone:Bone;
		public var offsetMatrix:GLMatrix3D;
		public var weight:Number;
		public function BoneInfo(bone:Bone = null, weight:Number=0, offsetMatrix:GLMatrix3D=null):void {
			this.bone = bone;
			this.weight = weight;
			this.offsetMatrix = offsetMatrix;
		}
	}
}