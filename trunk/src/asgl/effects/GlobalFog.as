package asgl.effects {
	import asgl.buffer.ZBuffer;
	import asgl.data.info.PixelInfo;
	import asgl.events.RenderEvent;
	import asgl.math.Color;
	
	import flash.display.BitmapData;
	
	public class GlobalFog extends AbstractEffect {
		private static const ZBUFFER_COEFFICIENT:int = ZBuffer.COEFFICIENT;
		private static const MAX_Z:Number = Number.POSITIVE_INFINITY;
		public var startZ:Number;
		private var _alpha:int;
		private var _concentrationRratio:Number;
		private var _startConcentration:Number;
		private var _fogColor:uint;
		private var _maxColor:uint;
		private var _rgb:uint;
		public function GlobalFog(width:uint, height:uint, fogColor:uint, startZ:Number, startConcentration:Number, concentrationRratio:Number):void {
			super(width, height);
			this.fogColor = fogColor;
			this.startZ = startZ;
			this.startConcentration = startConcentration;
			this.concentrationRratio = concentrationRratio;
		}
		public function get concentrationRratio():Number {
			return _concentrationRratio;
		}
		public function set concentrationRratio(value:Number):void {
			_concentrationRratio = value;
			_setMaxColor();
		}
		public function get fogColor():uint {
			return _fogColor;
		}
		public function set fogColor(value:uint):void {
			_fogColor = value;
			_alpha = _fogColor>>24&0xFF;
			_rgb = _fogColor&0xFFFFFF;
			_setMaxColor();
		}
		public function get startConcentration():Number {
			return _startConcentration;
		}
		/**
		 * 0-1.
		 */
		public function set startConcentration(value:Number):void {
			if (value<0) {
				value = 0;
			} else if (value>1) {
				value = 1;
			}
			_startConcentration = value;
			_setMaxColor();
		}
		public override function render(buffer:ZBuffer):void {
			_view.reset(_width/_kx, _height/_ky, backgroundColor);
			var output:BitmapData = _view.canvas as BitmapData;
			if (buffer == null || _alpha == 0 || (_startConcentration == 0 && concentrationRratio<=0)) {
				this.dispatchEvent(new RenderEvent(RenderEvent.RENDER_ERROR));
			} else {
				var source:BitmapData = new BitmapData(_width/_kx, _height/_ky, true, 0x0);
				var concentration:Number;
				depthBuffer = buffer.clone(buffer.refreshCount);
				var list:Array = depthBuffer.ZBufferList;
				var length:uint = list.length;
				var depth:Number;
				var num:int;
				var colorList:Array;
				var j:int;
				var w:int = _width/_kx;
				var h:int = _height/_ky;
				for (var x:int = 0; x<w; x++) {
					for (var y:int = 0; y<h; y++) {
						var key:int = x*ZBUFFER_COEFFICIENT+y;
						var info:PixelInfo = list[key];
						if (info == null) {
							info = new PixelInfo(x, y);
							list[key] = info;
							info.useOpaqueColor = false;
							info.alphaColorList = [_maxColor, MAX_Z];
							source.setPixel32(x, y, _maxColor);
						} else {
							if (info.alphaColorList == null) {
								if (info.opaqueColorDepth>=startZ) {
									concentration = _startConcentration+(info.opaqueColorDepth-startZ)*concentrationRratio;
									if (concentration<=0) {
										source.setPixel32(x, y, info.opaqueColor);
									} else {
										if (concentration>1) concentration = 1;
										info.alphaColorList = [_alpha*concentration<<24|_rgb, info.opaqueColorDepth];
										source.setPixel32(x, y, Color.colorBlendWithPixelAlphaColorAndOpaqueColor(info));
									}
								} else {
									source.setPixel32(x, y, info.opaqueColor);
								}
							} else {
								colorList = info.alphaColorList;
								num = colorList.length;
								for (j = 1; j<num; j+=2) {
									depth = colorList[j];
									if (depth>=startZ) {
										concentration = _startConcentration+(info.opaqueColorDepth-startZ)*concentrationRratio;
										if (concentration<=0) continue;
										if (concentration>1) concentration = 1;
										info.useOpaqueColor = false;
										colorList.splice(j, 0, _alpha*concentration<<24|_rgb, depth);
										break;
									}
								}
								if (info.useOpaqueColor) {
									source.setPixel32(x, y, Color.colorBlendWithPixelAlphaColorAndOpaqueColor(info));
								} else {
									source.setPixel32(x, y, Color.colorBlendWithPixelAlphaColor(info));
								}
							}
						}
					}
				}
				output.draw(source, _matrix, null, null, null, true);
				source.dispose();
				this.dispatchEvent(new RenderEvent(RenderEvent.RENDER_COMPLETE));
			}
		}
		private function _setMaxColor():void {
			var concentration:Number = _startConcentration+(MAX_Z)*concentrationRratio;
			if (concentration<=0) {
				concentration = 0;
			} else if (concentration>1) {
				concentration = 1;
			}
			_maxColor = _alpha*concentration<<24|_rgb;
		}
	}
}