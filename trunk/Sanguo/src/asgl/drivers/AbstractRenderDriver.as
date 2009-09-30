package asgl.drivers {
	import __AS3__.vec.Vector;
	
	import asgl.cameras.Camera3D;
	import asgl.events.DriverEvent;
	import asgl.handlers.IHandler;
	import asgl.lights.AbstractLight;
	import asgl.math.Vertex3D;
	import asgl.mesh.TriangleFace;
	import asgl.renderers.IRenderer;
	import asgl.views.IView;
	
	import flash.events.EventDispatcher;
	
	[Event(name="cameraChange", type="asgl.events.DriverEvent")]
	[Event(name="rendererChange", type="asgl.events.DriverEvent")]
	[Event(name="viewChange", type="asgl.events.DriverEvent")]

	public class AbstractRenderDriver extends EventDispatcher {
		public var backgroundColor:uint = 0;
		public var lights:Vector.<AbstractLight>;
		public var handlers:Vector.<IHandler>;
		public var initializedHandlers:Vector.<IHandler>;
		public var faces:Vector.<TriangleFace>;
		protected var _camera:Camera3D;
		protected var _rendererRenderingTime:int;
		protected var _totalRenderingTime:int;
		protected var _renderer:IRenderer;
		protected var _view:IView;
		protected var _projectionType:String = ProjectionType.PERSPECTIVE;
		public function AbstractRenderDriver(camera:Camera3D=null, view:IView=null, renderer:IRenderer=null):void {
			_camera = camera;
			_view = view;
			_renderer = renderer;
		}
		public function get camera():Camera3D {
			return _camera;
		}
		public function set camera(value:Camera3D):void {
			var e:DriverEvent = new DriverEvent(DriverEvent.CAMERA_CHANGE, _camera);
			_camera = value;
			this.dispatchEvent(e);
		}
		public function get projectionType():String {
			return _projectionType;
		}
		public function set projectionType(value:String):void {
			if (value == ProjectionType.PARALLEL) {
				_projectionType = value;
			} else if (value == ProjectionType.PERSPECTIVE) {
				_projectionType = value;
			}
		}
		public function get renderer():IRenderer {
			return _renderer;
		}
		public function set renderer(value:IRenderer):void {
			var e:DriverEvent = new DriverEvent(DriverEvent.RENDERER_CHANGE, null, _renderer);
			_renderer = value;
			this.dispatchEvent(e);
		}
		public function get rendererRenderingTime():int {
			return _rendererRenderingTime;
		}
		public function get totalRenderingTime():int {
			return _totalRenderingTime;
		}
		public function get view():IView {
			return _view;
		}
		public function set view(value:IView):void {
			var e:DriverEvent = new DriverEvent(DriverEvent.VIEW_CHANGE, null, null, _view);
			_view = value;
			this.dispatchEvent(e);
		}
		public function destroy():void {
			handlers = null;
			initializedHandlers = null;
			_view = null;
			_renderer = null;
		}
		public function render():void {}
		public function runHandlers():void {}
	}
}