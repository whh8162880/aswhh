package asgl.renderers {
	import __AS3__.vec.Vector;
	
	import asgl.drivers.AbstractRenderDriver;
	import asgl.mesh.TriangleFace;
	
	import flash.utils.getTimer;

	public class DebugRenderer implements IRenderer {
		private var _isRunning:Boolean = false;
		private var _useMaxTime:int = -1;
		private var _useMinTime:int = -1;
		private var _useTime:int = 0;
		private var _renderer:IRenderer;
		public function DebugRenderer(renderer:IRenderer=null):void {
			this.renderer = renderer;
		}
		public function get facesType():String {
			return _renderer == null ? null : _renderer.facesType;
		}
		public function get isRunning():Boolean {
			return _isRunning;
		}
		public function get renderer():IRenderer {
			return _renderer;
		}
		public function set renderer(value:IRenderer):void {
			_useMaxTime = -1;
			_useMinTime = -1;
			_useTime = 0;
			_renderer = value;
		}
		public function get useMaxTime():int {
			return _useMaxTime;
		}
		public function get useMinTime():int {
			return _useMinTime;
		}
		public function get useTime():int {
			return _isRunning ? -1 : _useTime;
		}
		public function destroy():void {
			if (_renderer != null) {
				_renderer.destroy();
				_renderer = null;
			}
		}
		public function render(driver:AbstractRenderDriver, faces:Vector.<TriangleFace>, completeFunction:Function):void {
			if (_renderer == null) {
				completeFunction();
				_useTime = 0;
			} else {
				_isRunning = true;
				_useTime = getTimer();
				_renderer.render(driver, faces, function ():void {
					_useTime = getTimer()-_useTime;
					if (_useMaxTime == -1 || _useMaxTime<_useTime) _useMaxTime = _useTime;
					if (_useMinTime == -1 || _useMinTime>_useTime) _useMinTime = _useTime;
					_isRunning = false;
					completeFunction();
				});
			}
		}
	}
}