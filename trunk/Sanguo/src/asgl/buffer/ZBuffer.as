package asgl.buffer {
	import asgl.data.info.PixelInfo;
	import asgl.math.Color;
	
	import flash.display.BitmapData;
	
	public class ZBuffer {
		public static const COEFFICIENT:int = 10000;
		private static const POSITIVE_INFINITY:Number = Number.POSITIVE_INFINITY;
		private static const NEGATIVE_INFINITY:Number = Number.NEGATIVE_INFINITY;
		/**
		 * [read only]
		 */
		public var ZBufferList:Array = [];
		public var refreshCount:int = 0;
		public function alphaAttenuation(attenuation:Number, refreshCount:int):void {
			if (attenuation == 0) {
				return;
			} else {
				if (attenuation>1) {
					attenuation = 1;
				} else if (attenuation<0) {
					return;
				}
				attenuation *= 255;
				var alpha:int;
				var opaqueAlpha:int;
				var color:uint;
				var length:int;
				var list:Array;
				var i:int;
				var opaqueColor:uint;
				for (var key:* in ZBufferList) {
					var info:PixelInfo = ZBufferList[key];
					if (info.refreshCount == refreshCount) {
						if (info.useOpaqueColor) {
							opaqueColor = info.opaqueColor;
							opaqueAlpha = (opaqueColor>>24&0xFF)-attenuation;
						}
						if (info.alphaColorList == null) {
							if (info.useOpaqueColor) {
								if (opaqueAlpha>0) {
									info.alphaColorList = [opaqueAlpha<<24|(opaqueColor&0xFFFFFF), info.opaqueColorDepth];
								} else {
									info.alphaColorList = null;
									info.refreshCount--;
								}
							}
						} else {
							list = info.alphaColorList;
							length = list.length;
							for (i = 0; i<length; i+=2) {
								color = list[i];
								alpha = (color>>24&0xFF)-attenuation;
								if (alpha>0) {
									list[i] = alpha<<24|(color&0xFFFFFF);
								} else {
									list.splice(i, 2);
									length -= 2;
									i -= 2;
								}
							}
							if (info.useOpaqueColor) {
								if (opaqueAlpha>0) {
									list.push(opaqueAlpha<<24|(opaqueColor&0xFFFFFF), info.opaqueColorDepth);
								} else if (length == 0) {
									info.alphaColorList = null;
									info.refreshCount--;
								}
							} else if (length == 0) {
								info.alphaColorList = null;
								info.refreshCount--;
							}
						}
						info.useOpaqueColor = false;
					}
				}
			}
		}
		public function clone(refreshCount:int):ZBuffer {
			var cloneZBuffer:ZBuffer = new ZBuffer();
			cloneZBuffer.refreshCount = refreshCount;
			var cloneList:Array = cloneZBuffer.ZBufferList;
			for (var key:* in ZBufferList) {
				var info:PixelInfo = ZBufferList[key];
				if (info.refreshCount == refreshCount) cloneList[key] = info.clone();
			}
			return cloneZBuffer;
		}
		public function cloneAll():ZBuffer {
			var cloneZBuffer:ZBuffer = new ZBuffer();
			cloneZBuffer.refreshCount = refreshCount;
			var cloneList:Array = cloneZBuffer.ZBufferList;
			for (var key:* in ZBufferList) {
				cloneList[key] = ZBufferList[key].clone();
			}
			return cloneZBuffer;
		}
		public function cloneByRefreshCount(refreshCount:int):ZBuffer {
			var cloneZBuffer:ZBuffer = new ZBuffer();
			cloneZBuffer.refreshCount = refreshCount;
			var list:Array = cloneZBuffer.ZBufferList;
			for (var key:* in ZBufferList) {
				var pixelInfo:PixelInfo = ZBufferList[key];
				if (pixelInfo.refreshCount == refreshCount) list[key] = pixelInfo.clone();
			}
			return cloneZBuffer;
		}
		public function concat(buffer:ZBuffer, refreshCount:int):void {
			var list:Array;
			var alphaColorList:Array;
			var length:int;
			var i:int;
			var j:int;
			var max:int;
			var depth:Number;
			var bufferList:Array = buffer.ZBufferList;
			for (var key:* in bufferList) {
				var pixelInfo:PixelInfo = bufferList[key];
				if (pixelInfo.refreshCount == refreshCount) {
					var k:int = pixelInfo.x*COEFFICIENT+pixelInfo.y;
					var info:PixelInfo = ZBufferList[k];
					if (info == null || info.refreshCount != this.refreshCount) {
						info = pixelInfo.clone();
						info.refreshCount = this.refreshCount;
						ZBufferList[k] = info;
					} else {
						list = pixelInfo.alphaColorList;
						if (info.alphaColorList == null) {
							if (list != null) info.alphaColorList = list.concat();
						} else if (list != null) {
							j = 1;
							alphaColorList = info.alphaColorList;
							max = alphaColorList.length;
							length = list.length;
							for (i = 1; i<length; i+=2) {
								depth = list[i];
								if (depth<alphaColorList[1]) {
									alphaColorList.splice(0, 0, list[i-1], depth);
									j += 2;
									max += 2;
								} else if (depth>alphaColorList[max-1]) {
									alphaColorList.push(list[i-1], depth);
									max += 2;
								} else {
									for (; j<max; j+=2) {
										if (depth<alphaColorList[j]) {
											alphaColorList.splice(j-1, 0, list[i-1], depth);
											max += 2;
											break;
										}
									}
								}
							}
						}
						if (info.useOpaqueColor) {
							if (pixelInfo.useOpaqueColor && pixelInfo.opaqueColorDepth<info.opaqueColorDepth) {
								info.opaqueColor = pixelInfo.opaqueColor;
								info.opaqueColorDepth = pixelInfo.opaqueColorDepth;
							}
						} else if (pixelInfo.useOpaqueColor) {
							info.useOpaqueColor = true;
							info.opaqueColor = pixelInfo.opaqueColor;
							info.opaqueColorDepth = pixelInfo.opaqueColorDepth;
						}
						if (info.alphaColorList != null && info.useOpaqueColor) {
							list = info.alphaColorList;
							length = list.length;
							depth = info.opaqueColorDepth;
							if (depth<=list[1]) {
								info.alphaColorList = null;
							} else if (depth>list[length-1]) {
								continue;
							} else if (depth<list[length-1]) {
								for (i = length-3; i>=1; i-=2) {
									if (depth>list[i]) {
										list.splice(i+1, length-i-1);
										break;
									}
								}
							}
						}
					}
				}
			}
		}
		public function createOpaqueDepthMap(width:uint, height:uint, refreshCount:int):BitmapData {
			if (ZBufferList == null) return null;
			if (width<1) width = 1;
			if (height<1) height = 1;
			var info:PixelInfo;
			var minZ:Number = POSITIVE_INFINITY;
			var maxZ:Number = NEGATIVE_INFINITY;
			var depth:Number;
			for each (info in ZBufferList) {
				if (info != null && info.refreshCount == refreshCount && info.useOpaqueColor) {
					depth = info.opaqueColorDepth;
					if (minZ>depth) minZ = depth;
					if (maxZ<depth) maxZ = depth;
				}
			}
			var image:BitmapData = new BitmapData(width, height, false, 0x00);
			if (minZ == POSITIVE_INFINITY) return image;
			var distance:Number = maxZ-minZ;
			for (var y:int = 0; y<height; y++) {
				for (var x:int = 0; x<width; x++) {
					info = ZBufferList[x*COEFFICIENT+y];
					if (info != null && info.refreshCount == refreshCount && info.useOpaqueColor) {
						var c:int = 255*(maxZ-info.opaqueColorDepth)/distance;
						image.setPixel(x, y, c<<16|c<<8|c);
					}
				}
			}
			return image;
		}
		public function getPixelInfo(h:uint, v:uint):PixelInfo {
			var key:int = h*COEFFICIENT+v;
			var info:PixelInfo = ZBufferList[key];
			if (info == null) {
				info = new PixelInfo(h, v);
				ZBufferList[key] = info;
			}
			return info;
		}
		public function render(width:uint, height:uint, refreshCount:int, backgroundColor:uint=0):BitmapData {
			if (width<1) width = 1;
			if (height<1) height = 1;
			var output:BitmapData = new BitmapData(width, height, true, backgroundColor);
			for (var key:* in ZBufferList) {
				var pixelInfo:PixelInfo = ZBufferList[key];
				if (pixelInfo.refreshCount == refreshCount) {
					if (pixelInfo.alphaColorList == null) {
						if (pixelInfo.useOpaqueColor) output.setPixel32(pixelInfo.x, pixelInfo.y, pixelInfo.opaqueColor);
					} else if (pixelInfo.useOpaqueColor) {
						output.setPixel32(pixelInfo.x, pixelInfo.y, Color.colorBlendWithPixelAlphaColorAndOpaqueColor(pixelInfo));
					} else {
						output.setPixel32(pixelInfo.x, pixelInfo.y, Color.colorBlendWithPixelAlphaColor(pixelInfo));
					}
				}
			}
			return output;
		}
		public function setSize(width:uint, height:uint):void {
			for (var w:int = 0; w<width; w++) {
				var head:int = w*COEFFICIENT;
				for (var h:int = 0; h<height; h++) {
					var key:int = head+h;
					if (ZBufferList[key] == null) ZBufferList[key] = new PixelInfo(w, h);
				}
			}
		}
	}
}