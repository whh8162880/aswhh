package asgl.math {
	import flash.geom.Vector3D;
	
	public class Quaternion {
		private static const K:Number = Math.PI/180/2;
		public var w:Number;
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public function Quaternion(x:Number=0, y:Number=0, z:Number=0, w:Number=1):void {
			this.x = x;
			this.y = y;
			this.z = z;
			this.w = w;
		}
		public function get angle():Number {
			return Math.acos(w)/K;
		}
		public function get matrix():GLMatrix3D {
			var x2:Number = x*2;
			var y2:Number = y*2;
			var z2:Number = z*2;
			var xx:Number = x*x2;
			var xy:Number = x*y2;
			var xz:Number = x*z2;
			var yy:Number = y*y2;
			var yz:Number = y*z2;
			var zz:Number = z*z2;
			var wx:Number = w*x2;
			var wy:Number = w*y2;
			var wz:Number = w*z2;
			return new GLMatrix3D(1-(yy+zz), xy-wz, xz+wy, xy+wz, 1-(xx+zz), yz-wx, xz-wy, yz+wx, 1-(xx+yy));
		}
		public function get vector():Vector3D {
			var s:Number = Math.sin(Math.acos(w));
			return new Vector3D(x/s, y/s, z/s);
		}
		public function computeW():void {
			w = Math.sqrt(1-x*x-y*y-z*z);
		}
		public function computeX():void {
			x = Math.sqrt(1-y*y-z*z-w*w);
		}
		public function computeY():void {
			y = Math.sqrt(1-x*x-z*z-w*w);
		}
		public function computeZ():void {
			z = Math.sqrt(1-x*x-y*y-w*w);
		}
		/**
		 * @param v the v is a normalize vector3D.
		 */
		public function setValue(v:Vector3D, angle:Number):void {
			angle = angle*K;
			var s:Number = Math.sin(angle);
			x = v.x*s;
			y = v.y*s;
			z = v.z*s;
			w = Math.cos(angle);
		}
		/**
		 * @param t the t is 0-1.
		 */
		public static function slerp(q0:Quaternion, q1:Quaternion, t:Number):Quaternion {
			if (t<0) {
				t = 0;
			} else if (t>1) {
				t = 1;
			}
			var w1:Number = q1.w;
			var x1:Number = q1.x;
			var y1:Number = q1.y;
			var z1:Number = q1.z;
			var cosOmega:Number = q0.w*w1+q0.x*x1+q0.y*y1+q0.z*z1;
			if (cosOmega<0) {
				w1 = -w1;
				x1 = -x1;
				y1 = -y1;
				z1 = -z1;
				cosOmega = -cosOmega;
			}
			var k0:Number;
			var k1:Number;
			if (cosOmega>0.9999) {
				k0 = 1-t;
				k1 = t;
			} else {
				var omega:Number = Math.acos(cosOmega);
				var sinOmega:Number = Math.sin(omega);
				k0 = Math.sin((1-t)*omega)/sinOmega;
				k1 = Math.sin(t*omega)/sinOmega;
			}
			return new Quaternion(q0.x*k0+x1*k1, q0.y*k0+y1*k1, q0.z*k0+z1*k1, q0.w*k0+w1*k1);
		}
	}
}