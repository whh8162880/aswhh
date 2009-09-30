package asgl.cameras {
	import asgl.math.Coordinates3DContainer;
	import asgl.math.GLMatrix3D;
	import asgl.math.Vertex3D;
	
	import flash.events.Event;
	
	[Event(name="resize", type="flash.events.Event")]

	public class Camera3D extends Coordinates3DContainer {
		private var _customPerspectiveCoefficientEnabled:Boolean = false;
		private var _halfHeight:Number;
		private var _halfWidth:Number;
		private var _height:Number;
		private var _nearClipDistance:Number;
		private var _perspectiveCoefficient:Number;
		private var _width:Number;
		public function Camera3D(position:Vertex3D, width:uint, height:uint, near:Number):void {
			super(position);
			_setSize(width, height);
			_nearClipDistance = near>0 ? near : 1;
			_perspectiveCoefficient = _nearClipDistance;
		}
		public function get customPerspectiveCoefficientEnabled():Boolean {
			return _customPerspectiveCoefficientEnabled;
		}
		public function set customPerspectiveCoefficientEnabled(value:Boolean):void {
			_customPerspectiveCoefficientEnabled = value;
			if (!_customPerspectiveCoefficientEnabled) _perspectiveCoefficient = _nearClipDistance;
		}
		public function get height():uint {
			return _height;
		}
		public function set height(value:uint):void {
			_height = value;
			_halfHeight = _height/2;
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		public function get nearClipDistance():Number {
			return _nearClipDistance;
		}
		public function set nearClipDistance(value:Number):void {
			if (value>0) {
				_nearClipDistance = value;
				if (!_customPerspectiveCoefficientEnabled) _perspectiveCoefficient = _nearClipDistance;
			}
		}
		public function get perspectiveCoefficient():Number {
			return _perspectiveCoefficient;
		}
		public function set perspectiveCoefficient(value:Number):void {
			if (_customPerspectiveCoefficientEnabled) _perspectiveCoefficient = value;
		}
		public function get screenMatrix():GLMatrix3D {
			var m:GLMatrix3D = worldMatrix.clone();
			m.invert();
			m.tx += _halfWidth;
			m.ty -= _halfHeight;
			return m;
		}
		public function get screenX():Number {return _position.screenX};
		public function get screenY():Number {return _position.screenY};
		public function get screenZ():Number {return _position.screenZ};
		public function get width():uint {
			return _width;
		}
		public function set width(value:uint):void {
			_width = value;
			_halfWidth = _width/2;
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		public override function refresh(send:Boolean=true):void {
			super.refresh(send);
			_position.transformScreenSpace(screenMatrix);
		}
		public function setSize(width:uint, height:uint):void {
			_setSize(width, height);
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		private function _setSize(width:uint, height:uint):void {
			_width = width;
			_halfWidth = _width/2;
			_height = height;
			_halfHeight = _height/2;
		}
	}
}