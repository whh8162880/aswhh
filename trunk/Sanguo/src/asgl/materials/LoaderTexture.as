package asgl.materials {
	import asgl.events.FileEvent;
	import asgl.events.TextureEvent;
	import asgl.files.images.ImageReader;
	
	import flash.display.BitmapData;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	[Event(name="ioError", type="flash.events.IOErrorEvent")]
	[Event(name="typeError", type="asgl.events.MaterialEvent")]
	
	public class LoaderTexture extends Texture {
		public var throwErrorEnabled:Boolean;
		public function LoaderTexture(request:URLRequest=null, throwError:Boolean=true):void {
			super(new BitmapData(1, 1, true, 0x00FFFFFF));
			throwErrorEnabled = throwError;
			if (request != null) load(request);
		}
		public function load(request:URLRequest):void {
			if (request == null) {
				if (throwErrorEnabled) throw new IOError('io error');
			} else {
				var urlLoader:URLLoader = new URLLoader();
				urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				urlLoader.load(request);
				urlLoader.addEventListener(Event.COMPLETE, _urlLoaderCompleteHandler);
				urlLoader.addEventListener(IOErrorEvent.IO_ERROR, _urlLoaderErrorHandler);
			}
		}
		public function loadBytes(bytes:ByteArray):void {
			if (bytes == null) {
				if (throwErrorEnabled) throw new IOError('io error');
			} else {
				var render:ImageReader = new ImageReader();
				render.addEventListener(FileEvent.COMPLETE, _imageRenderCompleteHandler);
				render.addEventListener(FileEvent.ERROR, _imageRenderErrorHandler);
				render.read(bytes);
			}
		}
		private function _imageRenderCompleteHandler(e:FileEvent):void {
			var render:ImageReader = e.currentTarget as ImageReader;
			render.removeEventListener(FileEvent.COMPLETE, _imageRenderCompleteHandler);
			render.removeEventListener(FileEvent.ERROR, _imageRenderErrorHandler);
			this.bitmapData = render.bitmapData;
		}
		private function _imageRenderErrorHandler(e:FileEvent):void {
			var render:ImageReader = e.currentTarget as ImageReader;
			render.removeEventListener(FileEvent.COMPLETE, _imageRenderCompleteHandler);
			render.removeEventListener(FileEvent.ERROR, _imageRenderErrorHandler);
			if (hasEventListener(TextureEvent.TYPE_ERROR)) {
				this.dispatchEvent(new TextureEvent(TextureEvent.TYPE_ERROR));
			} else {
				if (throwErrorEnabled) throw new Error('texture type error');
			}
		}
		private function _urlLoaderCompleteHandler(e:Event):void {
			var urllader:URLLoader = e.currentTarget as URLLoader;
			urllader.removeEventListener(Event.COMPLETE, _urlLoaderCompleteHandler);
			urllader.removeEventListener(IOErrorEvent.IO_ERROR, _urlLoaderErrorHandler);
			urllader.close();
			var reader:ImageReader = new ImageReader();
			reader.addEventListener(FileEvent.COMPLETE, _imageRenderCompleteHandler);
			reader.addEventListener(FileEvent.ERROR, _imageRenderErrorHandler);
			reader.read(urllader.data);
		}
		private function _urlLoaderErrorHandler(e:IOErrorEvent):void {
			var urllader:URLLoader = e.currentTarget as URLLoader;
			urllader.removeEventListener(Event.COMPLETE, _urlLoaderCompleteHandler);
			urllader.removeEventListener(IOErrorEvent.IO_ERROR, _urlLoaderErrorHandler);
			urllader.close();
			if (hasEventListener(IOErrorEvent.IO_ERROR)) {
				this.dispatchEvent(e);
			} else {
				if (throwErrorEnabled) throw new IOError('io error');
			}
		}
	}
}