package asgl.renderers {
	import __AS3__.vec.Vector;
	
	import asgl.buffer.ZBuffer;
	import asgl.cameras.Camera3D;
	import asgl.data.info.PixelInfo;
	import asgl.drivers.AbstractRenderDriver;
	import asgl.drivers.ProjectionType;
	import asgl.materials.Material;
	import asgl.math.Color;
	import asgl.math.UV;
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
	 * BaseRasterizationRenderer.
	 * <p>Support:</p>
	 * <p>ZBuffer:DynamicZBuffer</p>
	 * <p>face:MaterialFace.</p>
	 * <p>texture:diffuse.</p>
	 * <p>multiRender.</p>
	 * <p>if material of face is null, use color of face shading.
	 * <p>use texture source color.</p>
	 */
	public class BaseRasterizationRenderer implements IRenderer {
		private static const ZBUFFER_COEFFICIENT:int = ZBuffer.COEFFICIENT;
		private static const HALF_PI:Number = Math.PI/2;
		private static const POSITIVE_INFINITY:Number = Number.POSITIVE_INFINITY;
		private static const NEGATIVE_INFINITY:Number = Number.NEGATIVE_INFINITY;
		public var depthBuffer:ZBuffer;
		private var _defaultMaterial:Material = new Material();
		/**
		 * temp
		 */
		private var _tempList:Array;
		private var _tempInt1:int;
		private var _tempInt2:int;
		//
		private var _defaultView:BitmapDataView = new BitmapDataView();
		/**
		 *public
		 */
		private var _isLine:Boolean;
		private var _lineFirstInfinity:Boolean;
		private var _lineSecondInfinity:Boolean;
		private var _alpha:int;
		private var _key:int;
		private var _abs:Number;
		private var _abValue0:Number;
		private var _abValue1:Number;
		private var _acValue0:Number;
		private var _acValue1:Number;
		private var _depth:Number;
		private var _dX:Number;
		private var _dY:Number;
		private var _fndx:Number;
		private var _fndy:Number;
		private var _fndz:Number;
		private var _k:Number;
		private var _kAB:Number;
		private var _kAC:Number;
		private var _lengthAB:Number;
		private var _lengthAC:Number;
		private var _lineFirstB:Number;
		private var _lineFirstConst:Number;
		private var _lineFirstK:Number;
		private var _lineFirstSqrt:Number;
		private var _lineFirstX:Number;
		private var _lineGroup0Value0:Number;
		private var _lineGroup0Value1:Number;
		private var _lineGroup0Value3:Number;
		private var _lineGroup0Value4:Number;
		private var _lineGroup1Value0:Number;
		private var _lineGroup1Value1:Number;
		private var _lineGroup1Value3:Number;
		private var _lineGroup1Value4:Number;
		private var _lineGroup2Value0:Number;
		private var _lineGroup2Value1:Number;
		private var _lineGroup2Value3:Number;
		private var _lineGroup2Value4:Number;
		private var _lineky:Number;
		private var _lineSecondB:Number;
		private var _lineSecondConst:Number;
		private var _lineSecondK:Number;
		private var _lineSecondSqrt:Number;
		private var _lineSecondX:Number;
		private var _lineX:Number;
		private var _newVx0:Number;
		private var _newVy0:Number;
		private var _newVz0:Number;
		private var _newVx1:Number;
		private var _newVy1:Number;
		private var _newVz1:Number;
		private var _pixelScreenX:Number;
		private var _pixelScreenY:Number;
		private var _py:Number;
		private var _sin:Number;
		private var _t:Number;
		private var _textureU:Number;
		private var _textureV:Number;
		private var _u:Number;
		private var _uAB:Number;
		private var _uAC:Number;
		private var _v:Number;
		private var _vAB:Number;
		private var _vAC:Number;
		private var _info:PixelInfo;
		private var _color:uint;
		private var _shadingColor:uint;
		private var _firstUV:UV;
		private var _secondUV:UV;
		private var _lastUV:UV;
		private var _firstVertex:Vertex3D;
		private var _secondVertex:Vertex3D;
		private var _lastVertex:Vertex3D;
		public function BaseRasterizationRenderer(depthBuffer:ZBuffer=null):void {
			this.depthBuffer = depthBuffer;
		}
		public function get facesType():String {
			return FaceType.MATERIAL_FACE;
		}
		public function destroy():void {
			depthBuffer = null;
			_tempList = null;
			_defaultView.destroy();
			_defaultView = null;
		}
		public function render(driver:AbstractRenderDriver, faces:Vector.<TriangleFace>, completeFunction:Function):void {
			var camera:Camera3D = driver.camera;
			var width:Number = camera.width;
			var height:Number = camera.height;
			if (depthBuffer == null) depthBuffer = new ZBuffer();
			depthBuffer.refreshCount++;
			var refreshCount:Number = depthBuffer.refreshCount;
			var ZBufferList:Array = depthBuffer.ZBufferList;
			var perspectiveCoefficient:Number = camera.perspectiveCoefficient;
			var cameraScreenX:Number = camera.screenX;
			var cameraScreenY:Number = camera.screenY;
			var cameraScreenZ:Number = camera.screenZ;
			var isPerspective:Boolean = driver.projectionType == ProjectionType.PERSPECTIVE;
			
			var view:IView = driver.view;
			var viewType:String = view.viewType;
			var isSource:Boolean = viewType == ViewType.BITMAPDATA;
			var sourceBitmapData:BitmapData;
			if (isSource) {
				sourceBitmapData = view.canvas as BitmapData;
			} else {
				_defaultView.reset(width, height);
				sourceBitmapData = _defaultView.canvas as BitmapData;
			}
			sourceBitmapData.lock();
			
			var totalFaces:int = faces.length;
			var i:int;
			for (var ii:int = 0; ii<totalFaces; ii++) {
				var face:TriangleFace = faces[ii];
				var minY:Number = POSITIVE_INFINITY;
				var maxY:Number = NEGATIVE_INFINITY;
				_firstVertex = face.vertex0;
				_secondVertex = face.vertex1;
				_lastVertex = face.vertex2;
				_firstUV = face.uv0;
				_secondUV = face.uv1;
				_lastUV = face.uv2;
				
				var firstX:Number = _firstVertex.screenX;
				var firstY:Number = _firstVertex.screenY;
				var firstZ:Number = _firstVertex.screenZ;
				var secondX:Number = _secondVertex.screenX;
				var secondY:Number = _secondVertex.screenY;
				
				if (isPerspective) {
					_py = _firstVertex.cameraY;
					_lineGroup0Value0 = _firstVertex.cameraX-_secondVertex.cameraX;
					_lineGroup0Value1 = _py-_secondVertex.cameraY;
					_lineGroup0Value3 = _firstVertex.cameraX;
					_lineGroup0Value4 = _py;
					if (minY>_py) minY = _py;
					if (maxY<_py) maxY = _py;
					
					_py = _secondVertex.cameraY;
					_lineGroup1Value0 = _secondVertex.cameraX-_lastVertex.cameraX;
					_lineGroup1Value1 = _py-_lastVertex.cameraY;
					_lineGroup1Value3 = _secondVertex.cameraX;
					_lineGroup1Value4 = _py;
					if (minY>_py) minY = _py;
					if (maxY<_py) maxY = _py;
					
					_py = _lastVertex.cameraY;
					_lineGroup2Value0 = _lastVertex.cameraX-_firstVertex.cameraX;
					_lineGroup2Value1 = _py-_firstVertex.cameraY;
					_lineGroup2Value3 = _lastVertex.cameraX;
					_lineGroup2Value4 = _py;
					if (minY>_py) minY = _py;
					if (maxY<_py) maxY = _py;
				} else {
					_py = firstY;
					_lineGroup0Value0 = firstX-secondX;
					_lineGroup0Value1 = _py-secondY;
					_lineGroup0Value3 = firstX;
					_lineGroup0Value4 = _py;
					if (minY>_py) minY = _py;
					if (maxY<_py) maxY = _py;
					
					_py = secondY;
					_lineGroup1Value0 = secondX-_lastVertex.screenX;
					_lineGroup1Value1 = _py-_lastVertex.screenY;
					_lineGroup1Value3 = secondX;
					_lineGroup1Value4 = _py;
					if (minY>_py) minY = _py;
					if (maxY<_py) maxY = _py;
					
					_py = _lastVertex.screenY;
					_lineGroup2Value0 = _lastVertex.screenX-firstX;
					_lineGroup2Value1 = _py-firstY;
					_lineGroup2Value3 = _lastVertex.screenX;
					_lineGroup2Value4 = _py;
					if (minY>_py) minY = _py;
					if (maxY<_py) maxY = _py;
				}
				
				if (minY>0) {
					continue;
				} else if (minY<-height) {
					minY = -height;
				}
				
				if (maxY<-height) {
					continue;
				} else if (maxY>0) {
					maxY = 0;
				}
				
				var diffuseBitmapData:BitmapData;
				var diffuseTextureHeight:Number;
				var diffuseTextureWidth:Number;
				var material:Material = face.material;
				if (material == null) {
					material = _defaultMaterial;
					material.color = face.color;
				}
				var useColorShading:Boolean = false;
				if (!material.diffuseTextureEnabled){
					_shadingColor = material.color;
					if ((_shadingColor>>24&0xFF) == 0) continue;
					useColorShading = true;
				}
				if (!useColorShading) {
					diffuseBitmapData = material._diffuseBitmapData;
					diffuseTextureHeight = material._diffuseTextureHeight;
					diffuseTextureWidth = material._diffuseTextureWidth;
				}
				
				var lastX:Number = _lastVertex.screenX;
				var lastY:Number = _lastVertex.screenY;
				
				var fsdx:Number = secondX-firstX;
				var fsdy:Number = secondY-firstY;
				var fldx:Number = lastX-firstX;
				var fldy:Number = lastY-firstY;
				var fsdz:Number = _secondVertex.screenZ-firstZ;
				var fldz:Number = _lastVertex.screenZ-firstZ;
				
				var faceVectorX:Number = fsdy*fldz-fsdz*fldy;
				var faceVectorY:Number = fsdz*fldx-fsdx*fldz;
				var faceVectorZ:Number = fsdx*fldy-fsdy*fldx;
				
				_isLine = (firstX == secondX && firstX == lastX) || (firstY == secondY && firstY == lastY);
				
				if (_isLine) {
					if (!isPerspective) continue;
					_newVx0 = fsdy*faceVectorZ-fsdz*faceVectorY;
					_newVy0 = fsdz*faceVectorX-fsdx*faceVectorZ;
					_newVz0 = fsdx*faceVectorY-fsdy*faceVectorX;
					
					_newVx1 = fldz*faceVectorY-fldy*faceVectorZ;
					_newVy1 = fldx*faceVectorZ-fldz*faceVectorX;
					_newVz1 = fldy*faceVectorX-fldx*faceVectorY;
					
					_lengthAB = Math.sqrt(fsdx*fsdx+fsdy*fsdy+fsdz*fsdz);
					_lengthAC = Math.sqrt(fldx*fldx+fldy*fldy+fldz*fldz);
					
					_abValue0 = _newVx0*firstX+_newVy0*firstY+_newVz0*firstZ;
					_abValue1 = _newVx0*fldx+_newVy0*fldy+_newVz0*fldz;
					
					_acValue0 = _newVx1*firstX+_newVy1*firstY+_newVz1*firstZ;
					_acValue1 = _newVx1*fsdx+_newVy1*fsdy+_newVz1*fsdz;
				} else {
					_lineFirstK = fsdy/fsdx;
					_lineFirstInfinity = _lineFirstK == NEGATIVE_INFINITY || _lineFirstK == POSITIVE_INFINITY;
					if (_lineFirstInfinity) {
						_lineFirstX = secondX;
					} else {
						_lineFirstB = firstY-_lineFirstK*firstX;
						_lineFirstSqrt = Math.sqrt(_lineFirstK*_lineFirstK+1);
					}
					
					_lineSecondK = fldy/fldx;
					_lineSecondInfinity = _lineSecondK == NEGATIVE_INFINITY || _lineSecondK == POSITIVE_INFINITY;
					if (_lineSecondInfinity) {
						_lineSecondX = lastX;
					} else {
						_lineSecondB = firstY-_lineSecondK*firstX;
						_lineSecondSqrt = Math.sqrt(_lineSecondK*_lineSecondK+1);
					}
					
					if (_lineFirstInfinity) {
						_sin = Math.sin(HALF_PI-Math.atan2((fldy>=0 ? fldy : -fldy), (fldx>=0 ? fldx : -fldx)));
					} else if (_lineSecondInfinity) {
						_sin = Math.sin(HALF_PI-Math.atan2((fsdy>=0 ? fsdy : -fsdy), (fsdx>=0 ? fsdx : -fsdx)));
					} else {
						_abs = (_lineFirstK-_lineSecondK)/(1+_lineFirstK*_lineSecondK);
						_sin = Math.sin(Math.atan((_abs>=0 ? _abs : -_abs)));
					}
				}
				
				var firstTAU:Number = _firstUV.u;
				var firstTAV:Number = _firstUV.v;
				var fsdu:Number = _secondUV.u-firstTAU;
				var fsdv:Number = _secondUV.v-firstTAV;
				var fldu:Number = _lastUV.u-firstTAU;
				var fldv:Number = _lastUV.v-firstTAV;
				
				var k1:Number = faceVectorX*firstX+faceVectorY*firstY+faceVectorZ*firstZ-faceVectorX*cameraScreenX-faceVectorY*cameraScreenY-faceVectorZ*cameraScreenZ;
				var k2:Number = faceVectorZ*perspectiveCoefficient;
				
				for (var y:int = minY; y<=maxY; y++) {
					var minX:Number = POSITIVE_INFINITY;
					var maxX:Number = NEGATIVE_INFINITY;
					
					if (_lineGroup0Value1 != 0) {
						_lineky = (_lineGroup0Value4-y)/_lineGroup0Value1;
						if (_lineky>=0 && _lineky<=1) {
							_lineX = _lineGroup0Value3-_lineky*_lineGroup0Value0;
							if (minX>_lineX) minX = _lineX;
							if (maxX<_lineX) maxX = _lineX;
						}
					}
					if (_lineGroup1Value1 != 0) {
						_lineky = (_lineGroup1Value4-y)/_lineGroup1Value1;
						if (_lineky>=0 && _lineky<=1) {
							_lineX = _lineGroup1Value3-_lineky*_lineGroup1Value0;
							if (minX>_lineX) minX = _lineX;
							if (maxX<_lineX) maxX = _lineX;
						}
					}
					if (_lineGroup2Value1 != 0) {
						_lineky = (_lineGroup2Value4-y)/_lineGroup2Value1;
						if (_lineky>=0 && _lineky<=1) {
							_lineX = _lineGroup2Value3-_lineky*_lineGroup2Value0;
							if (minX>_lineX) minX = _lineX;
							if (maxX<_lineX) maxX = _lineX;
						}
					}
					
					if (minX>width) {
						continue;
					} else if (minX<0) {
						minX = 0;
					}
					
					if (maxX<0) {
						continue;
					} else if (maxX>width) {
						maxX = width;
					}
					
					for (var x:int = minX; x<=maxX; x++) {
						_key = x*ZBUFFER_COEFFICIENT-y;
						_info = ZBufferList[_key];
						if (_info == null) {
							_info = new PixelInfo(x, -y);
							ZBufferList[_key] = _info;
						}
						
						if (isPerspective) {
							_dX = x-cameraScreenX;
							_dY = y-cameraScreenY;
							_t = k1/(faceVectorX*_dX+faceVectorY*_dY+k2);
							
							_pixelScreenX = cameraScreenX+_t*_dX;
							_pixelScreenY = cameraScreenY+_t*_dY;
							
							_depth = cameraScreenZ+_t*perspectiveCoefficient;
						} else {
							_pixelScreenX = x;
							_pixelScreenY = y;
							
							_depth = (faceVectorX*(firstX-x)+faceVectorY*(firstY-y)+faceVectorZ*firstZ)/faceVectorZ;
						}
						
						if (useColorShading) {
							_color = _shadingColor;
						} else {
							if (_isLine) {
								_t = (_abValue0-_newVx0*_pixelScreenX-_newVy0*_pixelScreenY-_newVz0*_depth)/_abValue1;
								_fndx = fldx*_t+_pixelScreenX-firstX;
								_fndy = fldy*_t+_pixelScreenY-firstY;
								_fndz = fldz*_t+_depth-firstZ;
								_k = Math.sqrt(_fndx*_fndx+_fndy*_fndy+_fndz*_fndz)/_lengthAB;
								_uAB = firstTAU+fsdu*_k;
								_vAB = firstTAV+fsdv*_k;
								
								_t = (_acValue0-_newVx1*_pixelScreenX-_newVy1*_pixelScreenY-_newVz1*_depth)/_acValue1;
								_fndx = fsdx*_t+_pixelScreenX-firstX;
								_fndy = fsdy*_t+_pixelScreenY-firstY;
								_fndz = fsdz*_t+_depth-firstZ;
								_k = Math.sqrt(_fndx*_fndx+_fndy*_fndy+_fndz*_fndz)/_lengthAC;
								_uAC = firstTAU+fldu*_k;
								_vAC = firstTAV+fldv*_k;
								if (fsdu == 0) {
									_textureU = _uAC;
									if (fldv == 0) {
										_textureV = _vAB;
									} else {
										_textureV = (fldv/fldu)*(_textureU-_uAB)+_vAB;
									}
								} else if (fsdv == 0) {
									_textureV = _vAC;
									if (fldu == 0) {
										_textureU = _uAB;
									} else {
										_kAB = fldv/fldu;
										_textureU = (_vAB-_vAC-_kAB*_uAB)/-_kAB;
									}
								} else if (fldu == 0) {
									_textureU = _uAB;
									_textureV = (fsdv/fsdu)*(_textureU-_uAC)+_vAC;
								} else if (fldv == 0) {
									_textureV = _vAB;
									_kAC = fsdv/fsdu;
									_textureU = (_vAB-_vAC+_kAC*_uAC)/_kAC;
								} else {
									_kAB = fldv/fldu;
									_kAC = fsdv/fsdu;
									_textureU = (_vAB-_vAC-_kAB*_uAB+_kAC*_uAC)/(_kAC-_kAB);
									_textureV = _kAB*(_textureU-_uAB)+_vAB;
								}
							} else {
								if (_lineSecondInfinity) {
									_u = (_pixelScreenX>=_lineSecondX ? _pixelScreenX-_lineSecondX : _lineSecondX-_pixelScreenX)/_lineFirstConst;
								} else {
									_abs = _lineSecondK*_pixelScreenX-_pixelScreenY+_lineSecondB;
									_u = ((_abs>=0 ? _abs : -_abs)/_lineSecondSqrt)/_lineFirstConst;
								}
								if (_lineFirstInfinity) {
									_v = (_pixelScreenX>=_lineFirstX ? _pixelScreenX-_lineFirstX : _lineFirstX-_pixelScreenX)/_lineSecondConst;
								} else {
									_abs = _lineFirstK*_pixelScreenX-_pixelScreenY+_lineFirstB;
									_v = ((_abs>=0 ? _abs : -_abs)/_lineFirstSqrt)/_lineSecondConst;
								}
								
								_textureU = firstTAU+_u*fsdu+_v*fldu;
								_textureV = firstTAV+_u*fsdv+_v*fldv;
							}
							
							_color = diffuseBitmapData.getPixel32(diffuseTextureWidth*_textureU, diffuseTextureHeight*_textureV);
						}
						
						_alpha = _color>>24&0xFF;
						if (_alpha == 0) continue;
						
						if (_info.refreshCount == refreshCount) {
							if (_alpha == 255) {
								if (_info.alphaColorList == null) {
									if (_depth<_info.opaqueColorDepth) {
										//No1
										_info.opaqueColor = _color;
										_info.opaqueColorDepth = _depth;
										
										sourceBitmapData.setPixel32(x, -y, _color);
									}
								} else if (_depth<_info.alphaColorList[1]) {
									//No2
									_info.alphaColorList = null;
									_info.opaqueColor = _color;
									_info.opaqueColorDepth = _depth;
									_info.useOpaqueColor = true;
									
									sourceBitmapData.setPixel32(x, -y, _color);
								} else if (!_info.useOpaqueColor || _depth<_info.opaqueColorDepth) {
									//No3
									_info.opaqueColor = _color;
									_info.opaqueColorDepth = _depth;
									_info.useOpaqueColor = true;
									
									_tempList = _info.alphaColorList;
									_tempInt1 = _tempList.length;
									if (_depth<_tempList[_tempInt1-1]) {
										for (_tempInt2 = _tempInt1-3; _tempInt2>=1; _tempInt2-=2) {
											if (_depth>=_tempList[_tempInt2]) {
												_tempList.splice(_tempInt2+1, _tempInt1-_tempInt2-1);
												break;
											}
										}
									}
									sourceBitmapData.setPixel32(x, -y, Color.colorBlendWithPixelAlphaColorAndOpaqueColor(_info));
								} else {
									//trace(info.opaqueColor == MAX_NUMBER);
								}
							} else {
								if (!_info.useOpaqueColor) {
									//No4
									PixelInfo.alphaColorSort(_info, _color, _depth);
									sourceBitmapData.setPixel32(x, -y, Color.colorBlendWithPixelAlphaColor(_info));	
								} else if (_depth<=_info.opaqueColorDepth) {
									//No5	
									if (_info.alphaColorList == null) {
										_info.alphaColorList = [_color, _depth];
									} else {
										PixelInfo.alphaColorSort(_info, _color, _depth);
									}
									sourceBitmapData.setPixel32(x, -y, Color.colorBlendWithPixelAlphaColorAndOpaqueColor(_info));
								}
							}
						} else {
							//No6
							if (_alpha == 255) {
								_info.opaqueColor = _color;
								_info.opaqueColorDepth = _depth;
								_info.alphaColorList = null;
								_info.useOpaqueColor = true;
							} else {
								_info.alphaColorList = [_color, _depth];
								_info.useOpaqueColor = false;
							}
							
							sourceBitmapData.setPixel32(x, -y, _color);
							_info.refreshCount = refreshCount;
						}
					}
				}
			}
			sourceBitmapData.unlock();
			if (!isSource) {
				var graphics:Graphics;
				if (viewType == ViewType.SHAPE) {
					graphics = (view.canvas as Shape).graphics;
				} else if (viewType == ViewType.SPRITE) {
					graphics = (view.canvas as Sprite).graphics;
				}
				if (graphics != null) {
					graphics.beginBitmapFill(sourceBitmapData);
					graphics.drawRect(0, 0, width, height);
				}
			}
			_info = null;
			_tempList = null;
			_firstUV = null;
			_secondUV = null;
			_lastUV = null;
			_firstVertex = null;
			_secondVertex = null;
			_lastVertex = null;
			completeFunction();
		}
	}
}