package asgl.data.info {
	
	public class PixelInfo {
		/**
		 * unit:color,depth.
		 */
		public var alphaColorList:Array;
		public var useOpaqueColor:Boolean;
		public var opaqueColorDepth:Number;
		public var refreshCount:int = 0;
		public var opaqueColor:uint;
		public var x:int;
		public var y:int;
		public function PixelInfo(x:int, y:int):void {
			this.x = x;
			this.y = y;
		}
		public static function alphaColorSort(pixelInfo:PixelInfo, color:uint, depth:Number):void {
			var list:Array = pixelInfo.alphaColorList;
			var length:int = list.length;
			if (depth>=list[length-1]) {
				list.push(color, depth);
			} else {
				for (var i:int = 1; i<length; i += 2) {
					if (depth<list[i]) {
						list.splice(i-1, 0, color, depth);
						break;
					}
				}
			}
		}
		public function clone():PixelInfo {
			var clonePixelInfo:PixelInfo = new PixelInfo(x, y);
			if (alphaColorList != null) clonePixelInfo.alphaColorList = alphaColorList.concat();
			clonePixelInfo.useOpaqueColor = useOpaqueColor;
			clonePixelInfo.opaqueColorDepth = opaqueColorDepth;
			clonePixelInfo.refreshCount = refreshCount;
			clonePixelInfo.opaqueColor = opaqueColor;
			return clonePixelInfo;
		}
	}
}