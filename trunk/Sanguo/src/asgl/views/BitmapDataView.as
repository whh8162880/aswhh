package asgl.views {
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.geom.Rectangle;
	
	public class BitmapDataView implements IView {
		private var _canvas:BitmapData;
		private var _rect:Rectangle = new Rectangle(0, 0, 1, 1);
		private var _viewType:String = ViewType.BITMAPDATA;
		private var _backgroundColor:uint = 0;
		public function get backgroundColor():uint {
			return _backgroundColor;
		}
		public function get canvas():IBitmapDrawable {
			return _canvas;
		}
		public function get height():uint {
			return _rect.height;
		}
		public function get viewType():String {
			return _viewType;
		}
		public function get width():uint {
			return _rect.width;
		}
		public function destroy():void {
			try {
				_canvas.dispose();
			} catch (e:Error) {}
			_canvas = null;
			_rect = null;
		}
		public function draw(view:IView):void {
			if (view == null) return;
			if (_canvas == null) _canvas = new BitmapData(_rect.width, _rect.height, true, _backgroundColor);
			_canvas.draw(view.canvas);
		}
		public function reset(width:uint, height:uint, backgroundColor:uint=0):void {
			if (width<1) width = 1;
			if (height<1) height = 1;
			_backgroundColor = backgroundColor;
			try {
				if (_canvas.width == width && _canvas.height == height) {
					_canvas.fillRect(_rect, backgroundColor);
				} else {
					_canvas.dispose();
					_canvas = new BitmapData(width, height, true, backgroundColor);
					_rect.width = width;
					_rect.height = height;
				}
			} catch (e:Error) {
				_canvas = new BitmapData(width, height, true, backgroundColor);
				_rect.width = width;
				_rect.height = height;
			}
		}
	}
}