package asgl.lights {
	import asgl.drivers.AbstractRenderDriver;
	import asgl.math.Vertex3D;
	
	import flash.geom.Vector3D;
	
	public class PointLight extends AbstractLight {
		private var _positionX:Number;
		private var _positionY:Number;
		private var _positionZ:Number;
		public function PointLight(strength:Number=0.5, position:Vertex3D=null):void {
			super(position);
			this.strength = strength;
		}
		public override function getLightingVector(screenVertex:Vertex3D, outputVector:Vector3D):void {
			outputVector.x = screenVertex.screenX-_positionX;
			outputVector.y = screenVertex.screenY-_positionY;
			outputVector.z = screenVertex.screenZ-_positionZ;
		}
		public override function init(driver:AbstractRenderDriver):void {
			super.init(driver);
			_positionX = _position.screenX;
			_positionY = _position.screenY;
			_positionZ = _position.screenZ;
		}
		public override function lightingTest(pixelScreenVertex:Vertex3D, pixelScreenVector:Vector3D):void {
			_shadowTest(pixelScreenVertex);
			
			var vectorX:Number = pixelScreenVertex.screenX-_positionX;
			var vectorY:Number = pixelScreenVertex.screenY-_positionY;
			var vectorZ:Number = pixelScreenVertex.screenZ-_positionZ;
			var vx:Number = pixelScreenVector.x;
			var vy:Number = pixelScreenVector.y;
			var vz:Number = pixelScreenVector.z;
			var d:Number = Math.sqrt(vectorX*vectorX+vectorY*vectorY+vectorZ*vectorZ);
			strengthRatio = Math.acos((vectorX*vx+vectorY*vy+vectorZ*vz)/(d*Math.sqrt(vx*vx+vy*vy+vz*vz)))/HALF_PI-1;
			
			if (attenuationEnabled) strengthRatio = _getAttenuationK(strengthRatio, d);
		}
	}
}