package asgl.math {
	public class BoundBox {
		public var minX:Number;
		public var maxX:Number;
		public var minY:Number;
		public var maxY:Number;
		public var minZ:Number;
		public var maxZ:Number;
		public function BoundBox(minX:Number=0, maxX:Number=0, minY:Number=0, maxY:Number=0, minZ:Number=0, maxZ:Number=0):void {
			this.minX = minX;
			this.maxX = maxX;
			this.minY = minY;
			this.maxY = maxY;
			this.minZ = minZ;
			this.maxZ = maxZ;
		}
		public function get originX():Number {
			var middle:Number = (maxX-minX)/2;
			var absMax:Number = maxX<0 ? -maxX : maxX;
			var absMin:Number = minX<0 ? -minX : minX;
			if (absMax>absMin) {
				return absMax-middle;
			} else {
				return middle-absMin;
			}
		}
		public function get originY():Number {
			var middle:Number = (maxY-minY)/2;
			var absMax:Number = maxY<0 ? -maxY : maxY;
			var absMin:Number = minY<0 ? -minY : minY;
			if (absMax>absMin) {
				return absMax-middle;
			} else {
				return middle-absMin;
			}
		}
		public function get originZ():Number {
			var middle:Number = (maxZ-minZ)/2;
			var absMax:Number = maxZ<0 ? -maxZ : maxZ;
			var absMin:Number = minZ<0 ? -minZ : minZ;
			if (absMax>absMin) {
				return absMax-middle;
			} else {
				return middle-absMin;
			}
		}
		public function clone():BoundBox {
			return new BoundBox(minX, maxX, minY, maxY, minZ, maxZ);
		}
		public function reset():void {
			minX = 0;
			maxX = 0;
			minY = 0;
			maxY = 0;
			minZ = 0;
			maxZ = 0;
		}
		public function toString():String {
			return '(minX='+minX+',maxX='+maxX+',minY='+minY+',maxY='+maxY+',minZ='+minZ+',maxZ='+maxZ+')';
		}
	}
}