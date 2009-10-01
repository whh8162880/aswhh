package asgl.events {
	import flash.events.Event;
	public class TextureEvent extends Event {
		public static const TYPE_ERROR:String = 'typeError';
		public static const TEXTURE_RESOURCE_CHANGE:String = 'textureResourceChange';
		public function TextureEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false):void {
			super(type, bubbles, cancelable);
		}
	}
}