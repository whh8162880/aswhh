package asgl.events {
	import asgl.math.Vertex3D;
	import asgl.mesh.TriangleFace;
	
	import flash.events.Event;

	public class Mouse3DEvent extends Event {
		public static const CLICK:String = 'click';
		public static const MOUSE_DOWN:String = 'mouseDown';
		public static const MOUSE_MOVE:String = 'mouseMove';
		public static const MOUSE_OUT:String = 'mouseOut';
		public static const MOUSE_OVER:String = 'mouseOver';
		public static const MOUSE_UP:String = 'mouseUp';
		private var _face:TriangleFace
		private var _vertex:Vertex3D;
		public function Mouse3DEvent(type:String, face:TriangleFace=null, vertex:Vertex3D=null):void {
			super(type);
			_face = face;
			_vertex = vertex;
		}
		public function get face():TriangleFace {
			return _face;
		}
		public function get vertex():Vertex3D {
			return _vertex;
		}
	}
}