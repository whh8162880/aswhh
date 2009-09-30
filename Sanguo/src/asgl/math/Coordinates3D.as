package asgl.math {
	public class Coordinates3D extends Coordinates3DContainer {
		public function Coordinates3D(position:Vertex3D=null):void {
			super(position);
		}
		public function set worldEnabled(value:Boolean):void {
			if (value) {
				if (_parent == null) _isWorld = true;
			} else {
				_isWorld = false;
			}
		}
	}
}