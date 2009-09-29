package asgl.effects {
	import asgl.buffer.ZBuffer;
	import asgl.renderers.FullSceneAntiAliasLevel;
	import asgl.views.BitmapDataView;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	
	[Event(name="renderComplete", type="asgl.events.RenderEvent")]
	[Event(name="renderError", type="asgl.events.RenderEvent")]
	[Event(name="resize", type="flash.events.Event")]
	
	public class AbstractEffect extends EventDispatcher {
		public var backgroundColor:uint;
		public var depthBuffer:ZBuffer;
		protected var _view:BitmapDataView = new BitmapDataView();
		protected var _matrix:Matrix = new Matrix();
		protected var _kx:Number = 1;
		protected var _ky:Number = 1;
		protected var _FSAALevel:String = FullSceneAntiAliasLevel.NORMAL;
		protected var _height:uint;
		protected var _width:uint;
		public function AbstractEffect(width:uint, height:uint, backgroundColor:uint=0):void {
			this.backgroundColor = backgroundColor;
			_setSize(width, height);
		}
		public function get canvas():BitmapData {
			return _view.canvas as BitmapData;
		}
		public function get FSAALevel():String {
			return _FSAALevel;
		}
		public function set FSAALevel(value:String):void {
			if (value == FullSceneAntiAliasLevel.NORMAL) {
				_kx = 1;
				_ky = 1;
				_matrix.a = 1;
				_matrix.d = 1;
				_FSAALevel = value;
			} else if (value == FullSceneAntiAliasLevel.HX2) {
				_kx = 0.5;
				_ky = 1;
				_matrix.a = 0.5;
				_matrix.d = 1;
				_FSAALevel = value;
			} else if (value == FullSceneAntiAliasLevel.VX2) {
				_kx = 1;
				_ky = 0.5;
				_matrix.a = 1;
				_matrix.d = 0.5;
				_FSAALevel = value;
			} else if (value == FullSceneAntiAliasLevel.X4) {
				_kx = 0.5;
				_ky = 0.5;
				_matrix.a = 0.5;
				_matrix.d = 0.5;
				_FSAALevel = value;
			}
		}
		public function get height():uint {
			return _height;
		}
		public function set height(value:uint):void {
			_height = value;
			_view.reset(_width/_kx, _height/_ky, backgroundColor);
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		public function get width():uint {
			return _width;
		}
		public function set width(value:uint):void {
			_width = value;
			_view.reset(_width/_kx, _height/_ky, backgroundColor);
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		public function destroy():void {
			depthBuffer = null;
			_view.destroy();
			_view = null;
			_matrix = null;
		}
		public function render(buffer:ZBuffer):void {
		}
		public function setSize(width:int, height:int):void {
			_setSize(width, height);
			_view.reset(_width/_kx, _height/_ky, backgroundColor);
			this.dispatchEvent(new Event(Event.RESIZE));
		}
		private function _setSize(width:int, height:int):void {
			_width = width;
			_height = height;
		}
	}
}