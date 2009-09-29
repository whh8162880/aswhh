package asgl.lights {
	import asgl.drivers.AbstractRenderDriver;
	import asgl.math.Vertex3D;
	
	import flash.geom.Vector3D;
	
	public class SpotLight extends AbstractLight {
		private var _angle:Number;
		private var _positionX:Number;
		private var _positionY:Number;
		private var _positionZ:Number;
		private var _tempValue:Number;
		private var _vectorX:Number;
		private var _vectorY:Number;
		private var _vectorZ:Number;
		public function SpotLight(strength:Number=0.5, position:Vertex3D=null, angle:Number=45):void {
			super(position);
			this.strength = strength;
			this.angle = angle;
		}
		public function get angle():Number {
			return _angle*180/Math.PI;
		}
		public function set angle(value:Number):void {
			_angle = value*Math.PI/180;
		}
		public override function getLightingVector(screenVertex:Vertex3D, outputVector:Vector3D):void {
			var px:Number = screenVertex.screenX;
			var py:Number = screenVertex.screenY;
			var pz:Number = screenVertex.screenZ;
			
			var vx:Number = px-_positionX;
			var vy:Number = py-_positionY;
			var vz:Number = pz-_positionZ;
			
			var angle:Number = Math.acos((_vectorX*vx+_vectorY*vy+_vectorZ*vz)/(Math.sqrt(_vectorX*_vectorX+_vectorY*_vectorY+_vectorZ*_vectorZ)*Math.sqrt(vx*vx+vy*vy+vz*vz)));
			if (angle>_angle) {
				outputVector.x = 0;
				outputVector.y = 0;
				outputVector.z = 0;
			} else {
				outputVector.x = px;
				outputVector.y = py;
				outputVector.z = pz;
			}
		}
		public override function init(driver:AbstractRenderDriver):void {
			super.init(driver);
			_positionX = _position.screenX;
			_positionY = _position.screenY;
			_positionZ = _position.screenZ;
			_vectorX = _target.screenX-_positionX;
			_vectorY = _target.screenY-_positionY;
			_vectorZ = _target.screenZ-_positionZ;
			_tempValue = Math.sqrt(_vectorX*_vectorX+_vectorY*_vectorY+_vectorZ*_vectorZ);
		}
		public override function lightingTest(pixelScreenVertex:Vertex3D, pixelScreenVector:Vector3D):void {
			var vx:Number = pixelScreenVertex.screenX-_positionX;
			var vy:Number = pixelScreenVertex.screenY-_positionY;
			var vz:Number = pixelScreenVertex.screenZ-_positionZ;
			
			var angle:Number = Math.acos((_vectorX*vx+_vectorY*vy+_vectorZ*vz)/(_tempValue*Math.sqrt(vx*vx+vy*vy+vz*vz)));
			if (angle>_angle) {
				strengthRatio = 0;
				if (_shadow != null) {
					_shadow.alphaRatio = 0;
					_shadow.redRatio = 0;
					_shadow.greenRatio = 0;
					_shadow.blueRatio = 0;
				}
				return;
			}
			
			_shadowTest(pixelScreenVertex);
			
			var vectorX:Number = pixelScreenVector.x;
			var vectorY:Number = pixelScreenVector.y;
			var vectorZ:Number = pixelScreenVector.z;
			
			var d:Number = Math.sqrt(vx*vx+vy*vy+vz*vz);
			strengthRatio = Math.acos((vectorX*vx+vectorY*vy+vectorZ*vz)/(d*Math.sqrt(vectorX*vectorX+vectorY*vectorY+vectorZ*vectorZ)))/HALF_PI-1;
			
			if (attenuationEnabled) strengthRatio = _getAttenuationK(strengthRatio, d);
		}
	}
}