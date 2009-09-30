package asgl.bones {
	import __AS3__.vec.Vector;
	
	import asgl.math.AbstractCoordinates3D;
	import asgl.math.Coordinates3DContainer;
	import asgl.math.GLMatrix3D;
	import asgl.math.Vertex3D;
	public class Bone extends Coordinates3DContainer {
		public var matrices:Vector.<GLMatrix3D>;
		protected var _childBonesList:Vector.<Bone>;
		public function Bone(position:Vertex3D=null):void {
			super(position);
		}
		public function get totalChildBones():uint {
			return _childBonesList.length;
		}
		public override function addChild(child:AbstractCoordinates3D, isRefresh:Boolean=true):Boolean {
			var b:Boolean = super.addChild(child, isRefresh);
			if (b && (child is Bone)) _childBonesList.push(child);
			return b;
		}
		public override function destroy():void {
			super.destroy();
			_childBonesList = null;
			matrices = null;
		}
		public function getChildBoneAt(index:uint):Bone {
			return _childBonesList[index];
		}
		public override function removeChild(child:AbstractCoordinates3D):Boolean {
			var b:Boolean = super.removeChild(child);
			if (b && (child is Bone)) _childBonesList.splice(_childBonesList.indexOf(child), 1);
			return b;
		}
		public override function removeChildAt(index:uint):AbstractCoordinates3D {
			var child:AbstractCoordinates3D = super.removeChildAt(index);
			if (child != null && (child is Bone)) _childBonesList.splice(_childBonesList.indexOf(child), 1);
			return child;
		}
		public function setLocalMatrixFromMatrices(index:Number, includeChildren:Boolean = true):void {
			if (matrices == null) return;
			if (index<0) {
				index = 0;
			} else if (index>=matrices.length) {
				index = matrices.length-1;
			}
			var intIndex:int = int(index);
			if (index == intIndex) {
				this.localMatrix = matrices[index];
			} else {
				this.localMatrix = GLMatrix3D.interpolation(matrices[intIndex], matrices[intIndex+1], index-intIndex);
			}
			if (includeChildren) {
				var length:int = _childBonesList.length;
				for (var i:int = 0; i<length; i++) {
					_childBonesList[i].setLocalMatrixFromMatrices(index, true);
				}
			}
		}
	}
}