package asgl.handlers {
	import __AS3__.vec.Vector;
	
	import asgl.drivers.AbstractRenderDriver;
	import asgl.mesh.TriangleFace;
	
	import flash.utils.getTimer;

	public class DebugHandler implements IHandler {
		private var _isRunning:Boolean = false;
		private var _handler:IHandler;
		private var _useMaxTime:int = -1;
		private var _useMinTime:int = -1;
		private var _useTime:int = 0;
		public function DebugHandler(handler:IHandler=null):void {
			this.handler = handler;
		}
		public function get handler():IHandler {
			return _handler;
		}
		public function set handler(value:IHandler):void {
			_useMaxTime = -1;
			_useMinTime = -1;
			_useTime = 0;
			_handler = value;
		}
		public function get isRunning():Boolean {
			return _isRunning;
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
		public function handle(driver:AbstractRenderDriver, faces:Vector.<TriangleFace>, completeFunction:Function):void {
			if (_handler == null) {
				completeFunction(faces);
				_useTime = 0;
			} else {
				_isRunning = true;
				_useTime = getTimer();
				_handler.handle(driver, faces, function (faces:Vector.<TriangleFace>):void {
					_useTime = getTimer()-_useTime;
					if (_useMaxTime == -1 || _useMaxTime<_useTime) _useMaxTime = _useTime;
					if (_useMinTime == -1 || _useMinTime>_useTime) _useMinTime = _useTime;
					_isRunning = false;
					completeFunction(faces);
				});
			}
		}
	}
}