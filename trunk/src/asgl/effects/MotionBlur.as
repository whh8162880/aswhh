package asgl.effects {
	import __AS3__.vec.Vector;
	
	import asgl.buffer.ZBuffer;
	import asgl.events.RenderEvent;
	
	import flash.display.BitmapData;
	
	public class MotionBlur extends AbstractEffect {
		public var alphaAttenuation:Number;
		private var _blurCount:int;
		private var _ZBufferList:Vector.<ZBuffer> = new Vector.<ZBuffer>();
		public function MotionBlur(width:uint, height:uint, blurCount:int=1, alphaAttenuation:Number=0):void {
			super(width, height);
			this.blurCount = blurCount;
			this.alphaAttenuation = alphaAttenuation;
			depthBuffer = new ZBuffer();
		}
		public function get blurCount():int {
			return _blurCount-1;
		}
		public function set blurCount(value:int):void {
			if (value<0) value = 0;
			_blurCount = value+1;
		}
		public override function destroy():void {
			super.destroy();
			_ZBufferList = null;
		}
		public override function render(buffer:ZBuffer):void {
			if (buffer == null || depthBuffer == null) {
				this.dispatchEvent(new RenderEvent(RenderEvent.RENDER_ERROR));
			} else {
				if (buffer != null) _ZBufferList.splice(0, 0, buffer.cloneByRefreshCount(buffer.refreshCount));
				var length:int = _ZBufferList.length;
				if (length>_blurCount) {
					_ZBufferList.splice(_blurCount, length-_blurCount);
					length = _ZBufferList.length;
				}
				depthBuffer.refreshCount++;
				var zbuffer:ZBuffer = _ZBufferList[0];
				depthBuffer.concat(zbuffer, zbuffer.refreshCount);
				for (var i:int = 1; i<length; i++) {
					zbuffer = _ZBufferList[i];
					zbuffer.alphaAttenuation(alphaAttenuation, zbuffer.refreshCount);
					depthBuffer.concat(zbuffer, zbuffer.refreshCount);
				}
				var source:BitmapData = depthBuffer.render(_width/_kx, _height/_ky, depthBuffer.refreshCount);
				_view.reset(_width/_kx, _height/_ky, backgroundColor);
				(_view.canvas as BitmapData).draw(source, _matrix, null, null, null, true);
				source.dispose();
				this.dispatchEvent(new RenderEvent(RenderEvent.RENDER_COMPLETE));
			}
		}
	}
}