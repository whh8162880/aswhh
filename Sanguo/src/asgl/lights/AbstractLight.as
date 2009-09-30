package asgl.lights {
	import asgl.drivers.AbstractRenderDriver;
	import asgl.math.AbstractCoordinates3D;
	import asgl.math.GLMatrix3D;
	import asgl.math.Vertex3D;
	import asgl.shadows.AbstractShadow;
	
	import flash.geom.Vector3D;
	
	public class AbstractLight extends AbstractCoordinates3D {
		protected static var HALF_PI:Number = Math.PI/2;
		//hide
		public var _shadow:AbstractShadow;
		public var attenuationEnabled:Boolean = false;
		public var colorLightingEnabled:Boolean = false;
		/**
		 * [read only]
		 */
		public var hasShadow:Boolean = false;
		public var attenuationDistance:Number = 100;
		/**
		 * [read only] 0-1
		 */
		public var strengthRatio:Number;
		/**
		 * 0-1, 0.5 is normal
		 */
		public var strength:Number = 0.5;
		public var lightingColor:uint = 0xFFFFFFFF;
		protected var _target:Vertex3D = new Vertex3D(0, 0, 1);
		public function AbstractLight(position:Vertex3D=null):void {
			super(position);
		}
		public function get localDirection():Vector3D {
			return new Vector3D(_target.localX, _target.localY, _target.localZ);
		}
		public function get shadow():AbstractShadow {
			return _shadow;
		}
		public function set shadow(value:AbstractShadow):void {
			if (value == null && _shadow != null) {
				_shadow.light = null;
				_shadow.reset();
			}
			_shadow = value;
			if (_shadow != null) {
				_shadow.light = this;
				_shadow.reset();
			}
		}
		public function set localDirection(vector:Vector3D):void {
			_target.localX = vector.x;
			_target.localY = vector.y;
			_target.localZ = vector.z;
			if (autoRefreshEnabled) _target.transformWorldSpace(this.worldMatrix);
		}
		public function complete():void {
			if (_shadow != null) _shadow.complete();
		}
		public override function destroy():void {
			_shadow = null;
			_target = null;
			super.destroy();
		}
		public function getLightingVector(screenVertex:Vertex3D, outputVector:Vector3D):void {
			outputVector.x = 0;
			outputVector.y = 0;
			outputVector.z = 0;
		}
		public function init(driver:AbstractRenderDriver):void {
			if (_shadow != null) _shadow.init(driver);
		}
		public function lightingTest(pixelScreenVertex:Vertex3D, pixelScreenVector:Vector3D):void {
			strengthRatio = 0;
		}
		public function transformScreenSpace(m:GLMatrix3D):void {
			_position.transformScreenSpace(m);
			_target.transformScreenSpace(m);
		}
		protected function _getAttenuationK(k:Number, d:Number):Number {
			if (d>attenuationDistance) return 0;
			return k*(1-d/attenuationDistance);
		}
		protected function _shadowTest(pixelScreenVertex:Vertex3D):void {
			if (_shadow == null) {
				hasShadow = false;
			} else {
				shadow.shadowTest(pixelScreenVertex);
			}
		}
		protected override function _verticesRefresh():void {
			var m:GLMatrix3D = this.worldMatrix;
			_position.worldX = m.tx;
			_position.worldY = m.ty;
			_position.worldZ = m.tz;
			var x:Number = _target.localX;
			var y:Number = _target.localY;
			var z:Number = _target.localZ;
			_target.worldX = x*m.a+y*m.b+z*m.c+m.tx;
			_target.worldY = x*m.d+y*m.e+z*m.f+m.ty;
			_target.worldZ = x*m.g+y*m.h+z*m.i+m.tz;
		}
	}
}