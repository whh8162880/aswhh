package asgl.views {
	import asgl.cameras.Camera3D;
	import asgl.drivers.AbstractRenderDriver;
	import asgl.events.DriverEvent;
	import asgl.events.RenderEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;

	public class Viewport extends Sprite {
		private var _bitmap:Bitmap = new Bitmap();
		private var _backgroundMouseEnabled:Boolean = false;
		private var _driver:AbstractRenderDriver;
		private var _view:IView;
		public function Viewport(driver:AbstractRenderDriver=null):void {
			this.mouseEnabled = false;
			this.driver = driver;
		}
		public function get backgroundMouseEnabled():Boolean {
			return _backgroundMouseEnabled;
		}
		public function set backgroundMouseEnabled(value:Boolean):void {
			_backgroundMouseEnabled = value;
			if (_backgroundMouseEnabled && _driver != null) {
				_cameraResizeHandler(null);
			} else {
				super.graphics.clear();
			}
		}
		public function get driver():AbstractRenderDriver {
			return _driver;
		}
		public function set driver(value:AbstractRenderDriver):void {
			if (_driver == value) return;
			if (_driver != null) {
				_driver.removeEventListener(DriverEvent.CAMERA_CHANGE, _driverCameraChangeHandler);
				_driver.removeEventListener(DriverEvent.VIEW_CHANGE, _driverViewChangeHandler);
				_driver.removeEventListener(RenderEvent.RENDER_COMPLETE, _renderCompleteHandler);
				if (_driver.camera != null) _driver.camera.removeEventListener(Event.RESIZE, _cameraResizeHandler);
				_bitmap.bitmapData = null;
				_view = null;
			}
			_clear();
			_driver = value;
			if (_driver == null) return;
			_setView();
			_driver.addEventListener(DriverEvent.CAMERA_CHANGE, _driverCameraChangeHandler);
			_driver.addEventListener(DriverEvent.VIEW_CHANGE, _driverViewChangeHandler);
			_driver.addEventListener(RenderEvent.RENDER_COMPLETE, _renderCompleteHandler);
			if (_driver.camera != null) _driver.camera.addEventListener(Event.RESIZE, _cameraResizeHandler);
		}
		public override function get numChildren():int {
			return 0;
		}
		public override function get graphics():Graphics {
			return null;
		}
		public override function addChild(child:DisplayObject):DisplayObject {
			return null;
		}
		public override function addChildAt(child:DisplayObject, index:int):DisplayObject {
			return null;
		}
		public override function removeChild(child:DisplayObject):DisplayObject {
			return null;
		}
		public override function removeChildAt(index:int):DisplayObject {
			return null;
		}
		private function _cameraResizeHandler(e:Event):void {
			if (_view is BitmapDataView) _bitmap.bitmapData = _view.canvas as BitmapData;
			if (_backgroundMouseEnabled) {
				super.graphics.beginFill(0, 0);
				var camera:Camera3D = _driver.camera;
				if (camera == null) {
					super.graphics.drawRect(0, 0, 0, 0);
				} else {
					super.graphics.drawRect(0, 0, camera.width, camera.height);
				}
			}
		}
		private function _clear():void {
			_bitmap.bitmapData = null;
			var num:int = super.numChildren;
			for (var i:int = 0; i<num; i++) {
				super.removeChildAt(0);
			}
		}
		private function _driverCameraChangeHandler(e:DriverEvent):void {
			if (e.oldCamera != null) e.oldCamera.removeEventListener(Event.RESIZE, _cameraResizeHandler);
			if (_driver.camera != null) _driver.camera.addEventListener(Event.RESIZE, _cameraResizeHandler);
		}
		private function _driverViewChangeHandler(e:DriverEvent):void {
			_clear();
			_setView();
		}
		private function _renderCompleteHandler(e:RenderEvent):void {
			if (_view is BitmapDataView && _bitmap.bitmapData != _view.canvas) _driverViewChangeHandler(null);
		}
		private function _setView():void {
			_view = _driver.view;
			if (_view != null) {
				if (_view is BitmapDataView) {
					_bitmap.bitmapData = _view.canvas as BitmapData;
					super.addChild(_bitmap);
				} else if (_view is ShapeView || _view is SpriteView) {
					super.addChild(_view.canvas as DisplayObject);
				}
			}
			_cameraResizeHandler(null);
		}
	}
}