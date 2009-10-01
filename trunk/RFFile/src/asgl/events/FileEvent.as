package asgl.events {
	import flash.events.Event;

	public class FileEvent extends Event {
		public static const COMPLETE:String = 'complete';
		public static const ERROR:String = 'error';
		public var error:Error;
		public function FileEvent(type:String, error:Error=null):void {
			super(type);
			this.error = error;
		}
	}
}