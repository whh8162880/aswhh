package asgl.drivers {
	import __AS3__.vec.Vector;
	
	import asgl.cameras.Camera3D;
	import asgl.events.DriverEvent;
	import asgl.events.RenderEvent;
	import asgl.mesh.TriangleFace;
	import asgl.renderers.IRenderer;
	import asgl.views.IView;
	
	import flash.utils.getTimer;
	
	[Event(name="runHandlersComplete", type="asgl.events.DriverEvent")]
	[Event(name="renderComplete", type="asgl.events.RenderEvent")]
	
	public class FreeRenderDriver extends AbstractRenderDriver {
		protected var _canRunRenderer:Boolean = false;
		protected var _resultFaces:Vector.<TriangleFace>;
		private var _handlerRunning:Boolean = false;
		private var _isInithandler:Boolean;
		private var _isRendering:Boolean = false;
		private var _currentHandlerIndex:int;
		private var _totalHandlers:int;
		public function FreeRenderDriver(camera:Camera3D=null, view:IView=null, renderer:IRenderer=null):void {
			super(camera, view, renderer);
		}
		public override function destroy():void {
			super.destroy();
			_resultFaces = null;
		}
		public override function render():void {
			if (_isRendering) throw new Error('rendering');
			if (_camera == null) throw new Error('no camera');
			if (_view == null) throw new Error('no view');
			if (_renderer == null) throw new Error('no renderer');
			_totalRenderingTime = getTimer();
			_isRendering = true;
			_startRender();
		}
		public override function runHandlers():void {
			if (_handlerRunning) throw new Error('handlers are running');
			_handlerRunning = true;
			if (_resultFaces == null) _resultFaces = faces == null ? new Vector.<TriangleFace>() : faces.concat();
			_currentHandlerIndex = 0;
			if (initializedHandlers != null && initializedHandlers.length>0) {
				_isInithandler = true;
				_totalHandlers = initializedHandlers.length;
				initializedHandlers[_currentHandlerIndex].handle(this, _resultFaces, _handlerComplete);
			} else {
				_isInithandler = false;
				initializedHandlers = null;
				if (handlers != null && handlers.length>0) {
					_totalHandlers = handlers.length;
					handlers[_currentHandlerIndex].handle(this, _resultFaces, _handlerComplete);
				} else {
					_totalHandlers = 0;
					_handlerComplete(_resultFaces);
				}
			}
		}
		protected function _startRender():void {
			_view.reset(_camera.width, _camera.height, backgroundColor);
			_resultFaces = faces == null ? new Vector.<TriangleFace>() : faces.concat();
			_canRunRenderer = true;
			runHandlers();
		}
		private function _complete():void {
			_rendererRenderingTime = getTimer()-_rendererRenderingTime;
			_resultFaces = null;
			_isRendering = false;
			_canRunRenderer = false;
			_totalRenderingTime = getTimer()-_totalRenderingTime;
			dispatchEvent(new RenderEvent(RenderEvent.RENDER_COMPLETE));
		}
		private function _defaultHandlerComplete(faces:Vector.<TriangleFace>):void {
			_resultFaces = faces;
		}
		private function _handlerComplete(faces:Vector.<TriangleFace>):void {
			_resultFaces = faces;
			_currentHandlerIndex++;
			if (_currentHandlerIndex<_totalHandlers) {
				if (_isInithandler) {
					initializedHandlers[_currentHandlerIndex].handle(this, _resultFaces, _handlerComplete);
				} else {
					handlers[_currentHandlerIndex].handle(this, _resultFaces, _handlerComplete);
				}
			} else {
				if (_isInithandler) {
					_isInithandler = false;
					initializedHandlers = null;
					if (handlers != null && handlers.length>0) {
						_currentHandlerIndex = 0;
						_totalHandlers = handlers.length;
						handlers[_currentHandlerIndex].handle(this, _resultFaces, _handlerComplete);
					} else {
						_handlerComplete(_resultFaces);
					}
				} else {
					_handlerRunning = false;
					if (!_canRunRenderer) _resultFaces = null;
					this.dispatchEvent(new DriverEvent(DriverEvent.RUN_HANDLERS_COMPLETE));
					if (_canRunRenderer) {
						_rendererRenderingTime = getTimer();
						if (_renderer == null) {
							throw new Error('Camera3D no renderer');
						} else {
							_renderer.render(this, _resultFaces, _complete);
						}
					}
				}
			}
		}
	}
}