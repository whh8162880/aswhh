package asgl.events {
	import flash.events.Event;
	
	public class RenderEvent extends Event {
		public static const RENDER_COMPLETE:String = 'renderComplete';
		public static const RENDER_ERROR:String = 'renderError';
		public function RenderEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false):void {
			super(type, bubbles, cancelable);
		}
	}
}