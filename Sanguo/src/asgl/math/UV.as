package asgl.math {
	public class UV {
		public var u:Number;
		public var v:Number;
		public function UV(u:Number=0, v:Number=0):void {
			this.u = u;
			this.v = v;
		}
		public function clone():UV {
			return new UV(u, v);
		}
		public function toString():String {
			return '(u='+u+', v='+v+')';
		}
	}
}