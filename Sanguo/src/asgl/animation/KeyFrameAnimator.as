package asgl.animation {
	import __AS3__.vec.Vector;
	
	public class KeyFrameAnimator {
		private var _frames:Vector.<KeyFrame> = new Vector.<KeyFrame>();
		public function get totalFrames():int {
			return _frames.length;
		}
		public function addKeyFrame(frame:KeyFrame):void {
			_frames.push(frame);
		}
		public function getKeyFrameAt(index:uint):KeyFrame {
			return _frames[index];
		}
	}
}