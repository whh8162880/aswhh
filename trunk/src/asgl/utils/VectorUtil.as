package asgl.utils {
	public class VectorUtil {
		public static function clear(v:Object):void {
			v.splic(0, v.length);
		}
		public static function concat(v0:Object, v1:Object):void {
			var length:int = v1.length;
			for (var i:int = 0; i<length; i++) {
				v0.push(v1[i]);
			}
		}
	}
}