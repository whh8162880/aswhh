package asgl.views {
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.IBitmapDrawable;
	import flash.display.Sprite;
	
	public class SpriteView implements IView {
		private var _canvas:Sprite = new Sprite();
		private var _graphics:Graphics = _canvas.graphics;
		private var _viewType:String = ViewType.SPRITE;
		private var _height:uint = 0;
		private var _width:uint = 0;
		private var _backgroundColor:uint = 0;
		public function get backgroundColor():uint {
			return _backgroundColor;
		}
		public function get canvas():IBitmapDrawable {
			return _canvas;
		}
		public function get height():uint {
			return _height;
		}
		public function get viewType():String {
			return _viewType;
		}
		public function get width():uint {
			return _width;
		}
		public function destroy():void {
			if (_canvas.parent != null) _canvas.parent.removeChild(_canvas);
			var num:int = _canvas.numChildren;
			for (var i:int = 0; i<num; i++) {
				_canvas.removeChildAt(0);
			}
			_canvas = null;
			_graphics = null;
		}
		public function draw(view:IView):void {
			if (this == view || view == null) return;
			var bmp:BitmapData;
			var type:String = view.viewType;
			if (type == ViewType.BITMAPDATA) {
				bmp = view.canvas as BitmapData;
			} else if (type == ViewType.SHAPE || type == ViewType.SPRITE) {
				var width:uint = view.width;
				var height:uint = view.height;
				if (width<1) width = 1;
				if (height<1) height = 1;
				bmp = new BitmapData(width, height, true, 0);
				bmp.draw(view.canvas);
			}
			if (bmp != null) {
				_graphics.beginBitmapFill(bmp);
				_graphics.drawRect(0, 0, _width, _height);
			}
		}
		public function reset(width:uint, height:uint, backgroundColor:uint=0):void {
			_width = width;
			_height = height;
			_graphics.clear();
			if (backgroundColor != 0) {
				var alpha:int = backgroundColor>>24&0xFF;
				if (alpha != 0) {
					_graphics.beginFill(backgroundColor&0xFFFFFF, alpha/255);
					_graphics.drawRect(0, 0, _width, _height);
				}
			}
		}
	}
}