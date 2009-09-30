package asgl.shadows {
	import asgl.drivers.AbstractRenderDriver;
	import asgl.lights.AbstractLight;
	import asgl.math.Vertex3D;
	
	public class AbstractShadow {
		/**
		 * [read-only]
		 */
		public var light:AbstractLight;
		/**
		 * [read-only] 0-1
		 */
		public var alphaRatio:Number = 0;
		/**
		 * [read-only] 0-1
		 */
		public var blueRatio:Number = 0;
		/**
		 * [read-only] 0-1
		 */
		public var greenRatio:Number = 0;
		/**
		 * [read-only] 0-1
		 */
		public var redRatio:Number = 0;
		/**
		 * renderer control.
		 */
		public function complete():void {
		}
		public function destroy():void {
			light = null;
		}
		/**
		 * renderer control.
		 */
		public function init(driver:AbstractRenderDriver):void {
		}
		public function reset():void {
			alphaRatio = 0;
			blueRatio = 0;
			greenRatio = 0;
			redRatio = 0;
		}
		public function shadowTest(pixelScreenVertex:Vertex3D):void {
		}
	}
}