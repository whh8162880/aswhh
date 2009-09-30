package asgl.effects {
	import asgl.buffer.ZBuffer;
	import asgl.data.info.PixelInfo;
	import asgl.events.RenderEvent;
	
	import flash.display.BitmapData;
	
	public class DepthOfField extends AbstractEffect {
		private static const ZBUFFER_COEFFICIENT:int = ZBuffer.COEFFICIENT;
		private static const MAX_FAR:Number = Number.POSITIVE_INFINITY;
		private static const K1:Number = 0.25;
		private static const K2:Number = 1/12;
		private static const K3:Number = 1/6;
		public var sourceCanvas:BitmapData;
		public var farFocus:Number;
		public var nearFocus:Number;
		private var _repeatCount:uint;
		public function DepthOfField(width:uint, height:uint, nearFocus:Number, farFocus:Number, repeatCount:uint=1):void {
			super(width, height);
			this.nearFocus = nearFocus;
			this.farFocus = farFocus;
			this.repeatCount = repeatCount;
		}
		public function get repeatCount():uint {
			return _repeatCount;
		}
		public function set repeatCount(value:uint):void {
			_repeatCount = value;
		}
		public override function destroy():void {
			sourceCanvas = null;
			super.destroy();
		}
		public override function render(buffer:ZBuffer):void {
			_view.reset(_width/_kx, _height/_ky, backgroundColor);
			var output:BitmapData = _view.canvas as BitmapData;
			if (buffer == null || nearFocus>=farFocus || sourceCanvas == null) {
				this.dispatchEvent(new RenderEvent(RenderEvent.RENDER_ERROR));
			} else {
				try {
					sourceCanvas.width;
					var temp:BitmapData = sourceCanvas;
					sourceCanvas = temp.clone();
					for (var i:int = 0; i<_repeatCount; i++) {
						_render(buffer);
					}
					output.draw(sourceCanvas, _matrix, null, null, null, true);
					sourceCanvas.dispose();
					sourceCanvas = temp;
					this.dispatchEvent(new RenderEvent(RenderEvent.RENDER_COMPLETE));
				} catch (e:Error) {
					this.dispatchEvent(new RenderEvent(RenderEvent.RENDER_ERROR));
				}
			}
		}
		private function _render(buffer:ZBuffer):void {
			var source:BitmapData = new BitmapData(_width/_kx, _height/_ky, true, 0x0);
			var infoList:Array = buffer.ZBufferList;
			var refreshCount:int = buffer.refreshCount;
			var depth:Number;
			var color:uint;
			var blurFactor:Number;
			var dis:Number = farFocus-nearFocus;
			var a:Number;
			var r:Number;
			var g:Number;
			var b:Number;
			var k:Number;
			var k1:Number;
			var k2:Number;
			var w:int = _width/_kx;
			var h:int = _height/_ky;
			for (var x:int = 0; x<w; x++) {
				for (var y:int = 0; y<h; y++) {
					var info:PixelInfo = infoList[x*ZBUFFER_COEFFICIENT+y];
					if (info == null) {
						depth = MAX_FAR;
					} else {
						if (info.useOpaqueColor) {
							if (info.alphaColorList == null) {
								depth = info.opaqueColorDepth;
							} else {
								depth = info.alphaColorList[1];
							}
						} else {
							depth = info.alphaColorList[1];
						}
					}
					depth -= nearFocus;
					if (depth<0) depth *= -1;
					blurFactor = depth/dis;
					if (blurFactor>1) blurFactor = 1;
					k1 = 1-blurFactor*blurFactor;
					if (k1<K1) k1 = K1;
					k2 = 1-k1;
					k = k2*K2;
					color = sourceCanvas.getPixel32(x-1, y-1);
					a = (color>>24&0xFF)*k;
					r = (color>>16&0xFF)*k;
					g = (color>>8&0xFF)*k;
					b = (color&0xFF)*k;
					color = sourceCanvas.getPixel32(x-1, y+1);
					a += (color>>24&0xFF)*k;
					r += (color>>16&0xFF)*k;
					g += (color>>8&0xFF)*k;
					b += (color&0xFF)*k;
					color = sourceCanvas.getPixel32(x+1, y-1);
					a += (color>>24&0xFF)*k;
					r += (color>>16&0xFF)*k;
					g += (color>>8&0xFF)*k;
					b += (color&0xFF)*k;
					color = sourceCanvas.getPixel32(x+1, y+1);
					a += (color>>24&0xFF)*k;
					r += (color>>16&0xFF)*k;
					g += (color>>8&0xFF)*k;
					b += (color&0xFF)*k;
					k = k2*K3;
					color = sourceCanvas.getPixel32(x-1, y);
					a += (color>>24&0xFF)*k;
					r += (color>>16&0xFF)*k;
					g += (color>>8&0xFF)*k;
					b += (color&0xFF)*k;
					color = sourceCanvas.getPixel32(x+1, y);
					a += (color>>24&0xFF)*k;
					r += (color>>16&0xFF)*k;
					g += (color>>8&0xFF)*k;
					b += (color&0xFF)*k;
					color = sourceCanvas.getPixel32(x, y-1);
					a += (color>>24&0xFF)*k;
					r += (color>>16&0xFF)*k;
					g += (color>>8&0xFF)*k;
					b += (color&0xFF)*k;
					color = sourceCanvas.getPixel32(x, y+1);
					a += (color>>24&0xFF)*k;
					r += (color>>16&0xFF)*k;
					g += (color>>8&0xFF)*k;
					b += (color&0xFF)*k;
					k = k1;
					color = sourceCanvas.getPixel32(x, y);
					a += (color>>24&0xFF)*k;
					r += (color>>16&0xFF)*k;
					g += (color>>8&0xFF)*k;
					b += (color&0xFF)*k;
					source.setPixel32(x, y, a<<24|r<<16|g<<8|b);
				}
			}
			sourceCanvas.dispose();
			sourceCanvas = source;
		}
	}
}