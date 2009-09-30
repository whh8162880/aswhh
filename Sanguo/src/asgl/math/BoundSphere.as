package asgl.math {
	public class BoundSphere {
		public var radius:Number;
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public function BoundSphere(x:Number=0, y:Number=0, z:Number=0, radius:Number=0):void {
			this.x = x;
			this.y = y;
			this.z = z;
			this.radius = radius;
		}
		public function reset():void {
			x = 0;
			y = 0;
			z = 0;
			radius = 0;
		}
		public function setValueFromBoundBox(value:BoundBox):void {
			if (value == null) return;
			x = value.originX;
			y = value.originY;
			z = value.originZ;
			var d:Number = value.maxX-value.minX;
			var dy:Number = value.maxY-value.minY;
			var dz:Number = value.maxZ-value.minZ;
			if (d<dy) d = dy;
			if (d<dz) d = dz;
			radius = d/2;
		}
	}
}