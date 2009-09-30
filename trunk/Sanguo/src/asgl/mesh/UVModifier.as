package asgl.mesh {
	import __AS3__.vec.Vector;
	
	import asgl.math.UV;
	
	import flash.geom.Rectangle;
	
	public class UVModifier {
		public var uvs:Vector.<UV>;
		public function UVModifier(uvs:Vector.<UV>=null):void {
			this.uvs = uvs;
		}
		public function transformToGlobal(textureWidth:uint, textureHeight:uint, regionalRect:Rectangle):void {
			if (uvs == null || regionalRect == null) return;
			var startX:Number = regionalRect.x;
			var startY:Number = regionalRect.y;
			if (startX<0) startX = 0;
			if (startY<0) startY = 0;
			var rectW:Number = regionalRect.width;
			var rectH:Number = regionalRect.height;
			var absRectW:Number = rectW<0 ? -rectW : rectW;
			var absRectH:Number = rectH<0 ? -rectH : rectH;
			if (textureWidth<absRectW) textureWidth = absRectW+(absRectW%1 == 0 ? 0 : 1);
			if (textureHeight<absRectH) textureHeight = absRectH+(absRectH%1 == 0 ? 0 : 1);
			var length:uint = uvs.length;
			for (var i:uint = 0; i<length; i++) {
				var uv:UV = uvs[i];
				uv.u = (textureWidth*uv.u-startX)/rectW;
				uv.v = (textureHeight*uv.v-startY)/rectH;
			}
		}
		public function transformToRegional(textureWidth:uint, textureHeight:uint, regionalRect:Rectangle):void {
			if (uvs == null || regionalRect == null) return;
			var startX:Number = regionalRect.x;
			var startY:Number = regionalRect.y;
			if (startX<0) startX = 0;
			if (startY<0) startY = 0;
			var rectW:Number = regionalRect.width;
			var rectH:Number = regionalRect.height;
			var absRectW:Number = rectW<0 ? -rectW : rectW;
			var absRectH:Number = rectH<0 ? -rectH : rectH;
			if (textureWidth<absRectW) textureWidth = absRectW+(absRectW%1 == 0 ? 0 : 1);
			if (textureHeight<absRectH) textureHeight = absRectH+(absRectH%1 == 0 ? 0 : 1);
			var length:uint = uvs.length;
			for (var i:uint = 0; i<length; i++) {
				var uv:UV = uvs[i];
				uv.u = (startX+rectW*uv.u)/textureWidth;
				uv.v = (startY+rectH*uv.v)/textureHeight;
			}
		}
	}
}