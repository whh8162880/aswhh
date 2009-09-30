package asgl.renderers {
	import __AS3__.vec.Vector;
	
	import asgl.buffer.ZBuffer;
	import asgl.cameras.Camera3D;
	import asgl.data.info.PixelInfo;
	import asgl.drivers.AbstractRenderDriver;
	import asgl.drivers.ProjectionType;
	import asgl.math.Color;
	import asgl.math.Vertex3D;
	import asgl.mesh.FaceType;
	import asgl.mesh.TriangleFace;
	import asgl.views.BitmapDataView;
	import asgl.views.IView;
	import asgl.views.ViewType;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * VertexRenderer.
	 * <p>Support:</p>
	 * <p>ZBuffer.</p>
	 * <p>face:ShapeFace.</p>
	 */
	public class VertexRenderer implements IRenderer {
		private static const ZBUFFER_COEFFICIENT:int = ZBuffer.COEFFICIENT;
		public var vertices:Vector.<Vertex3D>;
		public var depthBuffer:ZBuffer;
		private var _defaultView:BitmapDataView = new BitmapDataView();
		public function VertexRenderer(depthBuffer:ZBuffer=null, vertices:Vector.<Vertex3D>=null):void {
			this.depthBuffer = depthBuffer;
			this.vertices = vertices;
		}
		public function get facesType():String {
			return FaceType.SHAPE_FACE;
		}
		public function destroy():void {
			depthBuffer = null;
			vertices = null;
			_defaultView.destroy();
		}
		public function render(driver:AbstractRenderDriver, faces:Vector.<TriangleFace>, completeFunction:Function):void {
			var camera:Camera3D = driver.camera;
			var width:Number = camera.width;
			var height:Number = camera.height;
			
			var view:IView = driver.view;
			var viewType:String = view.viewType;
			var output:BitmapData;
			var isBitmapData:Boolean = viewType == ViewType.BITMAPDATA;
			if (isBitmapData) {
				output = view.canvas as BitmapData;
			} else {
				_defaultView.reset(width, height);
				output = _defaultView.canvas as BitmapData;
			}
			output.lock();
			
			if (vertices == null) {
				_vertexListModeRender(driver, output);
			} else {
				_faceModeRender(driver, output, faces);
			}
			output.unlock();
			
			if (!isBitmapData) {
				var graphics:Graphics;
				if (viewType == ViewType.SHAPE) {
					graphics = (view.canvas as Shape).graphics;
				} else if (viewType == ViewType.SPRITE) {
					graphics = (view.canvas as Sprite).graphics;
				}
				if (graphics != null) {
					graphics.beginBitmapFill(output);
					graphics.drawRect(0, 0, width, height);
				}
			}
			completeFunction();
		}
		private function _faceModeRender(driver:AbstractRenderDriver, output:BitmapData, faces:Vector.<TriangleFace>):void {
			if (depthBuffer == null) depthBuffer = new ZBuffer();
			depthBuffer.refreshCount++;
			var refreshCount:Number = depthBuffer.refreshCount;
			var ZBufferList:Array = depthBuffer.ZBufferList;
			var isPerspective:Boolean = driver.projectionType == ProjectionType.PERSPECTIVE;
			var width:int = output.width-1;
			var height:int = 1-output.height;
			var j:int;
			var vertex:Vertex3D;
			var length:int = faces.length;
			for (var i:int = 0; i<length; i++) {
				var face:TriangleFace = faces[i];
				var color:uint = face.color;
				var alpha:int = color>>24&0xFF;
				if (alpha == 0) continue;
				for (j = 0; j<3; j++) {
					if (j == 0) {
						vertex = face.vertex0;
					} else if (j == 1) {
						vertex = face.vertex1;
					} else {
						vertex = face.vertex2;
					}
					var x:int;
					var y:int;
					if (isPerspective) {
						x = vertex.cameraX;
						y = vertex.cameraY;
					} else {
						x = vertex.screenX;
						y = vertex.screenY;
					}
					if (x<0 || x>width || y>0 || y<height) continue;
					var depth:Number = vertex.screenZ;
					var key:int = x*ZBUFFER_COEFFICIENT-y;
					var info:PixelInfo = ZBufferList[key];
					if (info == null) {
						info = new PixelInfo(x, -y);
						ZBufferList[key] = info;
					}
					if (info.refreshCount == refreshCount) {
						if (alpha == 255) {
							if (info.alphaColorList == null) {
								if (depth<info.opaqueColorDepth) {
									info.opaqueColor = color;
									info.opaqueColorDepth = depth;	
									output.setPixel32(x, -y, color);
								}
							} else if (depth<info.alphaColorList[1]) {
								info.alphaColorList = null;
								info.opaqueColor = color;
								info.opaqueColorDepth = depth;
								info.useOpaqueColor = true;
								output.setPixel32(x, -y, color);
							} else if (!info.useOpaqueColor || depth<info.opaqueColorDepth) {
								info.opaqueColor = color;
								info.opaqueColorDepth = depth;
								info.useOpaqueColor = true;
								var list:Array = info.alphaColorList;
								var lightLength:int = list.length;
								if (depth<list[lightLength-1]) {
									for (var n:int = lightLength-3; n>=1; n-=2) {
										if (depth>=list[n]) {
											list.splice(n+2, lightLength-n-1);
											break;
										}
									}
								}
								output.setPixel32(x, -y, Color.colorBlendWithPixelAlphaColorAndOpaqueColor(info));
							}
						} else {
							if (!info.useOpaqueColor) {
								PixelInfo.alphaColorSort(info, color, depth);
								output.setPixel32(x, -y, Color.colorBlendWithPixelAlphaColor(info));
							} else if (depth<=info.opaqueColorDepth) {
								if (info.alphaColorList == null) {
									info.alphaColorList = [color, depth];
								} else {
									PixelInfo.alphaColorSort(info, color, depth);
								}
								output.setPixel32(x, -y, Color.colorBlendWithPixelAlphaColorAndOpaqueColor(info));
							}
						}
					} else {
						if (alpha == 255) {
							info.opaqueColor = color;
							info.opaqueColorDepth = depth;
							info.alphaColorList = null;
							info.useOpaqueColor = true;
						} else {
							info.alphaColorList = [color, depth];
							info.useOpaqueColor = false;
						}
						
						output.setPixel32(x, -y, color);
						info.refreshCount = refreshCount;
					}
				}
			}	
		}
		private function _vertexListModeRender(driver:AbstractRenderDriver, output:BitmapData):void {
			if (depthBuffer == null) depthBuffer = new ZBuffer();
			depthBuffer.refreshCount++;
			var refreshCount:Number = depthBuffer.refreshCount;
			var ZBufferList:Array = depthBuffer.ZBufferList;
			var isPerspective:Boolean = driver.projectionType == ProjectionType.PERSPECTIVE;
			var width:Number = output.width-1;
			var height:Number = 1-output.height;
			var vertexArray:Vector.<Vertex3D> = vertices;
			if (vertexArray == null) vertexArray = new Vector.<Vertex3D>();
			var color:uint;
			var alpha:int;
			var x:int;
			var y:int;
			var depth:Number;
			var key:int;
			var info:PixelInfo;
			var length:int = vertexArray.length;
			for (var i:int = 0; i<length; i++) {
				var vertex:Vertex3D = vertexArray[i];
				if (vertex == null) continue;
				color = vertex.color;
				alpha = color>>24&0xFF;
				if (alpha == 0) continue;
				if (isPerspective) {
					x = vertex.cameraX;
					y = vertex.cameraY;
				} else {
					x = vertex.screenX;
					y = vertex.screenY;
				}
				if (x<0 || x>width || y>0 || y<height) continue;
				depth = vertex.screenZ;
				key = x*ZBUFFER_COEFFICIENT-y;
				info = ZBufferList[key];
				if (info == null) {
					info = new PixelInfo(x, -y);
					ZBufferList[key] = info;
				}
				if (info.refreshCount == refreshCount) {
					if (alpha == 255) {
						if (info.alphaColorList == null) {
							if (depth<info.opaqueColorDepth) {
								info.opaqueColor = color;
								info.opaqueColorDepth = depth;	
								output.setPixel32(x, -y, color);
							}
						} else if (depth<info.alphaColorList[1]) {
							info.alphaColorList = null;
							info.opaqueColor = color;
							info.opaqueColorDepth = depth;
							info.useOpaqueColor = true;
							output.setPixel32(x, -y, color);
						} else if (!info.useOpaqueColor || depth<info.opaqueColorDepth) {
							info.opaqueColor = color;
							info.opaqueColorDepth = depth;
							info.useOpaqueColor = true;
							var list:Array = info.alphaColorList;
							var lightLength:int = list.length;
							if (depth<list[lightLength-1]) {
								for (var n:int = lightLength-3; n>=1; n-=2) {
									if (depth>=list[n]) {
										list.splice(n+1, lightLength-n-1);
										break;
									}
								}
							}
							output.setPixel32(x, -y, Color.colorBlendWithPixelAlphaColorAndOpaqueColor(info));
						}
					} else {
						if (!info.useOpaqueColor) {
							PixelInfo.alphaColorSort(info, color, depth);
							output.setPixel32(x, -y, Color.colorBlendWithPixelAlphaColor(info));
						} else if (depth<=info.opaqueColorDepth) {
							if (info.alphaColorList == null) {
								info.alphaColorList = [color, depth];
							} else {
								PixelInfo.alphaColorSort(info, color, depth);
							}
							output.setPixel32(x, -y, Color.colorBlendWithPixelAlphaColorAndOpaqueColor(info));
						}
					}
				} else {
					if (alpha == 255) {
						info.opaqueColor = color;
						info.opaqueColorDepth = depth;
						info.alphaColorList = null;
						info.useOpaqueColor = true;
					} else {
						info.alphaColorList = [color, depth];
						info.useOpaqueColor = false;
					}
					
					output.setPixel32(x, -y, color);
					info.refreshCount = refreshCount;
				}
			}
		}
	}
}