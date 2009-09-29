package asgl.utils {
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.utils.Timer;
	
	[Event(name="change", type="flash.events.Event")]
	
	public class FPS extends EventDispatcher {
		private var _displayObject:DisplayObject;
		private var _currentFPS:int;
		private var _FPSCount:int;
		private var _timer:Timer;
		public function FPS():void {
			_displayObject = new Shape();
			_timer = new Timer(1000, 0);
		}
		public function get currentFPS():int {
			return _currentFPS;
		}
		public function start():void {
			_displayObject.addEventListener(Event.ENTER_FRAME, _enterFrameHandler);
			_timer.addEventListener(TimerEvent.TIMER, _timerHandler);
			_timer.start();
		}
		public function stop():void {
			_displayObject.removeEventListener(Event.ENTER_FRAME, _enterFrameHandler);
			_timer.removeEventListener(TimerEvent.TIMER, _timerHandler);
			_timer.stop();
		}
		private function _enterFrameHandler(event:Event):void {
			_FPSCount++;
		}
		private function _timerHandler(event:TimerEvent):void {
			_currentFPS = _FPSCount;
			_FPSCount = 0;
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}