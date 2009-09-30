package asgl.math {
	import __AS3__.vec.Vector;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	/**
	 * GLMatrix3D.
	 * <p>a  d  g  axisX</p>
	 * <p>b  e  h  axisY</p>
	 * <p>c  f  i  axisZ</p>
	 * <p>tx ty tz</p>
	 */
	public class GLMatrix3D {
		private static const K:Number = Math.PI/180;
		public var a:Number;
		public var b:Number;
		public var c:Number;
		public var d:Number;
		public var e:Number;
		public var f:Number;
		public var g:Number;
		public var h:Number;
		public var i:Number;
		public var tx:Number;
		public var ty:Number;
		public var tz:Number;
		public function GLMatrix3D(a:Number=1, b:Number=0, c:Number=0, d:Number=0, e:Number=1, f:Number=0, g:Number=0, h:Number=0, i:Number=1, tx:Number=0, ty:Number=0, tz:Number=0):void {
			this.a = a;
			this.b = b;
			this.c = c;
			this.d = d;
			this.e = e;
			this.f = f;
			this.g = g;
			this.h = h;
			this.i = i;
			this.tx = tx;
			this.ty = ty;
			this.tz = tz;
		}
		public function get axisX():Vector3D {
			return new Vector3D(a, d, g);
		}
		public function set axisX(value:Vector3D):void {
			a = value.x;
			d = value.y;
			g = value.z;
		}
		public function get axisY():Vector3D {
			return new Vector3D(b, e, h);
		}
		public function set axisY(value:Vector3D):void {
			b = value.x;
			e = value.y;
			h = value.z;
		}
		public function get axisZ():Vector3D {
			return new Vector3D(c, f, i);
		}
		public function set axisZ(value:Vector3D):void {
			c = value.x;
			f = value.y;
			i = value.z;
		}
		public function get quaternion():Quaternion {
			var quat:Quaternion = new Quaternion();
			var s:Number;
			var tr:Number = a+e+i;
			if (tr>0) {
				s = Math.sqrt(tr+1);
				quat.w = s/2;
				s = 0.5/s;
				quat.x = (h-f)*s;
				quat.y = (c-g)*s;
				quat.z = (d-b)*s;
			} else {
				var index:int = 0;
				if (e>a) index = 1;
				if (i>(index == 0 ? a : e)) index = 2;
				if (index == 0) {
					s = Math.sqrt((a-(e+i))+1);
					quat.x = s*0.5;
					if (s != 0) s = 0.5/s;
					quat.y = (d+b)*s;
					quat.z = (g+c)*s;
					quat.w = (h-f)*s;
				} else if (index == 1) {
					s = Math.sqrt((e-(i+a))+1);
					quat.y = s*0.5;
					if (s != 0) s = 0.5/s;
					quat.z = (h+f)*s;
					quat.x = (b+d)*s;
					quat.w = (c-g)*s;
				} else {
					s = Math.sqrt((i-(a+e))+1);
					quat.z = s*0.5;
					if (s != 0) s = 0.5/s;
					quat.x = (c+g)*s;
					quat.y = (f+h)*s;
					quat.w = (d-b)*s;
				}
			}
			return quat;
		}
		public function set rootRotationX(value:Number):void {
			value *= K;
			var sin:Number = Math.sin(value);
			var cos:Number = Math.cos(value);
			var md:Number = d;
			var me:Number = e;
			var mf:Number = f;
			var mty:Number = ty;
			d = md*cos-g*sin;
			e = me*cos-h*sin;
			f = mf*cos-i*sin;
			g = md*sin+g*cos;
			h = me*sin+h*cos;
			i = mf*sin+i*cos;
			ty = mty*cos-tz*sin;
			tz = mty*sin+tz*cos;
		}
		public function set rootRotationY(value:Number):void {
			value *= K;
			var sin:Number = Math.sin(value);
			var cos:Number = Math.cos(value);
			var ma:Number = a;
			var mb:Number = b;
			var mc:Number = c;
			var mtx:Number = tx;
			a = ma*cos+g*sin;
			b = mb*cos+h*sin;
			c = mc*cos+i*sin;
			g = -ma*sin+g*cos;
			h = -mb*sin+h*cos;
			i = -mc*sin+i*cos;
			tx = mtx*cos+tz*sin;
			tz = -mtx*sin+tz*cos;
		}
		public function set rootRotationZ(value:Number):void {
			value *= K;
			var sin:Number = Math.sin(value);
			var cos:Number = Math.cos(value);
			var ma:Number = a;
			var mb:Number = b;
			var mc:Number = c;
			var mtx:Number = tx;
			a = ma*cos-d*sin;
			b = mb*cos-e*sin;
			c = mc*cos-f*sin;
			d = ma*sin+d*cos;
			e = mb*sin+e*cos;
			f = mc*sin+f*cos;
			tx = mtx*cos-ty*sin;
			ty = mtx*sin+ty*cos;
		}
		public function set rotationX(value:Number):void {
			value *= K;
			var sin:Number = Math.sin(value);
			var cos:Number = Math.cos(value);
			var mb:Number = b;
			var me:Number = e;
			var mh:Number = h;
			b = cos*mb+sin*c;
			c = -sin*mb+cos*c;
			e = cos*me+sin*f;
			f = -sin*me+cos*f;
			h = cos*mh+sin*i;
			i = -sin*mh+cos*i;
		}
		public function set rotationY(value:Number):void {
			value *= K;
			var sin:Number = Math.sin(value);
			var cos:Number = Math.cos(value);
			var ma:Number = a;
			var md:Number = d;
			var mg:Number = g;
			a = cos*ma-sin*c;
			c = sin*ma+cos*c;
			d = cos*md-sin*f;
			f = sin*md+cos*f;
			g = cos*mg-sin*i;
			i = sin*mg+cos*i;
		}
		public function set rotationZ(value:Number):void {
			value *= K;
			var sin:Number = Math.sin(value);
			var cos:Number = Math.cos(value);
			var ma:Number = a;
			var md:Number = d;
			var mg:Number = g;
			a = cos*ma+sin*b;
			b = -sin*ma+cos*b;
			d = cos*md+sin*e;
			e = -sin*md+cos*e;
			g = cos*mg+sin*h;
			h = -sin*mg+cos*h;
		}
		public function set translateX(value:Number):void {
			tx += value*a;
			ty += value*d;
			tz += value*g;
		}
		public function set translateY(value:Number):void {
			tx += value*b;
			ty += value*e;
			tz += value*h;
		}
		public function set translateZ(value:Number):void {
			tx += value*c;
			ty += value*f;
			tz += value*i;
		}
		public function clone():GLMatrix3D {
			return new GLMatrix3D(a, b, c, d, e, f, g, h, i, tx, ty, tz);
		}
		public function concat(m:GLMatrix3D):void {
			var ma:Number = m.a;
			var mb:Number = m.b;
			var mc:Number = m.c;
			var md:Number = m.d;
			var me:Number = m.e;
			var mf:Number = m.f;
			var mg:Number = m.g;
			var mh:Number = m.h;
			var mi:Number = m.i;
			var tempa:Number = a*ma+d*mb+g*mc;
			var tempb:Number = b*ma+e*mb+h*mc;
			var tempc:Number = c*ma+f*mb+i*mc;
			var tempd:Number = a*md+d*me+g*mf;
			var tempe:Number = b*md+e*me+h*mf;
			var tempf:Number = c*md+f*me+i*mf;
			g = a*mg+d*mh+g*mi;
			h = b*mg+e*mh+h*mi;
			i = c*mg+f*mh+i*mi;
			var temptx:Number = tx*ma+ty*mb+tz*mc+m.tx;
			var tempty:Number = tx*md+ty*me+tz*mf+m.ty;
			tz = tx*mg+ty*mh+tz*mi+m.tz;
			a = tempa;
			b = tempb;
			c = tempc;
			d = tempd;
			e = tempe;
			f = tempf;
			tx = temptx;
			ty = tempty;
		}
		public function coordinatesTransform():void {
			var temp:Number = b;
			b = c;
			c = temp;
			temp = d;
			d = g;
			g = temp;
			temp = e;
			e = i;
			i = temp;
			temp = f;
			f = h;
			h = temp;
			temp = ty;
			ty = tz;
			tz = temp;
		}
		public function copy(m:GLMatrix3D):void {
			a = m.a;
			b = m.b;
			c = m.c;
			d = m.d;
			e = m.e;
			f = m.f;
			g = m.g;
			h = m.h;
			i = m.i;
			tx = m.tx;
			ty = m.ty;
			tz = m.tz;
		}
		public function equals(toCompare:GLMatrix3D):Boolean {
			return a == toCompare.a && b == toCompare.b && c == toCompare.c && d == toCompare.d && e == toCompare.e && f == toCompare.f && g == toCompare.g && h == toCompare.h && i == toCompare.i && tx == toCompare.tx && ty == toCompare.ty && tz == toCompare.tz;
		}
		public static function getRotationXMatrix(angle:Number):GLMatrix3D {
			angle *= K;
			var sin:Number = Math.sin(angle);
			var cos:Number = Math.cos(angle);
			return new GLMatrix3D(1, 0, 0, 0, cos, -sin, 0, sin, cos);
		}
		public static function getRotationYMatrix(angle:Number):GLMatrix3D {
			angle *= K;
			var sin:Number = Math.sin(angle);
			var cos:Number = Math.cos(angle);
			return new GLMatrix3D(cos, 0, sin, 0, 1, 0, -sin, 0, cos);
		}
		public static function getRotationZMatrix(angle:Number):GLMatrix3D {
			angle *= K;
			var sin:Number = Math.sin(angle);
			var cos:Number = Math.cos(angle);
			return new GLMatrix3D(cos, -sin, 0, sin, cos);
		}
		public static function getScaleMatrix(sx:Number, sy:Number, sz:Number):GLMatrix3D {
			return new GLMatrix3D(sx, 0, 0, 0, sy, 0, 0, 0, sz);
		}
		/**
		 * @param t the t is 0-1.
		 */
		public static function interpolation(m0:GLMatrix3D, m1:GLMatrix3D, t:Number):GLMatrix3D {
			if (t<0) {
				t = 0;
			} else if (t>1) {
				t = 1;
			}
			var mt:GLMatrix3D = Quaternion.slerp(m0.quaternion, m1.quaternion, t).matrix;
			var d:Number = m1.tx-m0.tx;
			mt.tx = m0.tx+d*t;
			d = m1.ty-m0.ty;
			mt.ty = m0.ty+d*t;
			d = m1.tz-m0.tz;
			mt.tz = m0.tz+d*t;
			return mt;
		}
		public function invert():Boolean {
			var k:Number = (a*e-d*b)*i-(a*h-g*b)*f+(d*h-g*e)*c;
			//var k:Number = (a*e-d*b)*i-(a*h-g*b)*f+(b*f-c*e)*g;
			if (k == 0) return false;
			k = 1/k;
			var tempa:Number = k*(e*i-h*f);
			var tempb:Number = k*(h*c-b*i);
			var tempc:Number = k*(b*f-e*c);
			var tempd:Number = k*(f*g-i*d);
			var tempe:Number = k*(i*a-c*g);
			var tempf:Number = k*(c*d-f*a);
			var tempg:Number = k*(d*h-g*e);
			var temph:Number = k*(g*b-a*h);
			var tempi:Number = k*(a*e-d*b);
			var temptx:Number = k*(b*(i*ty-f*tz)+e*(c*tz-i*tx)+h*(f*tx-c*ty));
			//matrix.ty = k*(a*(f*tz-i*ty)-d*(c*tz-i*tx)+g*(c*ty-f*tx));
			var tempty:Number = k*(c*(g*ty-d*tz)+f*(a*tz-g*tx)+i*(d*tx-a*ty));
			//matrix.tz = k*(a*(h*ty-e*tz)+d*(b*tz-h*tx)+g*(e*tx-b*ty));
			tz = k*(tx*(g*e-d*h)+ty*(a*h-g*b)+tz*(d*b-a*e));
			a = tempa;
			b = tempb;
			c = tempc;
			d = tempd;
			e = tempe;
			f = tempf;
			g = tempg;
			h = temph;
			i = tempi;
			tx = temptx;
			ty = tempty;
			return true;
		}
		public function reset():void {
			a = 1;
			b = 0;
			c = 0;
			d = 0;
			e = 1;
			f = 0;
			g = 0;
			h = 0;
			i = 1;
			tx = 0;
			ty = 0;
			tz = 0;
		}
		public function position(tx:Number, ty:Number, tz:Number):void {
			this.tx = tx;
			this.ty = ty;
			this.tz = tz;
		}
		public function setValue(a:Number=1, b:Number=0, c:Number=0, d:Number=0, e:Number=1, f:Number=0, g:Number=0, h:Number=0, i:Number=1, tx:Number=0, ty:Number=0, tz:Number=0):void {
			this.a = a;
			this.b = b;
			this.c = c;
			this.d = d;
			this.e = e;
			this.f = f;
			this.g = g;
			this.h = h;
			this.i = i;
			this.tx = tx;
			this.ty = ty;
			this.tz = tz;
		}
		public function toMatrix3D():Matrix3D {
			var list:Vector.<Number> = new Vector.<Number>();
			list[0] = a;
			list[1] = d;
			list[2] = g;
			list[3] = 0;
			list[4] = b;
			list[5] = e;
			list[6] = h;
			list[7] = 0;
			list[8] = c;
			list[9] = f;
			list[10] = i;
			list[11] = 0;
			list[12] = tx;
			list[13] = ty;
			list[14] = tz;
			list[15] = 1;
			return new Matrix3D(list);
		}
		public function translate(x:Number, y:Number, z:Number):void {
			tx += x*a+y*b+z*c;
			ty += x*d+y*e+z*f;
			tz += x*g+y*h+z*i;
		}
		public function toString():String {
			return '(a='+a+', d='+d+', g='+g+'\n b='+b+', e='+e+', h='+h+'\n c='+c+', f='+f+', i='+i+'\n tx='+tx+', ty='+ty+', tz='+tz+')';
		}
	}
}