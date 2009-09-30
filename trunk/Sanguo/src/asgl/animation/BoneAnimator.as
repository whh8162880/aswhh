package asgl.animation {
	import __AS3__.vec.Vector;
	
	import asgl.bones.Bone;
	import asgl.data.info.BoneAnimatorMatrixInfo;
	import asgl.data.info.BoneInfo;
	import asgl.data.info.VertexBindableBoneInfo;
	import asgl.math.GLMatrix3D;
	import asgl.math.Vertex3D;
	
	public class BoneAnimator {
		public var localScaleX:Number = 1;
		public var localScaleY:Number = 1;
		public var localScaleZ:Number = 1;
		/**
		 * [read only]
		 */
		public var rootBones:Vector.<Bone> = new Vector.<Bone>();
		private var _boneList:Array = [];
		private var _vertexList:Array = [];
		private var _isLoop:Boolean = false;
		private var _om:GLMatrix3D = new GLMatrix3D();
		private var _tm:GLMatrix3D = new GLMatrix3D();
		private var _currentFrame:Number = 1;
		private var _loopEndFrame:int;
		private var _loopStartFrame:int;
		private var _totalFrames:int = 0;
		public function get bones():Vector.<Bone> {
			var out:Vector.<Bone> = new Vector.<Bone>();
			for each (var bone:Bone in _boneList) {
				out.push(bone);
			}
			return out;
		}
		public function get currentFrame():Number {
			return _currentFrame;
		}
		public function get totalFrames():int {
			return _totalFrames;
		}
		public function get vertices():Vector.<Vertex3D> {
			var out:Vector.<Vertex3D> = new Vector.<Vertex3D>();
			for each (var info:VertexBindableBoneInfo in _vertexList) {
				out.push(info.vertex);
			}
			return out;
		}
		public function addBone(bone:Bone):void {
			if (_boneList[bone.id] == null) {
				_boneList[bone.id] = bone;
			}
		}
		public function addVertex(vertex:Vertex3D, weight:Number, bone:Bone, offsetMatrix:GLMatrix3D):void {
			if (_boneList[bone.id] != null) {
				if (_vertexList[vertex.id] == null) {
					var info:VertexBindableBoneInfo = new VertexBindableBoneInfo();
					info.vertex = vertex;
					info.boneInfo.push(new BoneInfo(bone, weight, offsetMatrix));
					_vertexList[vertex.id] = info;
				} else {
					var list:Array = _vertexList[vertex.id].boneInfo.list;
					for (var i:int = list.length-1; i>=0; i--) {
						if (list[i].bone == bone) return;
					}
					list.push(new BoneInfo(bone, weight, offsetMatrix));
				}
			}
		}
		public function clearBonesAndVertices():void {
			_boneList = [];
			_vertexList = [];
		}
		public function clearLoop():void {
			_isLoop = false;
		}
		public function clearVertices():void {
			_vertexList = [];
		}
		public function destroy():void {
			rootBones = null;
			_boneList = null;
			_vertexList = null;
			_tm = null;
			_om = null;
		}
		public function getBoneByName(name:String):Bone {
			for each (var bone:Bone in _boneList) {
				if (name == bone.name) return bone;
			}
			return null;
		}
		public function getBoneInfoByVertex(vertex:Vertex3D):Vector.<BoneInfo> {
			var info:VertexBindableBoneInfo = _vertexList[vertex.id];
			if (info == null) {
				return null;
			} else {
				return info.boneInfo;
			}
		}
		/**
		 * @param frame the frame>=1.
		 */
		public function gotoFrame(frame:Number, isRefresh:Boolean=true):void {
			if (_totalFrames<1) return;
			if (frame<1) {
				frame = 1;
			} else if (frame>_totalFrames) {
				frame = _totalFrames;
			}
			_currentFrame = frame;
			if (isRefresh) refresh(_currentFrame != int(_currentFrame));
		}
		public function nextFrame(isRefresh:Boolean=true):void {
			if (_totalFrames<1) return;
			var frame:int;
			if (_isLoop) {
				if (_currentFrame>=_loopEndFrame) {
					_currentFrame = _loopStartFrame;
				} else if (_currentFrame<_loopStartFrame) {
					_currentFrame = _loopStartFrame;
				} else {
					frame = int(_currentFrame);
					if (_currentFrame == frame) {
						_currentFrame++;
					} else {
						_currentFrame = frame+1;
					}
				}
			} else if (_currentFrame<_totalFrames) {
				frame = int(_currentFrame);
				if (_currentFrame == frame) {
					_currentFrame++;
				} else {
					_currentFrame = frame+1;
				}
			}
			if (isRefresh) refresh();
		}
		public function prevFrame(isRefresh:Boolean=true):void {
			if (_totalFrames<1) return;
			var frame:int;
			if (_isLoop) {
				if (_currentFrame<=_loopStartFrame) {
					_currentFrame = _loopEndFrame;
				} else if (_currentFrame>_loopEndFrame) {
					_currentFrame = _loopEndFrame;
				} else {
					frame = int(_currentFrame);
					if (_currentFrame == frame) {
						_currentFrame--;
					} else {
						_currentFrame = frame-1;
					}
				}
			} else if (_currentFrame>1) {
				frame = int(_currentFrame);
				if (_currentFrame == frame) {
					_currentFrame--;
				} else {
					_currentFrame = frame-1;
				}
			}
			if (isRefresh) refresh();
		}
		public function refresh(isInterpolation:Boolean=false):void {
			if (isInterpolation) {
				_refreshInterpolation();
			} else {
				_refresh();
			}
		}
		public function setBoneAnimatorMatrixInfo(info:Vector.<BoneAnimatorMatrixInfo>):void {
			_totalFrames = -2;
			for (var i:int = info.length-1; i>=0; i--) {
				var mi:BoneAnimatorMatrixInfo = info[i];
				setBoneAnimatorMatrixByName(mi.boneName, mi.matrices);
			}
			_totalFrames = -1;
			_totalFramesTest();
		}
		public function setBoneAnimatorMatrixByName(boneName:String, matrices:Vector.<GLMatrix3D>):void {
			for each (var bone:Bone in _boneList) {
				if (boneName == bone.name) {
					bone.matrices = matrices;
					break;
				}
			}
			if (_totalFrames != -2) {
				_totalFrames = -1;
				_totalFramesTest();
			}
		}
		public function setBonesLocalMatrix(frame:Number):void {
			if (frame<1) {
				frame = 1;
			} else if (frame>_totalFrames) {
				frame = _totalFrames;
			}
			var intFrame:int = int(frame);
			var bone:Bone;
			if (frame == intFrame) {
				for each (bone in _boneList) {
					bone.localMatrix = bone.matrices[frame-1];
				}
			} else {
				for each (bone in _boneList) {
					bone.localMatrix = GLMatrix3D.interpolation(bone.matrices[intFrame], bone.matrices[intFrame+1], frame-intFrame);
				}
			}
		}
		public function setLoop(startFrame:int, endFrame:int):void {
			if (_totalFrames<1) return;
			if (endFrame<1) {
				endFrame = 1;
			} else if (endFrame>_totalFrames) {
				endFrame = _totalFrames;
			}
			if (startFrame<1) {
				startFrame = 1;
			} else if (startFrame>endFrame) {
				startFrame = endFrame;
			}
			_isLoop = true;
			_loopStartFrame = startFrame;
			_loopEndFrame = endFrame;
		}
		private function _refresh():void {
			for each (var info:VertexBindableBoneInfo in _vertexList) {
				var list:Vector.<BoneInfo> = info.boneInfo;
				var vertex:Vertex3D = info.vertex;
				var sx:Number = vertex.sourceX;
				var sy:Number = vertex.sourceY;
				var sz:Number = vertex.sourceZ;
				var x:Number = 0;
				var y:Number = 0;
				var z:Number = 0;
				for (var i:int = list.length-1; i>=0; i--) {
					var boneInfo:BoneInfo = list[i];
					var bone:Bone = boneInfo.bone;
					var weight:Number = boneInfo.weight;
					_om.copy(boneInfo.offsetMatrix);
					
					_tm.copy(_boneList[bone.id].matrices[_currentFrame-1]);
					
					bone = bone.parent as Bone;
					while (bone != null) {
						var b:Bone = _boneList[bone.id];
						if (b != null) _tm.concat(b.matrices[_currentFrame-1]);
						bone = bone.parent as Bone;
					}
					_om.concat(_tm);
					
					//use Vertex transformLocalSpace method
					x += (sx*_om.a+sy*_om.b+sz*_om.c+_om.tx)*weight;
					y += (sx*_om.d+sy*_om.e+sz*_om.f+_om.ty)*weight;
					z += (sx*_om.g+sy*_om.h+sz*_om.i+_om.tz)*weight;
					//
				}
				vertex.localX = x*localScaleX;
				vertex.localY = y*localScaleY;
				vertex.localZ = z*localScaleZ;
			}
		}
		private function _refreshInterpolation():void {
			for each (var info:VertexBindableBoneInfo in _vertexList) {
				var list:Vector.<BoneInfo> = info.boneInfo;
				var vertex:Vertex3D = info.vertex;
				var sx:Number = vertex.sourceX;
				var sy:Number = vertex.sourceY;
				var sz:Number = vertex.sourceZ;
				var x:Number = 0;
				var y:Number = 0;
				var z:Number = 0;
				for (var i:int = list.length-1; i>=0; i--) {
					var boneInfo:BoneInfo = list[i];
					var bone:Bone = boneInfo.bone;
					var weight:Number = boneInfo.weight;
					_om.copy(boneInfo.offsetMatrix);
					
					var matrices:Vector.<GLMatrix3D> = _boneList[bone.id].matrices;
					var frame:int = int(_currentFrame-1);
					var t:Number = _currentFrame-frame-1;
					_tm = GLMatrix3D.interpolation(matrices[frame], matrices[frame+1], t);
					
					bone = bone.parent as Bone;
					while (bone != null) {
						var b:Bone = _boneList[bone.id];
						if (b != null) {
							matrices = b.matrices;
							_tm.concat(GLMatrix3D.interpolation(matrices[frame], matrices[frame+1], t));
						}
						bone = bone.parent as Bone;
					}
					_om.concat(_tm);
					
					//use Vertex transformLocalSpace method
					x += (sx*_om.a+sy*_om.b+sz*_om.c+_om.tx)*weight;
					y += (sx*_om.d+sy*_om.e+sz*_om.f+_om.ty)*weight;
					z += (sx*_om.g+sy*_om.h+sz*_om.i+_om.tz)*weight;
					//
				}
				vertex.localX = x*localScaleX;
				vertex.localY = y*localScaleY;
				vertex.localZ = z*localScaleZ;
			}
		}
		private function _totalFramesTest():void {
			for each (var bone:Bone in _boneList) {
				var list:Vector.<GLMatrix3D> = bone.matrices;
				if (list == null) {
					break;
				} else {
					if (_totalFrames == -1 || _totalFrames>list.length) _totalFrames = list.length;
				}
			}
			if (_totalFrames == -1) _totalFrames = 0;
		}
	}
}