package asgl.materials {
	import flash.display.BitmapData;
	import flash.display.IBitmapDrawable;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class MovieTexture extends Texture {
		private var _source:IBitmapDrawable;
		private var _timer:Timer;
		private var _delay:uint;
		public function MovieTexture(source:IBitmapDrawable=null, delay:uint=33):void {
			super(null);
			_source = source;
			_delay = delay;
			_timer = new Timer(_delay);
			_timer.addEventListener(TimerEvent.TIMER, _timerHandler, false, 0, true);
			if (_source != null) {
				_bitmapData = _draw(_source);
				_height = _bitmapData.height;
				_width = _bitmapData.width;
			}
		}
		public function get delay():uint {
			return _delay;
		}
		public function set delay(value:uint):void {
			if (_delay != value) {
				_delay = value;
				_timer.delay = _delay;
				if (_timer.running) {
					_timer.reset();
					_timer.start();
				}
			}
		}
		public function get source():IBitmapDrawable {
			return _source;
		}
		public function set source(value:IBitmapDrawable):void {
			_source = value;
			if (_source == null && _timer.running) _timer.stop();
		}
		public function start():void {
			if (_source != null && !_timer.running) {
				_timer.reset();
				_timer.start();
			}
		}
		public function stop():void {
			_timer.stop();
		}
		protected function _draw(source:IBitmapDrawable):BitmapData {
			var s:Object = source;
			var bmpData:BitmapData = new BitmapData(s.width, s.height, true, 0);
			bmpData.draw(source);
			return bmpData;
		}
		private function _timerHandler(e:TimerEvent):void {
			if (_source != null) this.bitmapData = _draw(_source);
		}
	}
}