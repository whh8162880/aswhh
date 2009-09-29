package asgl.lights {
	import asgl.drivers.AbstractRenderDriver;
	import asgl.math.Vertex3D;
	
	import flash.geom.Vector3D;
	
	public class InfiniteLight extends AbstractLight {
		private var _tempValue:Number;
		private var _vectorX:Number;
		private var _vectorY:Number;
		private var _vectorZ:Number;
		public function InfiniteLight(strength:Number=0.5):void {
			this.strength = strength;
		}
		public override function getLightingVector(screenVertex:Vertex3D, outputVector:Vector3D):void {
			outputVector.x = _vectorX;
			outputVector.y = _vectorY;
			outputVector.z = _vectorZ;
		}
		public override function init(driver:AbstractRenderDriver):void {
			super.init(driver);
			_vectorX = _target.screenX-_position.screenX;
			_vectorY = _target.screenY-_position.screenY;
			_vectorZ = _target.screenZ-_position.screenZ;
			_tempValue = Math.sqrt(_vectorX*_vectorX+_vectorY*_vectorY+_vectorZ*_vectorZ);
		}
		public override function lightingTest(pixelScreenVertex:Vertex3D, pixelScreenVector:Vector3D):void {
			var vx:Number = pixelScreenVector.x;
			var vy:Number = pixelScreenVector.y;
			var vz:Number = pixelScreenVector.z;
			
			strengthRatio = Math.acos((_vectorX*vx+_vectorY*vy+_vectorZ*vz)/(_tempValue*Math.sqrt(vx*vx+vy*vy+vz*vz)))/HALF_PI-1;
			if (strengthRatio<0) strengthRatio = -strengthRatio;
		}
	}
}