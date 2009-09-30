package asgl.handlers {
	import __AS3__.vec.Vector;
	
	import asgl.cameras.Camera3D;
	import asgl.data.BinaryTree;
	import asgl.drivers.AbstractRenderDriver;
	import asgl.math.Vertex3D;
	import asgl.mesh.TriangleFace;

	public class ScreenSpaceFacesBinarySpacePartitionSort implements IHandler {
		public var facesBinaryTree:BinaryTree;
		private var _centerX:int;
		private var _centerY:int;
		public function ScreenSpaceFacesBinarySpacePartitionSort(facesBinaryTree:BinaryTree=null):void {
			this.facesBinaryTree = facesBinaryTree;
		}
		public function handle(driver:AbstractRenderDriver, faces:Vector.<TriangleFace>, completeFucntion:Function):void {
			if (facesBinaryTree == null) {
				completeFucntion(faces);
			} else {
				var camera:Camera3D = driver.camera;
				_centerX = camera.width/2;
				_centerY = -camera.height/2;
				var out:Vector.<TriangleFace> = new Vector.<TriangleFace>();
				out[0] = facesBinaryTree.node;
				_sort(facesBinaryTree, out);
				completeFucntion(out);
			}
		}
		private function _sort(bt:BinaryTree, list:Vector.<TriangleFace>):void {
			var face:TriangleFace = bt.node;
			var v0:Vertex3D = face.vertex0;
			var v1:Vertex3D = face.vertex1;
			var v2:Vertex3D = face.vertex2;
			var subtree:BinaryTree;
			var index:int = list.indexOf(face);
			var v0X:Number = v0.screenX;
			var v0Y:Number = v0.screenY;
			var v0Z:Number = v0.screenZ;
			var abX:Number = v1.screenX-v0X;
			var abY:Number = v1.screenY-v0Y;
			var acX:Number = v2.screenX-v0X;
			var acY:Number = v2.screenY-v0Y;
			var z:Number = acY*abX-acX*abY;
			if (z>0) {
				subtree = bt.rightSubtree;
				if (subtree != null) {
					list.splice(index+1, 0, subtree.node);
					_sort(subtree, list);
				}
				subtree = bt.leftSubtree;
				if (subtree != null) {
					list.splice(index, 0, subtree.node);
					_sort(subtree, list);
				}
			} else if (z<0) {
				subtree = bt.leftSubtree;
				if (subtree != null) {
					list.splice(index+1, 0, subtree.node);
					_sort(subtree, list);
				}
				subtree = bt.rightSubtree;
				if (subtree != null) {
					list.splice(index, 0, subtree.node);
					_sort(subtree, list);
				}
			} else {
				var abZ:Number = v1.screenZ-v0Z;
				var acZ:Number = v2.screenZ-v0Z;
				var x:Number = abY*acZ-abZ*acY;
				var y:Number = abZ*acX-abX*acZ;
				if (x == 0) {
					if (y>0) {
						if (v0Y>_centerY) {
							subtree = bt.rightSubtree;
							if (subtree != null) {
								list.splice(index+1, 0, subtree.node);
								_sort(subtree, list);
							}
							subtree = bt.leftSubtree;
							if (subtree != null) {
								list.splice(index, 0, subtree.node);
								_sort(subtree, list);
							}
						} else {
							subtree = bt.leftSubtree;
							if (subtree != null) {
								list.splice(index+1, 0, subtree.node);
								_sort(subtree, list);
							}
							subtree = bt.rightSubtree;
							if (subtree != null) {
								list.splice(index, 0, subtree.node);
								_sort(subtree, list);
							}
						}
					} else {
						if (v0Y>_centerY) {
							subtree = bt.leftSubtree;
							if (subtree != null) {
								list.splice(index+1, 0, subtree.node);
								_sort(subtree, list);
							}
							subtree = bt.rightSubtree;
							if (subtree != null) {
								list.splice(index, 0, subtree.node);
								_sort(subtree, list);
							}
						} else {
							subtree = bt.rightSubtree;
							if (subtree != null) {
								list.splice(index+1, 0, subtree.node);
								_sort(subtree, list);
							}
							subtree = bt.leftSubtree;
							if (subtree != null) {
								list.splice(index, 0, subtree.node);
								_sort(subtree, list);
							}
						}
					}
				} else {
					if (x>0) {
						if (v0X>_centerX) {
							subtree = bt.rightSubtree;
							if (subtree != null) {
								list.splice(index+1, 0, subtree.node);
								_sort(subtree, list);
							}
							subtree = bt.leftSubtree;
							if (subtree != null) {
								list.splice(index, 0, subtree.node);
								_sort(subtree, list);
							}
						} else {
							subtree = bt.leftSubtree;
							if (subtree != null) {
								list.splice(index+1, 0, subtree.node);
								_sort(subtree, list);
							}
							subtree = bt.rightSubtree;
							if (subtree != null) {
								list.splice(index, 0, subtree.node);
								_sort(subtree, list);
							}
						}
					} else {
						if (v0X>_centerX) {
							subtree = bt.leftSubtree;
							if (subtree != null) {
								list.splice(index+1, 0, subtree.node);
								_sort(subtree, list);
							}
							subtree = bt.rightSubtree;
							if (subtree != null) {
								list.splice(index, 0, subtree.node);
								_sort(subtree, list);
							}
						} else {
							subtree = bt.rightSubtree;
							if (subtree != null) {
								list.splice(index+1, 0, subtree.node);
								_sort(subtree, list);
							}
							subtree = bt.leftSubtree;
							if (subtree != null) {
								list.splice(index, 0, subtree.node);
								_sort(subtree, list);
							}
						}
					}
				}
			}
		}
	}
}