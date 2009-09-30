package asgl.shadows {
	import asgl.buffer.ZBuffer;
	import asgl.cameras.Camera3D;
	import asgl.data.info.PixelInfo;
	import asgl.drivers.AbstractRenderDriver;
	import asgl.math.GLMatrix3D;
	import asgl.math.Vertex3D;
	
	/**
	 * ShadowMap.
	 * <p>use with RasterizationRenderer</p>
	 * every render need a ZBuffer,if the location of camera and mesh changed,need a new ZBuffer.
	 * depthBuffer is FSAA.normal of ZBuffer.
	 */
	public class ShadowMap extends AbstractShadow {
		private static const ZBUFFER_COEFFICIENT:int = ZBuffer.COEFFICIENT;
		public var lightCameraUsePerspective:Boolean = false;
		public var lightCamera:Camera3D;
		public var screenZOffset:Number = 0;
		public var depthBuffer:ZBuffer;
		private var _ZBufferList:Array;
		private var _lightCameraUsePerspective:Boolean;
		private var _refreshCount:int;
		private var _cameraWorldMatrix:GLMatrix3D;
		private var _lightCameraScreenMatrix:GLMatrix3D;
		private var _halfHeight1:Number;
		private var _halfHeight2:Number;
		private var _halfWidth1:Number;
		private var _halfWidth2:Number;
		private var _nearClipDistance:Number;
		public override function complete():void {
			_ZBufferList = null;
			_cameraWorldMatrix = null;
			_lightCameraScreenMatrix = null;
		}
		public override function destroy():void {
			super.destroy();
			lightCamera = null;
			depthBuffer = null;
			_cameraWorldMatrix = null;
			_lightCameraScreenMatrix = null;
		}
		public override function init(driver:AbstractRenderDriver):void {
			var camera:Camera3D = driver.camera;
			_cameraWorldMatrix = camera.worldMatrix;
			_halfHeight1 = camera.height/2;
			_halfWidth1 = camera.width/2;
			if (lightCamera != null) {
				_lightCameraScreenMatrix = lightCamera.screenMatrix;
				if (lightCameraUsePerspective) {
					_nearClipDistance = lightCamera.nearClipDistance;
					_halfHeight2 = lightCamera.height/2;
					_halfWidth2 = lightCamera.width/2;
				}
			}
			if (depthBuffer != null) {
				_ZBufferList = depthBuffer.ZBufferList;
				_refreshCount = depthBuffer.refreshCount;
			}
		}
		public override function shadowTest(pixelScreenVertex:Vertex3D):void {
			var x:Number = pixelScreenVertex.screenX-_halfWidth1;
			var y:Number = pixelScreenVertex.screenY+_halfHeight1;
			var z:Number = pixelScreenVertex.screenZ+screenZOffset;
			var wx:Number = _cameraWorldMatrix.a*x+_cameraWorldMatrix.b*y+_cameraWorldMatrix.c*z+_cameraWorldMatrix.tx;
			var wy:Number = _cameraWorldMatrix.d*x+_cameraWorldMatrix.e*y+_cameraWorldMatrix.f*z+_cameraWorldMatrix.ty;
			var wz:Number = _cameraWorldMatrix.g*x+_cameraWorldMatrix.h*y+_cameraWorldMatrix.i*z+_cameraWorldMatrix.tz;
			var sx:Number = wx*_lightCameraScreenMatrix.a+wy*_lightCameraScreenMatrix.b+wz*_lightCameraScreenMatrix.c+_lightCameraScreenMatrix.tx;
			var sy:Number = wx*_lightCameraScreenMatrix.d+wy*_lightCameraScreenMatrix.e+wz*_lightCameraScreenMatrix.f+_lightCameraScreenMatrix.ty;
			var sz:Number = wx*_lightCameraScreenMatrix.g+wy*_lightCameraScreenMatrix.h+wz*_lightCameraScreenMatrix.i+_lightCameraScreenMatrix.tz;
			if (lightCameraUsePerspective) {
				var k:Number = _nearClipDistance/sz;
				sx = k*(sx-_halfWidth2)+_halfWidth2;
				sy = k*(sy+_halfHeight2)-_halfHeight2;
			}
			var info:PixelInfo = _ZBufferList[int(sx)*ZBUFFER_COEFFICIENT-int(sy)];
			if (info == null || info.refreshCount != _refreshCount) {
				light.hasShadow = false;
			} else {
				var list:Array;
				var length:int;
				var i:int;
				var color:uint;
				var a:Number;
				if (info.useOpaqueColor) {
					if (sz>info.opaqueColorDepth) {
						light.hasShadow = true;
						redRatio = 1;
						greenRatio = 1;
						blueRatio = 1;
					} else {
						light.hasShadow = false;
						if (info.alphaColorList != null) {
							list = info.alphaColorList;
							length = list.length;
							alphaRatio = 0;
							redRatio = 0;
							greenRatio = 0;
							blueRatio = 0;
							for (i = 1; i<length; i+=2) {
								if (sz>list[i]) {
									light.hasShadow = true;
									color = list[i-1];
									a = (color>>24&0xFF)/255;
									alphaRatio += a;
									redRatio += a*(color>>16&0xFF)/255;
									greenRatio += a*(color>>8&0xFF)/255;
									blueRatio += a*(color&0xFF)/255;
								} else {
									break;
								}
							}
						}
					}
				} else {
					light.hasShadow = false;
					list = info.alphaColorList;
					length = list.length;
					alphaRatio = 0;
					redRatio = 0;
					greenRatio = 0;
					blueRatio = 0;
					for (i = 1; i<length; i+=2) {
						if (sz>list[i]) {
							light.hasShadow = true;
							color = list[i-1];
							a = (color>>24&0xFF)/255;
							alphaRatio += a;
							redRatio += a*(color>>16&0xFF)/255;
							greenRatio += a*(color>>8&0xFF)/255;
							blueRatio += a*(color&0xFF)/255;
						} else {
							break;
						}
					}
				}
			}
		}
	}
}