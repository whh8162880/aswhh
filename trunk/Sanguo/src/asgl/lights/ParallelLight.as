package asgl.lights {
	import asgl.drivers.AbstractRenderDriver;
	import asgl.math.Vertex3D;
	
	import flash.geom.Vector3D;
	
	public class ParallelLight extends AbstractLight {
		private var _tempValue0:Number;
		private var _tempValue1:Number;
		private var _vectorX:Number;
		private var _vectorY:Number;
		private var _vectorZ:Number;
		public function ParallelLight(strength:Number=0.5, postion:Vertex3D=null):void {
			super(postion);
			this.strength = strength;
		}
		public override function getLightingVector(screenVertex:Vertex3D, outputVector:Vector3D):void {
			var sx:Number = screenVertex.screenX;
			var sy:Number = screenVertex.screenY;
			var sz:Number = screenVertex.screenZ;
			
			var t:Number = (_tempValue1-_vectorX*sx-_vectorY*sy-_vectorZ*sz)/_tempValue0;
			
			var vectorX:Number = -_vectorX*t;
			var vectorY:Number = -_vectorY*t;
			var vectorZ:Number = -_vectorZ*t;
			
			var k:Number = 1/Math.sqrt(vectorX*vectorX+vectorY*vectorY+vectorZ*vectorZ);
			vectorX *= k;
			vectorY *= k;
			vectorZ *= k;
			
			if (_vectorX*vectorX<0 || _vectorY*vectorY<0 || _vectorZ*vectorZ<0) {
				outputVector.x = 0;
				outputVector.y = 0;
				outputVector.z = 0;
			} else {
				outputVector.x = _vectorX;
				outputVector.y = _vectorY;
				outputVector.z = _vectorZ;
			}
		}
		public override function init(driver:AbstractRenderDriver):void {
			super.init(driver);
			_vectorX = _target.screenX-_position.screenX;
			_vectorY = _target.screenY-_position.screenY;
			_vectorZ = _target.screenZ-_position.screenZ;
			_tempValue0 = _vectorX*_vectorX+_vectorY*_vectorY+_vectorZ*_vectorZ;
			_tempValue1 = _vectorX*_position.screenX+_vectorY*_position.screenY+_vectorZ*_position.screenZ;
		}
		public override function lightingTest(pixelScreenVertex:Vertex3D, pixelScreenVector:Vector3D):void {
			var sx:Number = pixelScreenVertex.screenX;
			var sy:Number = pixelScreenVertex.screenY;
			var sz:Number = pixelScreenVertex.screenZ;
			
			var t:Number = (_tempValue1-_vectorX*sx-_vectorY*sy-_vectorZ*sz)/_tempValue0;
			
			var vectorX:Number = -_vectorX*t;
			var vectorY:Number = -_vectorY*t;
			var vectorZ:Number = -_vectorZ*t;
			
			var k:Number = 1/Math.sqrt(vectorX*vectorX+vectorY*vectorY+vectorZ*vectorZ);
			vectorX *= k;
			vectorY *= k;
			vectorZ *= k;
			
			if (_vectorX*vectorX<0 || _vectorY*vectorY<0 || _vectorZ*vectorZ<0) {
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
			
			var vx:Number = pixelScreenVector.x;
			var vy:Number = pixelScreenVector.y;
			var vz:Number = pixelScreenVector.z;
			var d:Number = Math.sqrt(vectorX*vectorX+vectorY*vectorY+vectorZ*vectorZ);
			
			strengthRatio = Math.acos((vectorX*vx+vectorY*vy+vectorZ*vz)/(d*Math.sqrt(vx*vx+vy*vy+vz*vz)))/HALF_PI-1;
			
			if (attenuationEnabled) strengthRatio = _getAttenuationK(strengthRatio, d);
			//if (colorLightEnabled) sourceColor = Color.colorBlendWithLightAttenuation(lightColor, sourceColor, blendStrength);
			//return Color.colorBrightness(sourceColor, (1-selfIlluminationStrength)*_strength*blendStrength+selfIlluminationStrength);
		}
	}
}