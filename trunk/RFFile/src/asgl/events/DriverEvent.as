package asgl.events {
	import asgl.cameras.Camera3D;
	import asgl.renderers.IRenderer;
	import asgl.views.IView;
	
	import flash.events.Event;

	public class DriverEvent extends Event {
		public static const CAMERA_CHANGE:String = 'cameraChange';
		public static const RENDERER_CHANGE:String = 'rendererChange';
		public static const RUN_HANDLERS_COMPLETE:String = 'runHandlersComplete';
		public static const VIEW_CHANGE:String = 'viewChange';
		private var _oldCamera:Camera3D;
		private var _oldRenderer:IRenderer;
		private var _oldView:IView;
		public function DriverEvent(type:String, oldCamera:Camera3D=null, oldRenderer:IRenderer=null, oldView:IView=null):void {
			super(type);
			_oldCamera = oldCamera;
			_oldRenderer = oldRenderer;
			_oldView = oldView;
		}
		public function get oldCamera():Camera3D {
			return _oldCamera;
		}
		public function get oldRenderer():IRenderer {
			return _oldRenderer;
		}
		public function get oldView():IView {
			return _oldView;
		}
	}
}