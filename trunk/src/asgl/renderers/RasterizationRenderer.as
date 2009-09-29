package asgl.renderers {
	import __AS3__.vec.Vector;
	
	import asgl.buffer.ZBuffer;
	import asgl.cameras.Camera3D;
	import asgl.data.info.PixelInfo;
	import asgl.drivers.AbstractRenderDriver;
	import asgl.drivers.ProjectionType;
	import asgl.lights.AbstractLight;
	import asgl.materials.Material;
	import asgl.materials.ShadingType;
	import asgl.math.Color;
	import asgl.math.GLMatrix3D;
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
	import flash.geom.Matrix;
	import flash.geom.Vector3D;
	/**
	 * RasterizationRenderer.
	 * <p>Support:</p>
	 * <p>ZBuffer.</p>
	 * <p>face:MaterialFace.</p>
	 * <p>FSAA:normal, h2x, v2x, 4x.</p>
	 * <p>light:all lights.</p>
	 * <p>texture:all textures.</p>
	 * <p>lightingReflectionRadio.</p>
	 * <p>multiRender.</p>
	 * <p>bilinearFiltering.</p>
	 * <p>colorSelfLmination.</p>
	 * <p>selfLuminationStrength.</p>
	 * <p>shadow:shaodw of all lights</p>
	 * <p>shading:flat, gouraud, phong. if use gouraud or phong, need concatFaces and screenSpaceNormal of faces. if use gouraud shading, can not use shadow</p>
	 * <p>if material of face is null, use color of face shading.
	 */
	public class RasterizationRenderer implements IRenderer {
		private static const ZBUFFER_COEFFICIENT:int = ZBuffer.COEFFICIENT;
		private static const HALF_PI:Number = Math.PI/2;
		private static const POSITIVE_INFINITY:Number = Number.POSITIVE_INFINITY;
		private static const NEGATIVE_INFINITY:Number = Number.NEGATIVE_INFINITY;
		private static const SHADING_FLAT:int = ShadingType.FLAT;
		private static const SHADING_GOURAUD:int = ShadingType.GOURAUD;
		private static const SHADING_PHONG:int = ShadingType.PHONG;
		public var depthBuffer:ZBuffer;
		private var _defaultMaterial:Material = new Material();
		/**
		 * temp
		 */
		private var _tempList:Array;
		private var _tempInt1:int;
		private var _tempInt2:int;
		
		private var _defaultView:BitmapDataView = new BitmapDataView();
		private var _tempMatrix:GLMatrix3D = new GLMatrix3D();
		//
		private var _matrix:Matrix = new Matrix();
		private var _tangentMatrix:GLMatrix3D = new GLMatrix3D();
		private var _kx:Number = 1;
		private var _ky:Number = 1;
		private var _FSAALevel:String = FullSceneAntiAliasLevel.NORMAL;
		private var _pixelScreenVector:Vector3D = new Vector3D();
		private var _pixelScreenVertex:Vertex3D = new Vertex3D();
		/**
		 *public
		 */
		private var _isLine:Boolean;
		private var _lineFirstInfinity:Boolean;
		private var _lineSecondInfinity:Boolean;
		private var _light:AbstractLight;
		private var _bilinearFilteringEnabled:Boolean;
		private var _colorSelfLuminationEnabled:Boolean;
		private var _doubleSidedLightEnabled:Boolean;
		private var _useBlendColor:Boolean;
		private var _alpha:int;
		private var _colorRed:int;
		private var _colorGreen:int;
		private var _colorBlue:int;
		private var _count:int;
		private var _integer:int;
		private var _key:int;
		private var _nx:int;
		private var _shadingType:int;
		private var _totalConcatFaces:int;
		private var _abs:Number;
		private var _abValue0:Number;
		private var _abValue1:Number;
		private var _acValue0:Number;
		private var _acValue1:Number;
		private var _brightness:Number;
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
		private var _lightingReflectionRadio:Number;
		private var _lightStrength:Number;
		private var _lineFirstB:Number;
		private var _lineFirstConst:Number;
		private var _lineFirstK:Number;
		private var _lineFirstSqrt:Number;
		private var _lineFirstX:Number;
		private var _lineGroup0Value0:Number;
		private var _lineGroup0Value1:Number;
		private var _lineGroup0Value2:Number;
		private var _lineGroup0Value3:Number;
		private var _lineGroup0Value4:Number;
		private var _lineGroup0Value5:Number;
		private var _lineGroup1Value0:Number;
		private var _lineGroup1Value1:Number;
		private var _lineGroup1Value2:Number;
		private var _lineGroup1Value3:Number;
		private var _lineGroup1Value4:Number;
		private var _lineGroup1Value5:Number;
		private var _lineGroup2Value0:Number;
		private var _lineGroup2Value1:Number;
		private var _lineGroup2Value2:Number;
		private var _lineGroup2Value3:Number;
		private var _lineGroup2Value4:Number;
		private var _lineGroup2Value5:Number;
		private var _lineky:Number;
		private var _lineSecondB:Number;
		private var _lineSecondConst:Number;
		private var _lineSecondK:Number;
		private var _lineSecondSqrt:Number;
		private var _lineSecondX:Number;
		private var _lineX:Number;
		private var _lineY:Number;
		private var _lineZ:Number;
		private var _mipmapZ:Number;
		private var _newVx0:Number;
		private var _newVy0:Number;
		private var _newVz0:Number;
		private var _newVx1:Number;
		private var _newVy1:Number;
		private var _newVz1:Number;
		private var _pixelScreenX:Number;
		private var _pixelScreenY:Number;
		private var _py:Number;
		private var _selfLuminationStrength:Number;
		private var _shadowAlphaRatio:Number;
		private var _shadowBlueRatio:Number;
		private var _shadowGreenRatio:Number;
		private var _shadowRedRatio:Number;
		private var _sin:Number;
		private var _strength:Number;
		private var _strengthRatio:Number;
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
		private var _concatFace:TriangleFace;
		private var _blendColor:uint;
		private var _color:uint;
		private var _selfLuminationColor:uint;
		private var _shadingColor:uint;
		private var _tempColor:uint;
		private var _firstUV:UV;
		private var _secondUV:UV;
		private var _lastUV:UV;
		private var _concatFaceList:Vector.<TriangleFace>;
		private var _concatFaceNormal:Vector3D;
		private var _firstVector:Vector3D = new Vector3D();
		private var _thirdVector:Vector3D = new Vector3D();
		private var _secondVector:Vector3D = new Vector3D();
		private var _concatVertex:Vertex3D;
		private var _firstVertex:Vertex3D;
		private var _secondVertex:Vertex3D;
		private var _lastVertex:Vertex3D;
		/**
		 * bilinearFiltering
		 */
		private var _bilinearX:int;
		private var _bilinearY:int;
		private var _bilinearSourceX:Number;
		private var _bilinearSourceY:Number;
		private var _bilinearKX:Number;
		private var _bilinearKY:Number;
		/**
		 * lightStrengthTexture
		 */
		private var _lightingStrengthBitmapData:BitmapData;
		private var _lightingStrengthTextureWidth:int;
		private var _lightingStrengthColor:uint;
		/**
		 * specularTexture
		 */
		private var _specularBitmapData:BitmapData;
		private var _specularTextureHeight:int;
		private var _specularTextureWidth:int;
		private var _specularColor:uint;
		/**
		 * gouraud shading
		 */
		private var _gouraudUseBlendColor:Boolean;
		private var _gi:int;
		private var _gj:int;
		private var _gouraudGroup0Alpha0:int;
		private var _gouraudGroup0Alpha1:int;
		private var _gouraudGroup0Red0:int;
		private var _gouraudGroup0Red1:int;
		private var _gouraudGroup0Green0:int;
		private var _gouraudGroup0Green1:int;
		private var _gouraudGroup0Blue0:int;
		private var _gouraudGroup0Blue1:int;
		private var _gouraudGroup1Alpha0:int;
		private var _gouraudGroup1Alpha1:int;
		private var _gouraudGroup1Red0:int;
		private var _gouraudGroup1Red1:int;
		private var _gouraudGroup1Green0:int;
		private var _gouraudGroup1Green1:int;
		private var _gouraudGroup1Blue0:int;
		private var _gouraudGroup1Blue1:int;
		private var _gouraudGroup2Alpha0:int;
		private var _gouraudGroup2Alpha1:int;
		private var _gouraudGroup2Red0:int;
		private var _gouraudGroup2Red1:int;
		private var _gouraudGroup2Green0:int;
		private var _gouraudGroup2Green1:int;
		private var _gouraudGroup2Blue0:int;
		private var _gouraudGroup2Blue1:int;
		private var _gouraudK:Number;
		private var _gouraudGroup0Value0:Number;
		private var _gouraudGroup0Value1:Number;
		private var _gouraudGroup1Value0:Number;
		private var _gouraudGroup1Value1:Number; 
		private var _gouraudGroup2Value0:Number;
		private var _gouraudGroup2Value1:Number;
		private var _gouraudMaxStrength:Number;
		private var _gouraudMinStrength:Number;
		private var _gouraudNormalX:Number;
		private var _gouraudNormalY:Number;
		private var _gouraudNormalZ:Number;
		private var _gouraudStrength:Number;
		private var _gouraudTempStrength0:Number;
		private var _gouraudTempStrength1:Number;
		private var _gouraudTempColor0:uint;
		private var _gouraudTempColor1:uint;
		/**
		 * bump & normal
		 */
		private var _bumpBitmapData:BitmapData;
		private var _normalBitmapData:BitmapData;
		private var _bnA:Number;
		private var _bnBx:Number;
		private var _bnBy:Number;
		private var _bnBz:Number;
		private var _bnK:Number;
		private var _bnTx:Number;
		private var _bnTy:Number;
		private var _bnTz:Number;
		private var _bumpkx:Number;
		private var _bumpky:Number;
		private var _bumpTextureHeight:Number;
		private var _bumpTextureWidth:Number;
		private var _bumpX:int;
		private var _bumpY:int;
		private var _normalColorX:int;
		private var _normalColorY:int;
		private var _normalColorZ:int;
		private var _normalTextureHeight:Number;
		private var _normalTextureWidth:Number;
		private var _normalZVectorX:Number;
		private var _normalZVectorY:Number;
		private var _normalZVectorZ:Number;
		private var _normalColor:uint;
		/**
		 * phong
		 */
		private var _pi:int;
		private var _pj:int;
		private var _phongFirstX:Number;
		private var _phongFirstVectorX:Number;
		private var _phongFirstVectorY:Number;
		private var _phongFirstVectorZ:Number;
		private var _phongK1:Number;
		private var _phongK2:Number;
		private var _phongLineValue0:Number;
		private var _phongLineValue1:Number;
		private var _phongLineValue2:Number;
		private var _phongLineValue3:Number;
		private var _phongLineValue4:Number;
		private var _phongLineValue5:Number;
		private var _phongNormalX:Number;
		private var _phongNormalY:Number;
		private var _phongNormalZ:Number;
		private var _phongSecondX:Number;
		private var _phongSecondVectorX:Number;
		private var _phongSecondVectorY:Number;
		private var _phongSecondVectorZ:Number;
		private var _phongX:Number;
		private var _phongY:Number;
		public function RasterizationRenderer(depthBuffer:ZBuffer=null):void {
			this.depthBuffer = depthBuffer;
		}
		public function get facesType():String {
			return FaceType.MATERIAL_FACE;
		}
		public function get FSAALevel():String {
			return _FSAALevel;
		}
		public function set FSAALevel(value:String):void {
			if (value == FullSceneAntiAliasLevel.NORMAL) {
				_kx = 1;
				_ky = 1;
				_matrix.a = 1;
				_matrix.d = 1;
				_FSAALevel = value;
			} else if (value == FullSceneAntiAliasLevel.HX2) {
				_kx = 0.5;
				_ky = 1;
				_matrix.a = 0.5;
				_matrix.d = 1;
				_FSAALevel = value;
			} else if (value == FullSceneAntiAliasLevel.VX2) {
				_kx = 1;
				_ky = 0.5;
				_matrix.a = 1;
				_matrix.d = 0.5;
				_FSAALevel = value;
			} else if (value == FullSceneAntiAliasLevel.X4) {
				_kx = 0.5;
				_ky = 0.5;
				_matrix.a = 0.5;
				_matrix.d = 0.5;
				_FSAALevel = value;
			}
		}
		public function get sourceBitmapData():BitmapData {
			return _defaultView.canvas as BitmapData;
		}
		public function destroy():void {
			depthBuffer = null;
			_firstVector = null;
			_thirdVector = null;
			_secondVector = null;
			_pixelScreenVector = null;
			_pixelScreenVertex = null;
			_defaultView.destroy();
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
			var nearClipDistance:Number = camera.nearClipDistance;
			var cameraScreenX:Number = camera.screenX;
			var cameraScreenY:Number = camera.screenY;
			var cameraScreenZ:Number = camera.screenZ;
			var lightListArray:Vector.<AbstractLight> = driver.lights == null ? new Vector.<AbstractLight>() : driver.lights;
			var totalLights:int = lightListArray.length;
			var isPerspective:Boolean = driver.projectionType == ProjectionType.PERSPECTIVE;
			
			var view:IView = driver.view;
			_defaultView.reset(width/_kx, height/_ky);
			var sourceBitmapData:BitmapData = _defaultView.canvas as BitmapData;
			sourceBitmapData.lock();
			
			_gouraudUseBlendColor = false;
			for (var i:Number = 0; i<totalLights; i++) {
				lightListArray[i].init(driver);
			}
			var totalFaces:int = faces.length;
			var next:int;
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
				var secondZ:Number = _secondVertex.screenZ;
				
				if (isPerspective) {
					_py = _firstVertex.cameraY;
					_lineGroup0Value0 = _firstVertex.cameraX-_secondVertex.cameraX;
					_lineGroup0Value1 = _py-_secondVertex.cameraY;
					_lineGroup0Value2 = _firstVertex.cameraZ-_secondVertex.cameraZ;
					_lineGroup0Value3 = _firstVertex.cameraX;
					_lineGroup0Value4 = _py;
					_lineGroup0Value5 = _firstVertex.cameraZ;
					if (minY>_py) minY = _py;
					if (maxY<_py) maxY = _py;
					
					_py = _secondVertex.cameraY;
					_lineGroup1Value0 = _secondVertex.cameraX-_lastVertex.cameraX;
					_lineGroup1Value1 = _py-_lastVertex.cameraY;
					_lineGroup1Value2 = _secondVertex.cameraZ-_lastVertex.cameraZ;
					_lineGroup1Value3 = _secondVertex.cameraX;
					_lineGroup1Value4 = _py;
					_lineGroup1Value5 = _secondVertex.cameraZ;
					if (minY>_py) minY = _py;
					if (maxY<_py) maxY = _py;
					
					_py = _lastVertex.cameraY;
					_lineGroup2Value0 = _lastVertex.cameraX-_firstVertex.cameraX;
					_lineGroup2Value1 = _py-_firstVertex.cameraY;
					_lineGroup2Value2 = _lastVertex.cameraZ-_firstVertex.cameraZ;
					_lineGroup2Value3 = _lastVertex.cameraX;
					_lineGroup2Value4 = _py;
					_lineGroup2Value5 = _lastVertex.cameraZ;
					if (minY>_py) minY = _py;
					if (maxY<_py) maxY = _py;
				} else {
					_py = firstY;
					_lineGroup0Value0 = firstX-secondX;
					_lineGroup0Value1 = _py-secondY;
					_lineGroup0Value2 = firstZ-secondZ;
					_lineGroup0Value3 = firstX;
					_lineGroup0Value4 = _py;
					_lineGroup0Value5 = firstZ;
					if (minY>_py) minY = _py;
					if (maxY<_py) maxY = _py;
					
					_py = secondY;
					_lineGroup1Value0 = secondX-_lastVertex.screenX;
					_lineGroup1Value1 = _py-_lastVertex.screenY;
					_lineGroup1Value2 = secondZ-_lastVertex.screenZ;
					_lineGroup1Value3 = secondX;
					_lineGroup1Value4 = _py;
					_lineGroup1Value5 = secondZ;
					if (minY>_py) minY = _py;
					if (maxY<_py) maxY = _py;
					
					_py = _lastVertex.screenY;
					_lineGroup2Value0 = _lastVertex.screenX-firstX;
					_lineGroup2Value1 = _py-firstY;
					_lineGroup2Value2 = _lastVertex.screenZ-firstZ;
					_lineGroup2Value3 = _lastVertex.screenX;
					_lineGroup2Value4 = _py;
					_lineGroup2Value5 = _lastVertex.screenZ;
					if (minY>_py) minY = _py;
					if (maxY<_py) maxY = _py;
				}
				
				if (minY/_ky != 0) {
					_integer = int(minY);
					if (_integer-minY>_ky) {
						minY = _integer-_ky*2;
					} else {
						minY = _integer-_ky;
					}
				}
				if (minY>0) {
					continue;
				} else if (minY<-height) {
					minY = -height;
				}
				if (maxY/_ky != 0) {
					_integer = int(maxY);
					if (_integer-maxY>_ky) {
						maxY = _integer-_ky;
					} else {
						maxY = _integer;
					}
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
				_lightingReflectionRadio = material.lightingReflectionRadio;
				_doubleSidedLightEnabled = material.doubleSidedLightEnabled;
				var useColorShading:Boolean = false;
				if (!material.diffuseTextureEnabled){
					_shadingColor = material.color;
					if ((_shadingColor>>24&0xFF) == 0) continue;
					useColorShading = true;
				}
				_bilinearFilteringEnabled = material.bilinearFilteringEnabled;
				_colorSelfLuminationEnabled = material.colorSelfLuminationEnabled;
				_selfLuminationStrength = material.selfLuminationStrength;
				_selfLuminationColor = material.selfLuminationColor;
				if (!useColorShading) {
					if (face.mipmapFilteringEnabled) {
						_mipmapZ = firstZ;
						if (_mipmapZ>secondZ) _mipmapZ = secondZ;
						if (_mipmapZ>lastZ) _mipmapZ = lastZ;
						_mipmapZ -= nearClipDistance;
						diffuseBitmapData = material.diffuseTexture.getMipBitmapData(int(_mipmapZ/face.mipmapDistance)+1);
						diffuseTextureHeight = diffuseBitmapData.height-1;
						diffuseTextureWidth = diffuseBitmapData.width-1;
					} else {
						diffuseBitmapData = material._diffuseBitmapData;
						diffuseTextureHeight = material._diffuseTextureHeight;
						diffuseTextureWidth = material._diffuseTextureWidth;
					}
				}
				_shadingType = SHADING_FLAT;
				var bumpTextureEnabled:Boolean = material._bumpTextureEnabled;
				var normalTextureEnabled:Boolean = material._normalTextureEnabled;
				if (!bumpTextureEnabled && !normalTextureEnabled) _shadingType = material._shadingType;
				if (bumpTextureEnabled) {
					_bumpBitmapData = material._bumpBitmapData;
					_bumpTextureHeight = material._bumpTextureHeight;
					_bumpTextureWidth = material._bumpTextureWidth;
				} else if (normalTextureEnabled) {
					_normalBitmapData = material._normalBitmapData;
					_normalTextureHeight = material._normalTextureHeight;
					_normalTextureWidth = material._normalTextureWidth;
				}
				var specularTextureEnabled:Boolean = material._specularTextureEnalbed;
				if (specularTextureEnabled) {
					_specularBitmapData = material._specularBitmapData;
					_specularTextureWidth = material._specularTextureWidth;
					_specularTextureHeight = material._specularTextureHeight;
				}
				var lightingStrengthTextureEnabled:Boolean = material._lightingStrengthTextureEnabled;
				if (lightingStrengthTextureEnabled) {
					_lightingStrengthBitmapData = material._lightingStrengthBitmapData;
					_lightingStrengthTextureWidth = material._lightingStrengthTextureWidth;
				}
				
				var lastX:Number = _lastVertex.screenX;
				var lastY:Number = _lastVertex.screenY;
				var lastZ:Number = _lastVertex.screenZ;
				
				var fsdx:Number = secondX-firstX;
				var fsdy:Number = secondY-firstY;
				var fldx:Number = lastX-firstX;
				var fldy:Number = lastY-firstY;
				var fsdz:Number = secondZ-firstZ;
				var fldz:Number = lastZ-firstZ;
				
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
					
					_lineFirstConst = _sin*Math.sqrt(fsdx*fsdx+fsdy*fsdy);
					_lineSecondConst = _sin*Math.sqrt(fldx*fldx+fldy*fldy);
				}
				
				var firstTAU:Number = _firstUV.u;
				var firstTAV:Number = _firstUV.v;
				var fsdu:Number = _secondUV.u-firstTAU;
				var fsdv:Number = _secondUV.v-firstTAV;
				var fldu:Number = _lastUV.u-firstTAU;
				var fldv:Number = _lastUV.v-firstTAV;
				
				var k1:Number = faceVectorX*firstX+faceVectorY*firstY+faceVectorZ*firstZ-faceVectorX*cameraScreenX-faceVectorY*cameraScreenY-faceVectorZ*cameraScreenZ;
				var k2:Number = faceVectorZ*perspectiveCoefficient;
				
				if (bumpTextureEnabled || normalTextureEnabled) {
					_bnK = 1/Math.sqrt(faceVectorX*faceVectorX+faceVectorY*faceVectorY+faceVectorZ*faceVectorZ);
					_tangentMatrix.c = faceVectorX*_bnK;//c
					_tangentMatrix.f = faceVectorY*_bnK;//f
					_tangentMatrix.i = faceVectorZ*_bnK;//i
					
					_bnA = fldu*fsdv-fsdu*fldv;
					
					_bnTx = (fsdx*fldv-fldx*fsdv)/_bnA;
					_bnTy = (fsdy*fldv-fldy*fsdv)/_bnA;
					_bnTz = (fsdz*fldv-fldz*fsdv)/_bnA;
					
					_bnK = 1/Math.sqrt(_bnTx*_bnTx+_bnTy*_bnTy+_bnTz*_bnTz);
					_tangentMatrix.a = _bnTx*_bnK;
					_tangentMatrix.d = _bnTy*_bnK;
					_tangentMatrix.g = _bnTz*_bnK;
					
					_bnBx = (fldx*fsdu-fsdx*fldu)/_bnA;
					_bnBy = (fldy*fsdu-fsdy*fldu)/_bnA;
					_bnBz = (fldz*fsdu-fsdz*fldu)/_bnA;
					
					_bnK = 1/Math.sqrt(_bnBx*_bnBx+_bnBy*_bnBy+_bnBz*_bnBz);
					_tangentMatrix.b = _bnBx*_bnK;
					_tangentMatrix.e = _bnBy*_bnK;
					_tangentMatrix.h = _bnBz*_bnK;
				} else if (_shadingType == SHADING_GOURAUD) {
					_concatFaceList = face.concatFaces;
					//for gouraud0_0
					_concatFaceNormal = face.vector;
					if (_concatFaceList == null || (_totalConcatFaces = _concatFaceList.length) == 0) {
						_firstVector.x = _concatFaceNormal.x;
						_firstVector.y = _concatFaceNormal.y;
						_firstVector.z = _concatFaceNormal.z;
						
						_secondVector.x = _concatFaceNormal.x;
						_secondVector.y = _concatFaceNormal.y;
						_secondVector.z = _concatFaceNormal.z;
						
						_thirdVector.x = _concatFaceNormal.x;
						_thirdVector.y = _concatFaceNormal.y;
						_thirdVector.z = _concatFaceNormal.z;
					} else {
						_gouraudNormalX = _concatFaceNormal.x;
						_gouraudNormalY = _concatFaceNormal.y;
						_gouraudNormalZ = _concatFaceNormal.z;
						for (_gi = 0; _gi<_totalConcatFaces; _gi++) {
							_concatFace = _concatFaceList[_gi];
							//for gouraud1_0
							_concatVertex = _concatFace.vertex0;
							if (firstX == _concatVertex.screenX && firstY == _concatVertex.screenY && firstZ == _concatVertex.screenZ) {
								_concatFaceNormal = _concatFace.vector;
								_gouraudNormalX += _concatFaceNormal.x;
								_gouraudNormalY += _concatFaceNormal.y;
								_gouraudNormalZ += _concatFaceNormal.z;
							} else {
								//for gouraud1_1
								_concatVertex = _concatFace.vertex1;
								if (firstX == _concatVertex.screenX && firstY == _concatVertex.screenY && firstZ == _concatVertex.screenZ) {
									_concatFaceNormal = _concatFace.vector;
									_gouraudNormalX += _concatFaceNormal.x;
									_gouraudNormalY += _concatFaceNormal.y;
									_gouraudNormalZ += _concatFaceNormal.z;
								} else {
									//for gouraud1_2
									_concatVertex = _concatFace.vertex2;
									if (firstX == _concatVertex.screenX && firstY == _concatVertex.screenY && firstZ == _concatVertex.screenZ) {
										_concatFaceNormal = _concatFace.vector;
										_gouraudNormalX += _concatFaceNormal.x;
										_gouraudNormalY += _concatFaceNormal.y;
										_gouraudNormalZ += _concatFaceNormal.z;
									}
								}
							}
						}
						_firstVector.x = _gouraudNormalX;
						_firstVector.y = _gouraudNormalY;
						_firstVector.z = _gouraudNormalZ;
						
						//for gouraud0_1
						_concatFaceNormal = face.vector;
						_gouraudNormalX = _concatFaceNormal.x;
						_gouraudNormalY = _concatFaceNormal.y;
						_gouraudNormalZ = _concatFaceNormal.z;
						for (_gi = 0; _gi<_totalConcatFaces; _gi++) {
							_concatFace = _concatFaceList[_gi];
							//for gouraud1_0
							_concatVertex = _concatFace.vertex0;
							if (secondX == _concatVertex.screenX && secondY == _concatVertex.screenY && secondZ == _concatVertex.screenZ) {
								_concatFaceNormal = _concatFace.vector;
								_gouraudNormalX += _concatFaceNormal.x;
								_gouraudNormalY += _concatFaceNormal.y;
								_gouraudNormalZ += _concatFaceNormal.z;
							} else {
								//for gouraud1_1
								_concatVertex = _concatFace.vertex1;
								if (secondX == _concatVertex.screenX && secondY == _concatVertex.screenY && secondZ == _concatVertex.screenZ) {
									_concatFaceNormal = _concatFace.vector;
									_gouraudNormalX += _concatFaceNormal.x;
									_gouraudNormalY += _concatFaceNormal.y;
									_gouraudNormalZ += _concatFaceNormal.z;
								} else {
									//for gouraud1_2
									_concatVertex = _concatFace.vertex2;
									if (secondX == _concatVertex.screenX && secondY == _concatVertex.screenY && secondZ == _concatVertex.screenZ) {
										_concatFaceNormal = _concatFace.vector;
										_gouraudNormalX += _concatFaceNormal.x;
										_gouraudNormalY += _concatFaceNormal.y;
										_gouraudNormalZ += _concatFaceNormal.z;
									}
								}
							}
						}
						_secondVector.x = _gouraudNormalX;
						_secondVector.y = _gouraudNormalY;
						_secondVector.z = _gouraudNormalZ;
						
						//for gouraud0_2
						_concatFaceNormal = face.vector;
						_gouraudNormalX = _concatFaceNormal.x;
						_gouraudNormalY = _concatFaceNormal.y;
						_gouraudNormalZ = _concatFaceNormal.z;
						for (_gi = 0; _gi<_totalConcatFaces; _gi++) {
							_concatFace = _concatFaceList[_gi];
							//for gouraud1_0
							_concatVertex = _concatFace.vertex0;
							if (lastX == _concatVertex.screenX && lastY == _concatVertex.screenY && lastZ == _concatVertex.screenZ) {
								_concatFaceNormal = _concatFace.vector;
								_gouraudNormalX += _concatFaceNormal.x;
								_gouraudNormalY += _concatFaceNormal.y;
								_gouraudNormalZ += _concatFaceNormal.z;
							} else {
								//for gouraud1_1
								_concatVertex = _concatFace.vertex1;
								if (lastX == _concatVertex.screenX && lastY == _concatVertex.screenY && lastZ == _concatVertex.screenZ) {
									_concatFaceNormal = _concatFace.vector;
									_gouraudNormalX += _concatFaceNormal.x;
									_gouraudNormalY += _concatFaceNormal.y;
									_gouraudNormalZ += _concatFaceNormal.z;
								} else {
									//for gouraud1_2
									_concatVertex = _concatFace.vertex2;
									if (lastX == _concatVertex.screenX && lastY == _concatVertex.screenY && lastZ == _concatVertex.screenZ) {
										_concatFaceNormal = _concatFace.vector;
										_gouraudNormalX += _concatFaceNormal.x;
										_gouraudNormalY += _concatFaceNormal.y;
										_gouraudNormalZ += _concatFaceNormal.z;
									}
								}
							}
						}
						_thirdVector.x = _gouraudNormalX;
						_thirdVector.y = _gouraudNormalY;
						_thirdVector.z = _gouraudNormalZ;
					}
					
					_strength = 0;
					_useBlendColor = false;
					for (_gi = 0; _gi<totalLights; _gi++) {
						_light = lightListArray[_gi];
						_light.lightingTest(_firstVertex, _firstVector);
						_strengthRatio = _light.strengthRatio;
						if (_strengthRatio<0) _strengthRatio = _doubleSidedLightEnabled ? -_strengthRatio : 0;
						_strength += _light.strength*_strengthRatio*_lightingReflectionRadio;
						if (_light.colorLightingEnabled) {
							_gouraudUseBlendColor = true;
							_tempColor = _light.lightingColor;
							_tempColor = ((_tempColor>>24&0xFF)*_light.strength*_strengthRatio)<<24|_tempColor&0xFFFFFF;
							if (_useBlendColor) {
								_blendColor = Color.colorBlend(_tempColor, _blendColor);
							} else {
								_blendColor = _tempColor;
								_useBlendColor = true;
							}
						}
					}
					if (_strength>1) _strength = 1;
					_gouraudTempStrength0 = _strength;
					_gouraudTempColor0 = _blendColor;
					
					_strength = 0;
					_useBlendColor = false;
					for (_gi = 0; _gi<totalLights; _gi++) {
						_light = lightListArray[_gi];
						_light.lightingTest(_secondVertex, _secondVector);
						_strengthRatio = _light.strengthRatio;
						if (_strengthRatio<0) _strengthRatio = _doubleSidedLightEnabled ? -_strengthRatio : 0;
						_strength += _light.strength*_strengthRatio*_lightingReflectionRadio;
						if (_light.colorLightingEnabled) {
							_gouraudUseBlendColor = true;
							_tempColor = _light.lightingColor;
							_tempColor = ((_tempColor>>24&0xFF)*_light.strength*_strengthRatio)<<24|_tempColor&0xFFFFFF;
							if (_useBlendColor) {
								_blendColor = Color.colorBlend(_tempColor, _blendColor);
							} else {
								_blendColor = _tempColor;
								_useBlendColor = true;
							}
						}
					}
					if (_strength>1) _strength = 1;
					_gouraudTempStrength1 = _strength;
					_gouraudTempColor1 = _blendColor;
					
					_strength = 0;
					_useBlendColor = false;
					for (_gi = 0; _gi<totalLights; _gi++) {
						_light = lightListArray[_gi];
						_light.lightingTest(_lastVertex, _thirdVector);
						_strengthRatio = _light.strengthRatio;
						if (_strengthRatio<0) _strengthRatio = _doubleSidedLightEnabled ? -_strengthRatio : 0;
						_strength += _light.strength*_strengthRatio*_lightingReflectionRadio;
						if (_light.colorLightingEnabled) {
							_gouraudUseBlendColor = true;
							_tempColor = _light.lightingColor;
							_tempColor = ((_tempColor>>24&0xFF)*_light.strength*_strengthRatio)<<24|_tempColor&0xFFFFFF;
							if (_useBlendColor) {
								_blendColor = Color.colorBlend(_tempColor, _blendColor);
							} else {
								_blendColor = _tempColor;
								_useBlendColor = true;
							}
						}
					}
					if (_strength>1) _strength = 1;
					
					_gouraudGroup0Value0 = _gouraudTempStrength0;
					_gouraudGroup0Value1 = _gouraudTempStrength1;
					_gouraudGroup1Value0 = _gouraudGroup0Value1;
					_gouraudGroup1Value1 = _strength;
					_gouraudGroup2Value0 = _gouraudGroup1Value1;
					_gouraudGroup2Value1 = _gouraudGroup0Value0;
					if (_gouraudUseBlendColor) {
						_gouraudGroup0Alpha0 = _gouraudTempColor0>>24&0xFF;
						_gouraudGroup0Red0 = _gouraudTempColor0>>16&0xFF;
						_gouraudGroup0Green0 = _gouraudTempColor0>>8&0xFF;
						_gouraudGroup0Blue0 = _gouraudTempColor0&0xFF;
						
						_gouraudGroup0Alpha1 = _gouraudTempColor1>>24&0xFF;
						_gouraudGroup0Red1 = _gouraudTempColor1>>16&0xFF;
						_gouraudGroup0Green1 = _gouraudTempColor1>>8&0xFF;
						_gouraudGroup0Blue1 = _gouraudTempColor1&0xFF;
						
						_gouraudGroup1Alpha0 = _gouraudGroup0Alpha1;
						_gouraudGroup1Red0 = _gouraudGroup0Red1;
						_gouraudGroup1Green0 = _gouraudGroup0Green1;
						_gouraudGroup1Blue0 = _gouraudGroup0Blue1;
						
						_gouraudGroup1Alpha1 = _blendColor>>24&0xFF;
						_gouraudGroup1Red1 = _blendColor>>16&0xFF;
						_gouraudGroup1Green1 = _blendColor>>8&0xFF;
						_gouraudGroup1Blue1 = _blendColor&0xFF;
						
						_gouraudGroup2Alpha0 = _gouraudGroup1Alpha1;
						_gouraudGroup2Red0 = _gouraudGroup1Red1;
						_gouraudGroup2Green0 = _gouraudGroup1Green1;
						_gouraudGroup2Blue0 = _gouraudGroup1Blue1;
						_gouraudGroup2Alpha1 = _gouraudGroup0Alpha0;
						_gouraudGroup2Red1 = _gouraudGroup0Red0;
						_gouraudGroup2Green1 = _gouraudGroup0Green0;
						_gouraudGroup2Blue1 = _gouraudGroup0Blue0;
					}
				} else if (_shadingType == SHADING_PHONG) {
					_phongLineValue0 = firstX-secondX;
					_phongLineValue1 = firstY-secondY;
					_phongLineValue2 = secondX-lastX;
					_phongLineValue3 = secondY-lastY;
					_phongLineValue4 = lastX-firstX;
					_phongLineValue5 = lastY-firstY;
					
					_concatFaceList = face.concatFaces;
					
					_concatFaceNormal = face.vector;
					if (_concatFaceList == null || (_totalConcatFaces = _concatFaceList.length) == 0) {
						_firstVector.x = _concatFaceNormal.x;
						_firstVector.y = _concatFaceNormal.y;
						_firstVector.z = _concatFaceNormal.z;
						
						_secondVector.x = _concatFaceNormal.x;
						_secondVector.y = _concatFaceNormal.y;
						_secondVector.z = _concatFaceNormal.z;
						
						_thirdVector.x = _concatFaceNormal.x;
						_thirdVector.y = _concatFaceNormal.y;
						_thirdVector.z = _concatFaceNormal.z;
					} else {
						//for phong0_0
						_phongNormalX = _concatFaceNormal.x;
						_phongNormalY = _concatFaceNormal.y;
						_phongNormalZ = _concatFaceNormal.z;
						for (_pi = 0; _pi<_totalConcatFaces; _pi++) {
							_concatFace = _concatFaceList[_pi];
							//for phong1_0
							_concatVertex = _concatFace.vertex0;
							if (firstX == _concatVertex.screenX && firstY == _concatVertex.screenY && firstZ == _concatVertex.screenZ) {
								_concatFaceNormal = _concatFace.vector;
								_phongNormalX += _concatFaceNormal.x;
								_phongNormalY += _concatFaceNormal.y;
								_phongNormalZ += _concatFaceNormal.z;
							} else {
								//for phong1_1
								_concatVertex = _concatFace.vertex1;
								if (firstX == _concatVertex.screenX && firstY == _concatVertex.screenY && firstZ == _concatVertex.screenZ) {
									_concatFaceNormal = _concatFace.vector;
									_phongNormalX += _concatFaceNormal.x;
									_phongNormalY += _concatFaceNormal.y;
									_phongNormalZ += _concatFaceNormal.z;
								} else {
									//for phong1_2
									_concatVertex = _concatFace.vertex2;
									if (firstX == _concatVertex.screenX && firstY == _concatVertex.screenY && firstZ == _concatVertex.screenZ) {
										_concatFaceNormal = _concatFace.vector;
										_phongNormalX += _concatFaceNormal.x;
										_phongNormalY += _concatFaceNormal.y;
										_phongNormalZ += _concatFaceNormal.z;
									}
								}
							}
						}
						_firstVector.x = _phongNormalX;
						_firstVector.y = _phongNormalY;
						_firstVector.z = _phongNormalZ;
						
						//for phong0_1
						_concatFaceNormal = face.vector;
						_phongNormalX = _concatFaceNormal.x;
						_phongNormalY = _concatFaceNormal.y;
						_phongNormalZ = _concatFaceNormal.z;
						for (_pi = 0; _pi<_totalConcatFaces; _pi++) {
							_concatFace = _concatFaceList[_pi];
							//for phong1_0
							_concatVertex = _concatFace.vertex0;
							if (secondX == _concatVertex.screenX && secondY == _concatVertex.screenY && secondZ == _concatVertex.screenZ) {
								_concatFaceNormal = _concatFace.vector;
								_phongNormalX += _concatFaceNormal.x;
								_phongNormalY += _concatFaceNormal.y;
								_phongNormalZ += _concatFaceNormal.z;
							} else {
								//for phong1_1
								_concatVertex = _concatFace.vertex1;
								if (secondX == _concatVertex.screenX && secondY == _concatVertex.screenY && secondZ == _concatVertex.screenZ) {
									_concatFaceNormal = _concatFace.vector;
									_phongNormalX += _concatFaceNormal.x;
									_phongNormalY += _concatFaceNormal.y;
									_phongNormalZ += _concatFaceNormal.z;
								} else {
									//for phong1_2
									_concatVertex = _concatFace.vertex2;
									if (secondX == _concatVertex.screenX && secondY == _concatVertex.screenY && secondZ == _concatVertex.screenZ) {
										_concatFaceNormal = _concatFace.vector;
										_phongNormalX += _concatFaceNormal.x;
										_phongNormalY += _concatFaceNormal.y;
										_phongNormalZ += _concatFaceNormal.z;
									}
								}
							}
						}
						_secondVector.x = _phongNormalX;
						_secondVector.y = _phongNormalY;
						_secondVector.z = _phongNormalZ;
						
						//for phong0_2
						_concatFaceNormal = face.vector;
						_phongNormalX = _concatFaceNormal.x;
						_phongNormalY = _concatFaceNormal.y;
						_phongNormalZ = _concatFaceNormal.z;
						for (_pi = 0; _pi<_totalConcatFaces; _pi++) {
							_concatFace = _concatFaceList[_pi];
							//for phong1_0
							_concatVertex = _concatFace.vertex0;
							if (lastX == _concatVertex.screenX && lastY == _concatVertex.screenY && lastZ == _concatVertex.screenZ) {
								_concatFaceNormal = _concatFace.vector;
								_phongNormalX += _concatFaceNormal.x;
								_phongNormalY += _concatFaceNormal.y;
								_phongNormalZ += _concatFaceNormal.z;
							} else {
								//for phong1_1
								_concatVertex = _concatFace.vertex1;
								if (lastX == _concatVertex.screenX && lastY == _concatVertex.screenY && lastZ == _concatVertex.screenZ) {
									_concatFaceNormal = _concatFace.vector;
									_phongNormalX += _concatFaceNormal.x;
									_phongNormalY += _concatFaceNormal.y;
									_phongNormalZ += _concatFaceNormal.z;
								} else {
									//for phong1_2
									_concatVertex = _concatFace.vertex2;
									if (lastX == _concatVertex.screenX && lastY == _concatVertex.screenY && lastZ == _concatVertex.screenZ) {
										_concatFaceNormal = _concatFace.vector;
										_phongNormalX += _concatFaceNormal.x;
										_phongNormalY += _concatFaceNormal.y;
										_phongNormalZ += _concatFaceNormal.z;
									}
								}
							}
						}
						_thirdVector.x = _phongNormalX;
						_thirdVector.y = _phongNormalY;
						_thirdVector.z = _phongNormalZ;
					}
				} else {
					_pixelScreenVector.x = faceVectorX;
					_pixelScreenVector.y = faceVectorY;
					_pixelScreenVector.z = faceVectorZ;
				}
				
				
				for (var y:Number = minY; y<=maxY; y += _ky) {
					var minX:Number = POSITIVE_INFINITY;
					var maxX:Number = NEGATIVE_INFINITY;
					var minZ:Number;
					var maxZ:Number;
					
					var _gouraudAlpha:int;
					var _gouraudRed:int;
					var _gouraudGreen:int;
					var _gouraudBlue:int;
					var _gouraudMinAlpha:int;
					var _gouraudMaxAlpha:int;
					var _gouraudMinRed:int;
					var _gouraudMaxRed:int;
					var _gouraudMinGreen:int;
					var _gouraudMaxGreen:int;
					var _gouraudMinBlue:int;
					var _gouraudMaxBlue:int;
					if (_shadingType == SHADING_GOURAUD) {
						if (_lineGroup0Value1 != 0) {
							_lineky = (_lineGroup0Value4-y)/_lineGroup0Value1;
							if (_lineky>=0 && _lineky<=1) {
								_lineX = _lineGroup0Value3-_lineky*_lineGroup0Value0;
								_lineZ = _lineGroup0Value5-_lineky*_lineGroup0Value2;
								_gouraudStrength = _lineky*_gouraudGroup0Value1+(1-_lineky)*_gouraudGroup0Value0;
								if (_gouraudUseBlendColor) {
									_gouraudAlpha = _lineky*_gouraudGroup0Alpha1+(1-_lineky)*_gouraudGroup0Alpha0;
									_gouraudRed = _lineky*_gouraudGroup0Red1+(1-_lineky)*_gouraudGroup0Red0;
									_gouraudGreen = _lineky*_gouraudGroup0Green1+(1-_lineky)*_gouraudGroup0Green0;
									_gouraudBlue = _lineky*_gouraudGroup0Blue1+(1-_lineky)*_gouraudGroup0Blue0;
									if (minX>_lineX) {
										minX = _lineX;
										minZ = _lineZ;
										_gouraudMinStrength = _gouraudStrength;
										_gouraudMinAlpha = _gouraudAlpha;
										_gouraudMinRed = _gouraudRed;
										_gouraudMinGreen = _gouraudGreen;
										_gouraudMinBlue = _gouraudBlue;
									}
									if (maxX<_lineX) {
										maxX = _lineX;
										maxZ = _lineZ;
										_gouraudMaxStrength = _gouraudStrength;
										_gouraudMaxAlpha = _gouraudAlpha;
										_gouraudMaxRed = _gouraudRed;
										_gouraudMaxGreen = _gouraudGreen;
										_gouraudMaxBlue = _gouraudBlue;
									}
								} else {
									if (minX>_lineX) {
										minX = _lineX;
										minZ = _lineZ;
										_gouraudMinStrength = _gouraudStrength;
									}
									if (maxX<_lineX) {
										maxX = _lineX;
										maxZ = _lineZ;
										_gouraudMaxStrength = _gouraudStrength;
									}
								}
							}
						}
						if (_lineGroup1Value1 != 0) {
							_lineky = (_lineGroup1Value4-y)/_lineGroup1Value1;
							if (_lineky>=0 && _lineky<=1) {
								_lineX = _lineGroup1Value3-_lineky*_lineGroup1Value0;
								_lineZ = _lineGroup1Value5-_lineky*_lineGroup1Value2;
								_gouraudStrength = _lineky*_gouraudGroup1Value1+(1-_lineky)*_gouraudGroup1Value0;
								if (_gouraudUseBlendColor) {
									_gouraudAlpha = _lineky*_gouraudGroup1Alpha1+(1-_lineky)*_gouraudGroup1Alpha0;
									_gouraudRed = _lineky*_gouraudGroup1Red1+(1-_lineky)*_gouraudGroup1Red0;
									_gouraudGreen = _lineky*_gouraudGroup1Green1+(1-_lineky)*_gouraudGroup1Green0;
									_gouraudBlue = _lineky*_gouraudGroup1Blue1+(1-_lineky)*_gouraudGroup1Blue0;
									if (minX>_lineX) {
										minX = _lineX;
										minZ = _lineZ;
										_gouraudMinStrength = _gouraudStrength;
										_gouraudMinAlpha = _gouraudAlpha;
										_gouraudMinRed = _gouraudRed;
										_gouraudMinGreen = _gouraudGreen;
										_gouraudMinBlue = _gouraudBlue;
									}
									if (maxX<_lineX) {
										maxX = _lineX;
										maxZ = _lineZ;
										_gouraudMaxStrength = _gouraudStrength;
										_gouraudMaxAlpha = _gouraudAlpha;
										_gouraudMaxRed = _gouraudRed;
										_gouraudMaxGreen = _gouraudGreen;
										_gouraudMaxBlue = _gouraudBlue;
									}
								} else {
									if (minX>_lineX) {
										minX = _lineX;
										minZ = _lineZ;
										_gouraudMinStrength = _gouraudStrength;
									}
									if (maxX<_lineX) {
										maxX = _lineX;
										maxZ = _lineZ;
										_gouraudMaxStrength = _gouraudStrength;
									}
								}
							}
						}
						if (_lineGroup2Value1 != 0) {
							_lineky = (_lineGroup2Value4-y)/_lineGroup2Value1;
							if (_lineky>=0 && _lineky<=1) {
								_lineX = _lineGroup2Value3-_lineky*_lineGroup2Value0;
								_lineZ = _lineGroup2Value5-_lineky*_lineGroup2Value2;
								_gouraudStrength = _lineky*_gouraudGroup2Value1+(1-_lineky)*_gouraudGroup2Value0;
								if (_gouraudUseBlendColor) {
									_gouraudAlpha = _lineky*_gouraudGroup2Alpha1+(1-_lineky)*_gouraudGroup2Alpha0;
									_gouraudRed = _lineky*_gouraudGroup2Red1+(1-_lineky)*_gouraudGroup2Red0;
									_gouraudGreen = _lineky*_gouraudGroup2Green1+(1-_lineky)*_gouraudGroup2Green0;
									_gouraudBlue = _lineky*_gouraudGroup2Blue1+(1-_lineky)*_gouraudGroup2Blue0;
									if (minX>_lineX) {
										minX = _lineX;
										minZ = _lineZ;
										_gouraudMinStrength = _gouraudStrength;
										_gouraudMinAlpha = _gouraudAlpha;
										_gouraudMinRed = _gouraudRed;
										_gouraudMinGreen = _gouraudGreen;
										_gouraudMinBlue = _gouraudBlue;
									}
									if (maxX<_lineX) {
										maxX = _lineX;
										maxZ = _lineZ;
										_gouraudMaxStrength = _gouraudStrength;
										_gouraudMaxAlpha = _gouraudAlpha;
										_gouraudMaxRed = _gouraudRed;
										_gouraudMaxGreen = _gouraudGreen;
										_gouraudMaxBlue = _gouraudBlue;
									}
								} else {
									if (minX>_lineX) {
										minX = _lineX;
										minZ = _lineZ;
										_gouraudMinStrength = _gouraudStrength;
									}
									if (maxX<_lineX) {
										maxX = _lineX;
										maxZ = _lineZ;
										_gouraudMaxStrength = _gouraudStrength;
									}
								}
							}
						}
					} else {
						if (_lineGroup0Value1 != 0) {
							_lineky = (_lineGroup0Value4-y)/_lineGroup0Value1;
							if (_lineky>=0 && _lineky<=1) {
								_lineX = _lineGroup0Value3-_lineky*_lineGroup0Value0;
								_lineZ = _lineGroup0Value5-_lineky*_lineGroup0Value2;
								if (minX>_lineX) {
									minX = _lineX;
									minZ = _lineZ;
								}
								if (maxX<_lineX) {
									maxX = _lineX;
									maxZ = _lineZ;
								}
							}
						}
						if (_lineGroup1Value1 != 0) {
							_lineky = (_lineGroup1Value4-y)/_lineGroup1Value1;
							if (_lineky>=0 && _lineky<=1) {
								_lineX = _lineGroup1Value3-_lineky*_lineGroup1Value0;
								_lineZ = _lineGroup1Value5-_lineky*_lineGroup1Value2;
								if (minX>_lineX) {
									minX = _lineX;
									minZ = _lineZ;
								}
								if (maxX<_lineX) {
									maxX = _lineX;
									maxZ = _lineZ;
								}
							}
						}
						if (_lineGroup2Value1 != 0) {
							_lineky = (_lineGroup2Value4-y)/_lineGroup2Value1;
							if (_lineky>=0 && _lineky<=1) {
								_lineX = _lineGroup2Value3-_lineky*_lineGroup2Value0;
								_lineZ = _lineGroup2Value5-_lineky*_lineGroup2Value2;
								if (minX>_lineX) {
									minX = _lineX;
									minZ = _lineZ;
								}
								if (maxX<_lineX) {
									maxX = _lineX;
									maxZ = _lineZ;
								}
							}
						}
					}
					
					if (minX/_kx != 0) {
						_integer = int(minX);
						if (minX-_integer>_kx) {
							minX = _integer+_kx*2;
						} else {
							minX = _integer+_kx;
						}
					}
					if (minX>width) {
						continue;
					} else if (minX<0) {
						minX = 0;
					}
					if (maxX/_kx != 0) {
						_integer = int(maxX);
						if (maxX-_integer>_kx) {
							maxX = _integer+_kx;
						} else {
							maxX = _integer;
						}
					}
					if (maxX<0) {
						continue;
					} else if (maxX>width) {
						maxX = width;
					}
					
					var lengthX:Number = maxX-minX;
					
					//var dk:Number = (maxZ-minZ)/lengthX;
					
					var ny:int = y/_ky;
					for (var x:Number = minX; x<=maxX; x += _kx) {
						_nx = x/_kx;
						_key = _nx*ZBUFFER_COEFFICIENT-ny;
						_info = ZBufferList[_key];
						if (_info == null) {
							_info = new PixelInfo(_nx, -ny);
							ZBufferList[_key] = _info;
						}
						
						//var depth:Number = lengthX == 0 ? maxZ : minZ+dk*(x-minX);
						if (_shadingType == SHADING_GOURAUD && lengthX != 0) {
							_gouraudK = (maxX-x)/lengthX;
							_gouraudStrength = _gouraudMinStrength*_gouraudK+_gouraudMaxStrength*(1-_gouraudK);
							if (_gouraudUseBlendColor) _blendColor = (_gouraudMinAlpha*_gouraudK+_gouraudMaxAlpha*(1-_gouraudK))<<24|(_gouraudMinRed*_gouraudK+_gouraudMaxRed*(1-_gouraudK))<<16|(_gouraudMinGreen*_gouraudK+_gouraudMaxGreen*(1-_gouraudK))<<8|(_gouraudMinBlue*_gouraudK+_gouraudMaxBlue*(1-_gouraudK));
						}
						
						if (isPerspective) {
							_dX = x-cameraScreenX;
							_dY = y-cameraScreenY;
							_t = k1/(faceVectorX*_dX+faceVectorY*_dY+k2);
							
							_pixelScreenX = cameraScreenX+_t*_dX;
							_pixelScreenY = cameraScreenY+_t*_dY;
							
							_pixelScreenVertex.screenZ = cameraScreenZ+_t*perspectiveCoefficient;
						} else {
							_pixelScreenX = x;
							_pixelScreenY = y;
							
							_pixelScreenVertex.screenZ = (faceVectorX*(firstX-x)+faceVectorY*(firstY-y)+faceVectorZ*firstZ)/faceVectorZ;
						}
						
						_pixelScreenVertex.screenX = _pixelScreenX;
						_pixelScreenVertex.screenY = _pixelScreenY;
						
						_depth = _pixelScreenVertex.screenZ;
						
						if (useColorShading) {
							_color = _shadingColor;
							if (specularTextureEnabled) {
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
							}
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
							
							if (_bilinearFilteringEnabled) {
								_bilinearSourceX = diffuseTextureWidth*_textureU;
								_bilinearSourceY = diffuseTextureHeight*_textureV;
								_bilinearX = int(_bilinearSourceX);
								_bilinearY = int(_bilinearSourceY);
								_bilinearKX = _bilinearSourceX-_bilinearX;
								_bilinearKY = _bilinearSourceY-_bilinearY;
								_color = _pixelBlend(_pixelBlend(diffuseBitmapData.getPixel32(_bilinearX, _bilinearY), diffuseBitmapData.getPixel32(++_bilinearX, _bilinearY++), _bilinearKX), _pixelBlend(diffuseBitmapData.getPixel32(--_bilinearX, _bilinearY), diffuseBitmapData.getPixel32(++_bilinearX, _bilinearY), _bilinearKX), _bilinearKY);
							} else {
								_color = diffuseBitmapData.getPixel32(diffuseTextureWidth*_textureU, diffuseTextureHeight*_textureV);
							}
						}
						_alpha = _color>>24&0xFF;
						if (_alpha == 0) continue;
						
						if (_info.refreshCount == refreshCount) {
							if (_alpha == 255) {
								if (_info.alphaColorList == null) {
									if (_depth<_info.opaqueColorDepth) {
										//No1
										if (bumpTextureEnabled) {
											_bumpX = _bumpTextureWidth*_textureU;
											_bumpY = _bumpTextureHeight*_textureV;
											_bumpkx = (_bumpBitmapData.getPixel((_bumpX == 0 ? _bumpX : _bumpX-1), _bumpY)-_bumpBitmapData.getPixel((_bumpX == _bumpTextureWidth ? _bumpX : _bumpX+1), _bumpY))/16777215;
											_bumpky = (_bumpBitmapData.getPixel(_bumpX, (_bumpY == 0 ? _bumpY : _bumpY-1))-_bumpBitmapData.getPixel(_bumpX, (_bumpY == _bumpTextureHeight ? _bumpY : _bumpY+1)))/16777215;
											
											_tempMatrix.copy(_tangentMatrix);
											_tempMatrix.rotationY = 90*_bumpkx;
											_tempMatrix.rotationX = 90*_bumpky;
											
											_pixelScreenVector.x = _tempMatrix.c;
											_pixelScreenVector.y = _tempMatrix.f;
											_pixelScreenVector.z = _tempMatrix.i;
										} else if (normalTextureEnabled) {
											_normalColor = _normalBitmapData.getPixel(_normalTextureWidth*_textureU, _normalTextureHeight*_textureV);
											_normalColorX = _normalColor>>16&0xFF;
											_normalColorY = _normalColor>>8&0xFF;
											_normalColorZ = _normalColor&0xFF;
											if (_normalColorX>127) {
												_normalZVectorX = (_normalColorX-127)/128;
											} else if (_normalColorX<127) {
												_normalZVectorX = (_normalColorX-127)/127;
											} else {
												_normalZVectorX = 0;
											}
											if (_normalColorY>127) {
												_normalZVectorY = (_normalColorY-127)/128;
											} else if (_normalColorY<127) {
												_normalZVectorY = (_normalColorY-127)/127;
											} else {
												_normalZVectorY = 0;
											}
											if (_normalColorZ>127) {
												_normalZVectorZ = (_normalColorZ-127)/128;
											} else if (_normalColorZ<127) {
												_normalZVectorZ = (_normalColorZ-127)/127;
											} else {
												_normalZVectorZ = 0;
											}
											
											_pixelScreenVector.x = _normalZVectorX*_tangentMatrix.a+_normalZVectorY*_tangentMatrix.b+_normalZVectorZ*_tangentMatrix.c;
											_pixelScreenVector.y = _normalZVectorX*_tangentMatrix.d+_normalZVectorY*_tangentMatrix.e+_normalZVectorZ*_tangentMatrix.f;
											_pixelScreenVector.z = _normalZVectorX*_tangentMatrix.g+_normalZVectorY*_tangentMatrix.h+_normalZVectorZ*_tangentMatrix.i;
										} else if (_shadingType == SHADING_PHONG) {
											_count = 0;
											//0
											_phongY = _phongLineValue1;
											if (_phongY != 0) {
												_phongK1 = (firstY-_pixelScreenVertex.screenY)/_phongY;
												if (_phongK1>=0 && _phongK1<=1) {
													_count++;
													_phongK2 = 1-_phongK1;
													_phongX = firstX-_phongK1*_phongLineValue0;
													if (_count == 1) {
														_phongFirstX = _phongX;
														_phongFirstVectorX = _firstVector.x*_phongK2+_secondVector.x*_phongK1;
														_phongFirstVectorY = _firstVector.y*_phongK2+_secondVector.y*_phongK1;
														_phongFirstVectorZ = _firstVector.z*_phongK2+_secondVector.z*_phongK1;
														//1
														_phongY = _phongLineValue3;
														if (_phongY != 0) {
															_phongK1 = (secondY-_pixelScreenVertex.screenY)/_phongY;
															if (_phongK1>=0 && _phongK1<=1) {
																_count++;
																_phongK2 = 1-_phongK1;
																_phongX = secondX-_phongK1*_phongLineValue2;
																if (_count == 1) {
																	_phongFirstX = _phongX;
																	_phongFirstVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
																	_phongFirstVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
																	_phongFirstVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
																	//2
																	_phongY = _phongLineValue5;
																	if (_phongY != 0) {
																		_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
																		if (_phongK1>=0 && _phongK1<=1) {
																			_count++;
																			_phongK2 = 1-_phongK1;
																			_phongX = lastX-_phongK1*_phongLineValue4;
																			if (_count == 1) {
																				_phongFirstX = _phongX;
																				_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																				_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																				_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																			} else {
																				_phongSecondX = _phongX;
																				_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																				_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																				_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																			}
																		}
																	}
																} else {
																	_phongSecondX = _phongX;
																	_phongSecondVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
																	_phongSecondVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
																	_phongSecondVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
																}
															} else {
																//2
																_phongY = _phongLineValue5;
																if (_phongY != 0) {
																	_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
																	if (_phongK1>=0 && _phongK1<=1) {
																		_count++;
																		_phongK2 = 1-_phongK1;
																		_phongX = lastX-_phongK1*_phongLineValue4;
																		if (_count == 1) {
																			_phongFirstX = _phongX;
																			_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																			_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																			_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																		} else {
																			_phongSecondX = _phongX;
																			_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																			_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																			_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																		}
																	}
																}
															}
														} else {
															//2
															_phongY = _phongLineValue5;
															if (_phongY != 0) {
																_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
																if (_phongK1>=0 && _phongK1<=1) {
																	_count++;
																	_phongK2 = 1-_phongK1;
																	_phongX = lastX-_phongK1*_phongLineValue4;
																	if (_count == 1) {
																		_phongFirstX = _phongX;
																		_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																		_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																		_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																	} else {
																		_phongSecondX = _phongX;
																		_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																		_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																		_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																	}
																}
															}
														}
													} else {
														_phongSecondX = _phongX;
														_phongSecondVectorX = _firstVector.x*_phongK2+_secondVector.x*_phongK1;
														_phongSecondVectorY = _firstVector.y*_phongK2+_secondVector.y*_phongK1;
														_phongSecondVectorZ = _firstVector.z*_phongK2+_secondVector.z*_phongK1;
													}
												} else {
													//1
													_phongY = _phongLineValue3;
													if (_phongY != 0) {
														_phongK1 = (secondY-_pixelScreenVertex.screenY)/_phongY;
														if (_phongK1>=0 && _phongK1<=1) {
															_count++;
															_phongK2 = 1-_phongK1;
															_phongX = secondX-_phongK1*_phongLineValue2;
															if (_count == 1) {
																_phongFirstX = _phongX;
																_phongFirstVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
																_phongFirstVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
																_phongFirstVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
																//2
																_phongY = _phongLineValue5;
																if (_phongY != 0) {
																	_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
																	if (_phongK1>=0 && _phongK1<=1) {
																		_count++;
																		_phongK2 = 1-_phongK1;
																		_phongX = lastX-_phongK1*_phongLineValue4;
																		if (_count == 1) {
																			_phongFirstX = _phongX;
																			_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																			_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																			_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																		} else {
																			_phongSecondX = _phongX;
																			_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																			_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																			_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																		}
																	}
																}
															} else {
																_phongSecondX = _phongX;
																_phongSecondVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
																_phongSecondVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
																_phongSecondVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
															}
														} else {
															//2
															_phongY = _phongLineValue5;
															if (_phongY != 0) {
																_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
																if (_phongK1>=0 && _phongK1<=1) {
																	_count++;
																	_phongK2 = 1-_phongK1;
																	_phongX = lastX-_phongK1*_phongLineValue4;
																	if (_count == 1) {
																		_phongFirstX = _phongX;
																		_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																		_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																		_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																	} else {
																		_phongSecondX = _phongX;
																		_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																		_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																		_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																	}
																}
															}
														}
													} else {
														//2
														_phongY = _phongLineValue5;
														if (_phongY != 0) {
															_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
															if (_phongK1>=0 && _phongK1<=1) {
																_count++;
																_phongK2 = 1-_phongK1;
																_phongX = lastX-_phongK1*_phongLineValue4;
																if (_count == 1) {
																	_phongFirstX = _phongX;
																	_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																} else {
																	_phongSecondX = _phongX;
																	_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																}
															}
														}
													}
												}
											} else {
												//1
												_phongY = _phongLineValue3;
												if (_phongY != 0) {
													_phongK1 = (secondY-_pixelScreenVertex.screenY)/_phongY;
													if (_phongK1>=0 && _phongK1<=1) {
														_count++;
														_phongK2 = 1-_phongK1;
														_phongX = secondX-_phongK1*_phongLineValue2;
														if (_count == 1) {
															_phongFirstX = _phongX;
															_phongFirstVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
															_phongFirstVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
															_phongFirstVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
															//2
															_phongY = _phongLineValue5;
															if (_phongY != 0) {
																_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
																if (_phongK1>=0 && _phongK1<=1) {
																	_count++;
																	_phongK2 = 1-_phongK1;
																	_phongX = lastX-_phongK1*_phongLineValue4;
																	if (_count == 1) {
																		_phongFirstX = _phongX;
																		_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																		_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																		_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																	} else {
																		_phongSecondX = _phongX;
																		_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																		_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																		_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																	}
																}
															}
														} else {
															_phongSecondX = _phongX;
															_phongSecondVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
															_phongSecondVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
															_phongSecondVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
														}
													} else {
														//2
														_phongY = _phongLineValue5;
														if (_phongY != 0) {
															_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
															if (_phongK1>=0 && _phongK1<=1) {
																_count++;
																_phongK2 = 1-_phongK1;
																_phongX = lastX-_phongK1*_phongLineValue4;
																if (_count == 1) {
																	_phongFirstX = _phongX;
																	_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																} else {
																	_phongSecondX = _phongX;
																	_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																}
															}
														}
													}
												} else {
													//2
													_phongY = _phongLineValue5;
													if (_phongY != 0) {
														_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
														if (_phongK1>=0 && _phongK1<=1) {
															_count++;
															_phongK2 = 1-_phongK1;
															_phongX = lastX-_phongK1*_phongLineValue4;
															if (_count == 1) {
																_phongFirstX = _phongX;
																_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
															} else {
																_phongSecondX = _phongX;
																_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
															}
														}
													}
												}
											}
											
											_phongK1 = (_pixelScreenVertex.screenX-_phongSecondX)/(_phongFirstX-_phongSecondX);
											_phongK2 = 1-_phongK1;
											
											_pixelScreenVector.x = _phongFirstVectorX*_phongK1+_phongSecondVectorX*_phongK2;
											_pixelScreenVector.y = _phongFirstVectorY*_phongK1+_phongSecondVectorY*_phongK2;
											_pixelScreenVector.z = _phongFirstVectorZ*_phongK1+_phongSecondVectorZ*_phongK2;
										}
										if (_colorSelfLuminationEnabled) _color = Color.colorBlend(_selfLuminationColor, _color);
										
										_strength = 0;
										_useBlendColor = false;
										if (_shadingType == SHADING_GOURAUD) {
											_useBlendColor = _gouraudUseBlendColor;
											_strength = _gouraudStrength;
											for (i = 0; i<totalLights; i++) {
												_light = lightListArray[i];
												_light.lightingTest(_pixelScreenVertex, _pixelScreenVector);
												_strengthRatio = _light.strengthRatio;
												if (_strengthRatio<0) _strengthRatio = _doubleSidedLightEnabled ? -_strengthRatio : 0;
												if (_light.hasShadow) {
													_shadowRedRatio = _light._shadow.redRatio;
													_shadowGreenRatio = _light._shadow.greenRatio;
													_shadowBlueRatio = _light._shadow.blueRatio;
													if (_shadowRedRatio == 1 && _shadowGreenRatio == 1 && _shadowBlueRatio == 1) {
														_strength -= _light.strength*_strengthRatio*_lightingReflectionRadio;
														continue;
													}
												}
												_lightStrength = _light.strength*_strengthRatio*_lightingReflectionRadio;
												if (_light.colorLightingEnabled) {
													if (_light.hasShadow) {
														_shadowAlphaRatio = _light.shadow.alphaRatio;
														_blendColor = ((_blendColor>>24&0xFF)*(1-_shadowAlphaRatio)+255*_shadowAlphaRatio)<<24|((_blendColor>>16&0xFF)*_shadowRedRatio)<<16|((_blendColor>>8&0xFF)*_shadowGreenRatio)<<8|((_blendColor&0xFF)*_shadowBlueRatio);
													}
												} else if (_light.hasShadow) {
													_blendColor = (_lightStrength*_light._shadow.alphaRatio*255)<<24|(_shadowRedRatio*255)<<16|(_shadowGreenRatio*255)<<8|(_shadowBlueRatio*255);
													_useBlendColor = true;
												}
											}
											if (_strength<0) _strength = 0;
										} else {
											for (i = 0; i<totalLights; i++) {
												_light = lightListArray[i];
												_light.lightingTest(_pixelScreenVertex, _pixelScreenVector);
												if (_light.hasShadow) {
													_shadowRedRatio = _light._shadow.redRatio;
													_shadowGreenRatio = _light._shadow.greenRatio;
													_shadowBlueRatio = _light._shadow.blueRatio;
													if (_shadowRedRatio == 1 && _shadowGreenRatio == 1 && _shadowBlueRatio == 1) continue;
												}
												_strengthRatio = _light.strengthRatio;
												if (_strengthRatio<0) _strengthRatio = _doubleSidedLightEnabled ? -_strengthRatio : 0;
												_lightStrength = _light.strength*_strengthRatio*_lightingReflectionRadio;
												_strength += _lightStrength;
												if (_light.colorLightingEnabled) {
													_tempColor = _light.lightingColor;
													_tempColor = ((_tempColor>>24&0xFF)*_light.strength*_strengthRatio)<<24|_tempColor&0xFFFFFF;
													if (_useBlendColor) {
														_blendColor = Color.colorBlend(_tempColor, _blendColor);
													} else {
														_blendColor = _tempColor;
														_useBlendColor = true;
													}
													if (_light.hasShadow) {
														_shadowAlphaRatio = _light.shadow.alphaRatio;
														_blendColor = ((_blendColor>>24&0xFF)*(1-_shadowAlphaRatio)+255*_shadowAlphaRatio)<<24|((_blendColor>>16&0xFF)*_shadowRedRatio)<<16|((_blendColor>>8&0xFF)*_shadowGreenRatio)<<8|((_blendColor&0xFF)*_shadowBlueRatio);
													}
												} else if (_light.hasShadow) {
													_blendColor = (_lightStrength*_light._shadow.alphaRatio*255)<<24|(_shadowRedRatio*255)<<16|(_shadowGreenRatio*255)<<8|(_shadowBlueRatio*255);
													_useBlendColor = true;
												}
											}
										}
										if (specularTextureEnabled) {
											_specularColor = _specularBitmapData.getPixel(_specularTextureWidth*_textureU, _specularTextureHeight*_textureV);
											_strength *= 1+((_specularColor>>16&0xFF)+(_specularColor>>8&0xFF)+(_specularColor&0xFF))/765;
										}
										if (_strength>1) _strength = 1;
										if (lightingStrengthTextureEnabled) {
											_lightingStrengthColor = _lightingStrengthBitmapData.getPixel(_lightingStrengthTextureWidth*_strength, 0);
											_strength = ((_lightingStrengthColor>>16&0xFF)+(_lightingStrengthColor>>8&0xFF)+(_lightingStrengthColor&0xFF))/765;
										}
										_brightness = _strength*(1-_selfLuminationStrength)+_selfLuminationStrength;
										if (_brightness != 0.5) {
											_colorRed = _color>>16&0xFF;
											_colorGreen = _color>>8&0xFF;
											_colorBlue = _color&0xFF;
											if (_brightness>0.5) {
												_brightness = _brightness*2-1;
												_colorRed += (255-_colorRed)*_brightness;
												_colorGreen += (255-_colorGreen)*_brightness;
												_colorBlue += (255-_colorBlue)*_brightness;
											} else {
												_brightness *= 2;
												_colorRed *= _brightness;
												_colorGreen *= _brightness;
												_colorBlue *= _brightness;
											}
											_color = _color&0xFF000000|_colorRed<<16|_colorGreen<<8|_colorBlue;
										}
										if (_useBlendColor) _color = Color.colorBlend(_color, _blendColor);
										
										_info.opaqueColor = _color;
										_info.opaqueColorDepth = _depth;
											
										sourceBitmapData.setPixel32(_nx, -ny, _color);
									}
								} else if (_depth<_info.alphaColorList[1]) {
									//No2
									if (bumpTextureEnabled) {
										_bumpX = _bumpTextureWidth*_textureU;
										_bumpY = _bumpTextureHeight*_textureV;
										_bumpkx = (_bumpBitmapData.getPixel((_bumpX == 0 ? _bumpX : _bumpX-1), _bumpY)-_bumpBitmapData.getPixel((_bumpX == _bumpTextureWidth ? _bumpX : _bumpX+1), _bumpY))/16777215;
										_bumpky = (_bumpBitmapData.getPixel(_bumpX, (_bumpY == 0 ? _bumpY : _bumpY-1))-_bumpBitmapData.getPixel(_bumpX, (_bumpY == _bumpTextureHeight ? _bumpY : _bumpY+1)))/16777215;
										
										_tempMatrix.copy(_tangentMatrix);
										_tempMatrix.rotationY = 90*_bumpkx;
										_tempMatrix.rotationX = 90*_bumpky;
										
										_pixelScreenVector.x = _tempMatrix.c;
										_pixelScreenVector.y = _tempMatrix.f;
										_pixelScreenVector.z = _tempMatrix.i;
									} else if (normalTextureEnabled) {
										_normalColor = _normalBitmapData.getPixel(_normalTextureWidth*_textureU, _normalTextureHeight*_textureV);
										_normalColorX = _normalColor>>16&0xFF;
										_normalColorY = _normalColor>>8&0xFF;
										_normalColorZ = _normalColor&0xFF;
										if (_normalColorX>127) {
											_normalZVectorX = (_normalColorX-127)/128;
										} else if (_normalColorX<127) {
											_normalZVectorX = (_normalColorX-127)/127;
										} else {
											_normalZVectorX = 0;
										}
										if (_normalColorY>127) {
											_normalZVectorY = (_normalColorY-127)/128;
										} else if (_normalColorY<127) {
											_normalZVectorY = (_normalColorY-127)/127;
										} else {
											_normalZVectorY = 0;
										}
										if (_normalColorZ>127) {
											_normalZVectorZ = (_normalColorZ-127)/128;
										} else if (_normalColorZ<127) {
											_normalZVectorZ = (_normalColorZ-127)/127;
										} else {
											_normalZVectorZ = 0;
										}
										
										_pixelScreenVector.x = _normalZVectorX*_tangentMatrix.a+_normalZVectorY*_tangentMatrix.b+_normalZVectorZ*_tangentMatrix.c;
										_pixelScreenVector.y = _normalZVectorX*_tangentMatrix.d+_normalZVectorY*_tangentMatrix.e+_normalZVectorZ*_tangentMatrix.f;
										_pixelScreenVector.z = _normalZVectorX*_tangentMatrix.g+_normalZVectorY*_tangentMatrix.h+_normalZVectorZ*_tangentMatrix.i;
									} else if (_shadingType == SHADING_PHONG) {
										_count = 0;
										//0
										_phongY = _phongLineValue1;
										if (_phongY != 0) {
											_phongK1 = (firstY-_pixelScreenVertex.screenY)/_phongY;
											if (_phongK1>=0 && _phongK1<=1) {
												_count++;
												_phongK2 = 1-_phongK1;
												_phongX = firstX-_phongK1*_phongLineValue0;
												if (_count == 1) {
													_phongFirstX = _phongX;
													_phongFirstVectorX = _firstVector.x*_phongK2+_secondVector.x*_phongK1;
													_phongFirstVectorY = _firstVector.y*_phongK2+_secondVector.y*_phongK1;
													_phongFirstVectorZ = _firstVector.z*_phongK2+_secondVector.z*_phongK1;
													//1
													_phongY = _phongLineValue3;
													if (_phongY != 0) {
														_phongK1 = (secondY-_pixelScreenVertex.screenY)/_phongY;
														if (_phongK1>=0 && _phongK1<=1) {
															_count++;
															_phongK2 = 1-_phongK1;
															_phongX = secondX-_phongK1*_phongLineValue2;
															if (_count == 1) {
																_phongFirstX = _phongX;
																_phongFirstVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
																_phongFirstVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
																_phongFirstVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
																//2
																_phongY = _phongLineValue5;
																if (_phongY != 0) {
																	_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
																	if (_phongK1>=0 && _phongK1<=1) {
																		_count++;
																		_phongK2 = 1-_phongK1;
																		_phongX = lastX-_phongK1*_phongLineValue4;
																		if (_count == 1) {
																			_phongFirstX = _phongX;
																			_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																			_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																			_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																		} else {
																			_phongSecondX = _phongX;
																			_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																			_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																			_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																		}
																	}
																}
															} else {
																_phongSecondX = _phongX;
																_phongSecondVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
																_phongSecondVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
																_phongSecondVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
															}
														} else {
															//2
															_phongY = _phongLineValue5;
															if (_phongY != 0) {
																_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
																if (_phongK1>=0 && _phongK1<=1) {
																	_count++;
																	_phongK2 = 1-_phongK1;
																	_phongX = lastX-_phongK1*_phongLineValue4;
																	if (_count == 1) {
																		_phongFirstX = _phongX;
																		_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																		_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																		_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																	} else {
																		_phongSecondX = _phongX;
																		_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																		_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																		_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																	}
																}
															}
														}
													} else {
														//2
														_phongY = _phongLineValue5;
														if (_phongY != 0) {
															_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
															if (_phongK1>=0 && _phongK1<=1) {
																_count++;
																_phongK2 = 1-_phongK1;
																_phongX = lastX-_phongK1*_phongLineValue4;
																if (_count == 1) {
																	_phongFirstX = _phongX;
																	_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																} else {
																	_phongSecondX = _phongX;
																	_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																}
															}
														}
													}
												} else {
													_phongSecondX = _phongX;
													_phongSecondVectorX = _firstVector.x*_phongK2+_secondVector.x*_phongK1;
													_phongSecondVectorY = _firstVector.y*_phongK2+_secondVector.y*_phongK1;
													_phongSecondVectorZ = _firstVector.z*_phongK2+_secondVector.z*_phongK1;
												}
											} else {
												//1
												_phongY = _phongLineValue3;
												if (_phongY != 0) {
													_phongK1 = (secondY-_pixelScreenVertex.screenY)/_phongY;
													if (_phongK1>=0 && _phongK1<=1) {
														_count++;
														_phongK2 = 1-_phongK1;
														_phongX = secondX-_phongK1*_phongLineValue2;
														if (_count == 1) {
															_phongFirstX = _phongX;
															_phongFirstVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
															_phongFirstVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
															_phongFirstVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
															//2
															_phongY = _phongLineValue5;
															if (_phongY != 0) {
																_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
																if (_phongK1>=0 && _phongK1<=1) {
																	_count++;
																	_phongK2 = 1-_phongK1;
																	_phongX = lastX-_phongK1*_phongLineValue4;
																	if (_count == 1) {
																		_phongFirstX = _phongX;
																		_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																		_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																		_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																	} else {
																		_phongSecondX = _phongX;
																		_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																		_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																		_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																	}
																}
															}
														} else {
															_phongSecondX = _phongX;
															_phongSecondVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
															_phongSecondVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
															_phongSecondVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
														}
													} else {
														//2
														_phongY = _phongLineValue5;
														if (_phongY != 0) {
															_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
															if (_phongK1>=0 && _phongK1<=1) {
																_count++;
																_phongK2 = 1-_phongK1;
																_phongX = lastX-_phongK1*_phongLineValue4;
																if (_count == 1) {
																	_phongFirstX = _phongX;
																	_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																} else {
																	_phongSecondX = _phongX;
																	_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																}
															}
														}
													}
												} else {
													//2
													_phongY = _phongLineValue5;
													if (_phongY != 0) {
														_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
														if (_phongK1>=0 && _phongK1<=1) {
															_count++;
															_phongK2 = 1-_phongK1;
															_phongX = lastX-_phongK1*_phongLineValue4;
															if (_count == 1) {
																_phongFirstX = _phongX;
																_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
															} else {
																_phongSecondX = _phongX;
																_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
															}
														}
													}
												}
											}
										} else {
											//1
											_phongY = _phongLineValue3;
											if (_phongY != 0) {
												_phongK1 = (secondY-_pixelScreenVertex.screenY)/_phongY;
												if (_phongK1>=0 && _phongK1<=1) {
													_count++;
													_phongK2 = 1-_phongK1;
													_phongX = secondX-_phongK1*_phongLineValue2;
													if (_count == 1) {
														_phongFirstX = _phongX;
														_phongFirstVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
														_phongFirstVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
														_phongFirstVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
														//2
														_phongY = _phongLineValue5;
														if (_phongY != 0) {
															_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
															if (_phongK1>=0 && _phongK1<=1) {
																_count++;
																_phongK2 = 1-_phongK1;
																_phongX = lastX-_phongK1*_phongLineValue4;
																if (_count == 1) {
																	_phongFirstX = _phongX;
																	_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																} else {
																	_phongSecondX = _phongX;
																	_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																}
															}
														}
													} else {
														_phongSecondX = _phongX;
														_phongSecondVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
														_phongSecondVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
														_phongSecondVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
													}
												} else {
													//2
													_phongY = _phongLineValue5;
													if (_phongY != 0) {
														_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
														if (_phongK1>=0 && _phongK1<=1) {
															_count++;
															_phongK2 = 1-_phongK1;
															_phongX = lastX-_phongK1*_phongLineValue4;
															if (_count == 1) {
																_phongFirstX = _phongX;
																_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
															} else {
																_phongSecondX = _phongX;
																_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
															}
														}
													}
												}
											} else {
												//2
												_phongY = _phongLineValue5;
												if (_phongY != 0) {
													_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
													if (_phongK1>=0 && _phongK1<=1) {
														_count++;
														_phongK2 = 1-_phongK1;
														_phongX = lastX-_phongK1*_phongLineValue4;
														if (_count == 1) {
															_phongFirstX = _phongX;
															_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
															_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
															_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
														} else {
															_phongSecondX = _phongX;
															_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
															_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
															_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
														}
													}
												}
											}
										}
										
										_phongK1 = (_pixelScreenVertex.screenX-_phongSecondX)/(_phongFirstX-_phongSecondX);
										_phongK2 = 1-_phongK1;
										
										_pixelScreenVector.x = _phongFirstVectorX*_phongK1+_phongSecondVectorX*_phongK2;
										_pixelScreenVector.y = _phongFirstVectorY*_phongK1+_phongSecondVectorY*_phongK2;
										_pixelScreenVector.z = _phongFirstVectorZ*_phongK1+_phongSecondVectorZ*_phongK2;
									}
										
									if (_colorSelfLuminationEnabled) _color = Color.colorBlend(_selfLuminationColor, _color);
									
									_strength = 0;
									_useBlendColor = false;
									if (_shadingType == SHADING_GOURAUD) {
										_useBlendColor = _gouraudUseBlendColor;
										_strength = _gouraudStrength;
										for (i = 0; i<totalLights; i++) {
											_light = lightListArray[i];
											_light.lightingTest(_pixelScreenVertex, _pixelScreenVector);
											_strengthRatio = _light.strengthRatio;
											if (_strengthRatio<0) _strengthRatio = _doubleSidedLightEnabled ? -_strengthRatio : 0;
											if (_light.hasShadow) {
												_shadowRedRatio = _light._shadow.redRatio;
												_shadowGreenRatio = _light._shadow.greenRatio;
												_shadowBlueRatio = _light._shadow.blueRatio;
												if (_shadowRedRatio == 1 && _shadowGreenRatio == 1 && _shadowBlueRatio == 1) {
													_strength -= _light.strength*_strengthRatio*_lightingReflectionRadio;
													continue;
												}
											}
											_lightStrength = _light.strength*_strengthRatio*_lightingReflectionRadio;
											if (_light.colorLightingEnabled) {
												if (_light.hasShadow) {
													_shadowAlphaRatio = _light.shadow.alphaRatio;
													_blendColor = ((_blendColor>>24&0xFF)*(1-_shadowAlphaRatio)+255*_shadowAlphaRatio)<<24|((_blendColor>>16&0xFF)*_shadowRedRatio)<<16|((_blendColor>>8&0xFF)*_shadowGreenRatio)<<8|((_blendColor&0xFF)*_shadowBlueRatio);
												}
											} else if (_light.hasShadow) {
												_blendColor = (_lightStrength*_light._shadow.alphaRatio*255)<<24|(_shadowRedRatio*255)<<16|(_shadowGreenRatio*255)<<8|(_shadowBlueRatio*255);
												_useBlendColor = true;
											}
										}
										if (_strength<0) _strength = 0;
									} else {
										for (i = 0; i<totalLights; i++) {
											_light = lightListArray[i];
											_light.lightingTest(_pixelScreenVertex, _pixelScreenVector);
											if (_light.hasShadow) {
												_shadowRedRatio = _light._shadow.redRatio;
												_shadowGreenRatio = _light._shadow.greenRatio;
												_shadowBlueRatio = _light._shadow.blueRatio;
												if (_shadowRedRatio == 1 && _shadowGreenRatio == 1 && _shadowBlueRatio == 1) continue;
											}
											_strengthRatio = _light.strengthRatio;
											if (_strengthRatio<0) _strengthRatio = _doubleSidedLightEnabled ? -_strengthRatio : 0;
											_lightStrength = _light.strength*_strengthRatio*_lightingReflectionRadio;
											_strength += _lightStrength;
											if (_light.colorLightingEnabled) {
												_tempColor = _light.lightingColor;
												_tempColor = ((_tempColor>>24&0xFF)*_light.strength*_strengthRatio)<<24|_tempColor&0xFFFFFF;
												if (_useBlendColor) {
													_blendColor = Color.colorBlend(_tempColor, _blendColor);
												} else {
													_blendColor = _tempColor;
													_useBlendColor = true;
												}
												if (_light.hasShadow) {
													_shadowAlphaRatio = _light.shadow.alphaRatio;
													_blendColor = ((_blendColor>>24&0xFF)*(1-_shadowAlphaRatio)+255*_shadowAlphaRatio)<<24|((_blendColor>>16&0xFF)*_shadowRedRatio)<<16|((_blendColor>>8&0xFF)*_shadowGreenRatio)<<8|((_blendColor&0xFF)*_shadowBlueRatio);
												}
											} else if (_light.hasShadow) {
												_blendColor = (_lightStrength*_light._shadow.alphaRatio*255)<<24|(_shadowRedRatio*255)<<16|(_shadowGreenRatio*255)<<8|(_shadowBlueRatio*255);
												_useBlendColor = true;
											}
										}
									}
									if (specularTextureEnabled) {
										_specularColor = _specularBitmapData.getPixel(_specularTextureWidth*_textureU, _specularTextureHeight*_textureV);
										_strength *= 1+((_specularColor>>16&0xFF)+(_specularColor>>8&0xFF)+(_specularColor&0xFF))/765;
									}
									if (_strength>1) _strength = 1;
									if (lightingStrengthTextureEnabled) {
										_lightingStrengthColor = _lightingStrengthBitmapData.getPixel(_lightingStrengthTextureWidth*_strength, 0);
										_strength = ((_lightingStrengthColor>>16&0xFF)+(_lightingStrengthColor>>8&0xFF)+(_lightingStrengthColor&0xFF))/765;
									}
									_brightness = _strength*(1-_selfLuminationStrength)+_selfLuminationStrength;
									if (_brightness != 0.5) {
										_colorRed = _color>>16&0xFF;
										_colorGreen = _color>>8&0xFF;
										_colorBlue = _color&0xFF;
										if (_brightness>0.5) {
											_brightness = _brightness*2-1;
											_colorRed += (255-_colorRed)*_brightness;
											_colorGreen += (255-_colorGreen)*_brightness;
											_colorBlue += (255-_colorBlue)*_brightness;
										} else {
											_brightness *= 2;
											_colorRed *= _brightness;
											_colorGreen *= _brightness;
											_colorBlue *= _brightness;
										}
										_color = _color&0xFF000000|_colorRed<<16|_colorGreen<<8|_colorBlue;
									}
									if (_useBlendColor) _color = Color.colorBlend(_color, _blendColor);
									
									_info.alphaColorList = null;
									_info.opaqueColor = _color;
									_info.opaqueColorDepth = _depth;
									_info.useOpaqueColor = true;
									
									sourceBitmapData.setPixel32(_nx, -ny, _color);
								} else if (!_info.useOpaqueColor || _depth<_info.opaqueColorDepth) {
									//No3
									if (bumpTextureEnabled) {
										_bumpX = _bumpTextureWidth*_textureU;
										_bumpY = _bumpTextureHeight*_textureV;
										_bumpkx = (_bumpBitmapData.getPixel((_bumpX == 0 ? _bumpX : _bumpX-1), _bumpY)-_bumpBitmapData.getPixel((_bumpX == _bumpTextureWidth ? _bumpX : _bumpX+1), _bumpY))/16777215;
										_bumpky = (_bumpBitmapData.getPixel(_bumpX, (_bumpY == 0 ? _bumpY : _bumpY-1))-_bumpBitmapData.getPixel(_bumpX, (_bumpY == _bumpTextureHeight ? _bumpY : _bumpY+1)))/16777215;
										
										_tempMatrix.copy(_tangentMatrix);
										_tempMatrix.rotationY = 90*_bumpkx;
										_tempMatrix.rotationX = 90*_bumpky;
										
										_pixelScreenVector.x = _tempMatrix.c;
										_pixelScreenVector.y = _tempMatrix.f;
										_pixelScreenVector.z = _tempMatrix.i;
									} else if (normalTextureEnabled) {
										_normalColor = _normalBitmapData.getPixel(_normalTextureWidth*_textureU, _normalTextureHeight*_textureV);
										_normalColorX = _normalColor>>16&0xFF;
										_normalColorY = _normalColor>>8&0xFF;
										_normalColorZ = _normalColor&0xFF;
										if (_normalColorX>127) {
											_normalZVectorX = (_normalColorX-127)/128;
										} else if (_normalColorX<127) {
											_normalZVectorX = (_normalColorX-127)/127;
										} else {
											_normalZVectorX = 0;
										}
										if (_normalColorY>127) {
											_normalZVectorY = (_normalColorY-127)/128;
										} else if (_normalColorY<127) {
											_normalZVectorY = (_normalColorY-127)/127;
										} else {
											_normalZVectorY = 0;
										}
										if (_normalColorZ>127) {
											_normalZVectorZ = (_normalColorZ-127)/128;
										} else if (_normalColorZ<127) {
											_normalZVectorZ = (_normalColorZ-127)/127;
										} else {
											_normalZVectorZ = 0;
										}
										
										_pixelScreenVector.x = _normalZVectorX*_tangentMatrix.a+_normalZVectorY*_tangentMatrix.b+_normalZVectorZ*_tangentMatrix.c;
										_pixelScreenVector.y = _normalZVectorX*_tangentMatrix.d+_normalZVectorY*_tangentMatrix.e+_normalZVectorZ*_tangentMatrix.f;
										_pixelScreenVector.z = _normalZVectorX*_tangentMatrix.g+_normalZVectorY*_tangentMatrix.h+_normalZVectorZ*_tangentMatrix.i;
									} else if (_shadingType == SHADING_PHONG) {
										_count = 0;
										//0
										_phongY = _phongLineValue1;
										if (_phongY != 0) {
											_phongK1 = (firstY-_pixelScreenVertex.screenY)/_phongY;
											if (_phongK1>=0 && _phongK1<=1) {
												_count++;
												_phongK2 = 1-_phongK1;
												_phongX = firstX-_phongK1*_phongLineValue0;
												if (_count == 1) {
													_phongFirstX = _phongX;
													_phongFirstVectorX = _firstVector.x*_phongK2+_secondVector.x*_phongK1;
													_phongFirstVectorY = _firstVector.y*_phongK2+_secondVector.y*_phongK1;
													_phongFirstVectorZ = _firstVector.z*_phongK2+_secondVector.z*_phongK1;
													//1
													_phongY = _phongLineValue3;
													if (_phongY != 0) {
														_phongK1 = (secondY-_pixelScreenVertex.screenY)/_phongY;
														if (_phongK1>=0 && _phongK1<=1) {
															_count++;
															_phongK2 = 1-_phongK1;
															_phongX = secondX-_phongK1*_phongLineValue2;
															if (_count == 1) {
																_phongFirstX = _phongX;
																_phongFirstVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
																_phongFirstVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
																_phongFirstVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
																//2
																_phongY = _phongLineValue5;
																if (_phongY != 0) {
																	_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
																	if (_phongK1>=0 && _phongK1<=1) {
																		_count++;
																		_phongK2 = 1-_phongK1;
																		_phongX = lastX-_phongK1*_phongLineValue4;
																		if (_count == 1) {
																			_phongFirstX = _phongX;
																			_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																			_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																			_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																		} else {
																			_phongSecondX = _phongX;
																			_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																			_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																			_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																		}
																	}
																}
															} else {
																_phongSecondX = _phongX;
																_phongSecondVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
																_phongSecondVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
																_phongSecondVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
															}
														} else {
															//2
															_phongY = _phongLineValue5;
															if (_phongY != 0) {
																_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
																if (_phongK1>=0 && _phongK1<=1) {
																	_count++;
																	_phongK2 = 1-_phongK1;
																	_phongX = lastX-_phongK1*_phongLineValue4;
																	if (_count == 1) {
																		_phongFirstX = _phongX;
																		_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																		_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																		_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																	} else {
																		_phongSecondX = _phongX;
																		_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																		_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																		_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																	}
																}
															}
														}
													} else {
														//2
														_phongY = _phongLineValue5;
														if (_phongY != 0) {
															_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
															if (_phongK1>=0 && _phongK1<=1) {
																_count++;
																_phongK2 = 1-_phongK1;
																_phongX = lastX-_phongK1*_phongLineValue4;
																if (_count == 1) {
																	_phongFirstX = _phongX;
																	_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																} else {
																	_phongSecondX = _phongX;
																	_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																}
															}
														}
													}
												} else {
													_phongSecondX = _phongX;
													_phongSecondVectorX = _firstVector.x*_phongK2+_secondVector.x*_phongK1;
													_phongSecondVectorY = _firstVector.y*_phongK2+_secondVector.y*_phongK1;
													_phongSecondVectorZ = _firstVector.z*_phongK2+_secondVector.z*_phongK1;
												}
											} else {
												//1
												_phongY = _phongLineValue3;
												if (_phongY != 0) {
													_phongK1 = (secondY-_pixelScreenVertex.screenY)/_phongY;
													if (_phongK1>=0 && _phongK1<=1) {
														_count++;
														_phongK2 = 1-_phongK1;
														_phongX = secondX-_phongK1*_phongLineValue2;
														if (_count == 1) {
															_phongFirstX = _phongX;
															_phongFirstVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
															_phongFirstVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
															_phongFirstVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
															//2
															_phongY = _phongLineValue5;
															if (_phongY != 0) {
																_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
																if (_phongK1>=0 && _phongK1<=1) {
																	_count++;
																	_phongK2 = 1-_phongK1;
																	_phongX = lastX-_phongK1*_phongLineValue4;
																	if (_count == 1) {
																		_phongFirstX = _phongX;
																		_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																		_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																		_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																	} else {
																		_phongSecondX = _phongX;
																		_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																		_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																		_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																	}
																}
															}
														} else {
															_phongSecondX = _phongX;
															_phongSecondVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
															_phongSecondVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
															_phongSecondVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
														}
													} else {
														//2
														_phongY = _phongLineValue5;
														if (_phongY != 0) {
															_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
															if (_phongK1>=0 && _phongK1<=1) {
																_count++;
																_phongK2 = 1-_phongK1;
																_phongX = lastX-_phongK1*_phongLineValue4;
																if (_count == 1) {
																	_phongFirstX = _phongX;
																	_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																} else {
																	_phongSecondX = _phongX;
																	_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																}
															}
														}
													}
												} else {
													//2
													_phongY = _phongLineValue5;
													if (_phongY != 0) {
														_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
														if (_phongK1>=0 && _phongK1<=1) {
															_count++;
															_phongK2 = 1-_phongK1;
															_phongX = lastX-_phongK1*_phongLineValue4;
															if (_count == 1) {
																_phongFirstX = _phongX;
																_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
															} else {
																_phongSecondX = _phongX;
																_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
															}
														}
													}
												}
											}
										} else {
											//1
											_phongY = _phongLineValue3;
											if (_phongY != 0) {
												_phongK1 = (secondY-_pixelScreenVertex.screenY)/_phongY;
												if (_phongK1>=0 && _phongK1<=1) {
													_count++;
													_phongK2 = 1-_phongK1;
													_phongX = secondX-_phongK1*_phongLineValue2;
													if (_count == 1) {
														_phongFirstX = _phongX;
														_phongFirstVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
														_phongFirstVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
														_phongFirstVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
														//2
														_phongY = _phongLineValue5;
														if (_phongY != 0) {
															_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
															if (_phongK1>=0 && _phongK1<=1) {
																_count++;
																_phongK2 = 1-_phongK1;
																_phongX = lastX-_phongK1*_phongLineValue4;
																if (_count == 1) {
																	_phongFirstX = _phongX;
																	_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																} else {
																	_phongSecondX = _phongX;
																	_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																}
															}
														}
													} else {
														_phongSecondX = _phongX;
														_phongSecondVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
														_phongSecondVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
														_phongSecondVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
													}
												} else {
													//2
													_phongY = _phongLineValue5;
													if (_phongY != 0) {
														_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
														if (_phongK1>=0 && _phongK1<=1) {
															_count++;
															_phongK2 = 1-_phongK1;
															_phongX = lastX-_phongK1*_phongLineValue4;
															if (_count == 1) {
																_phongFirstX = _phongX;
																_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
															} else {
																_phongSecondX = _phongX;
																_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
															}
														}
													}
												}
											} else {
												//2
												_phongY = _phongLineValue5;
												if (_phongY != 0) {
													_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
													if (_phongK1>=0 && _phongK1<=1) {
														_count++;
														_phongK2 = 1-_phongK1;
														_phongX = lastX-_phongK1*_phongLineValue4;
														if (_count == 1) {
															_phongFirstX = _phongX;
															_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
															_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
															_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
														} else {
															_phongSecondX = _phongX;
															_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
															_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
															_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
														}
													}
												}
											}
										}
										
										_phongK1 = (_pixelScreenVertex.screenX-_phongSecondX)/(_phongFirstX-_phongSecondX);
										_phongK2 = 1-_phongK1;
										
										_pixelScreenVector.x = _phongFirstVectorX*_phongK1+_phongSecondVectorX*_phongK2;
										_pixelScreenVector.y = _phongFirstVectorY*_phongK1+_phongSecondVectorY*_phongK2;
										_pixelScreenVector.z = _phongFirstVectorZ*_phongK1+_phongSecondVectorZ*_phongK2;
									}
									
									if (_colorSelfLuminationEnabled) _color = Color.colorBlend(_selfLuminationColor, _color);
									
									_strength = 0;
									_useBlendColor = false;
									if (_shadingType == SHADING_GOURAUD) {
										_useBlendColor = _gouraudUseBlendColor;
										_strength = _gouraudStrength;
										for (i = 0; i<totalLights; i++) {
											_light = lightListArray[i];
											_light.lightingTest(_pixelScreenVertex, _pixelScreenVector);
											_strengthRatio = _light.strengthRatio;
											if (_strengthRatio<0) _strengthRatio = _doubleSidedLightEnabled ? -_strengthRatio : 0;
											if (_light.hasShadow) {
												_shadowRedRatio = _light._shadow.redRatio;
												_shadowGreenRatio = _light._shadow.greenRatio;
												_shadowBlueRatio = _light._shadow.blueRatio;
												if (_shadowRedRatio == 1 && _shadowGreenRatio == 1 && _shadowBlueRatio == 1) {
													_strength -= _light.strength*_strengthRatio*_lightingReflectionRadio;
													continue;
												}
											}
											_lightStrength = _light.strength*_strengthRatio*_lightingReflectionRadio;
											if (_light.colorLightingEnabled) {
												if (_light.hasShadow) {
													_shadowAlphaRatio = _light.shadow.alphaRatio;
													_blendColor = ((_blendColor>>24&0xFF)*(1-_shadowAlphaRatio)+255*_shadowAlphaRatio)<<24|((_blendColor>>16&0xFF)*_shadowRedRatio)<<16|((_blendColor>>8&0xFF)*_shadowGreenRatio)<<8|((_blendColor&0xFF)*_shadowBlueRatio);
												}
											} else if (_light.hasShadow) {
												_blendColor = (_lightStrength*_light._shadow.alphaRatio*255)<<24|(_shadowRedRatio*255)<<16|(_shadowGreenRatio*255)<<8|(_shadowBlueRatio*255);
												_useBlendColor = true;
											}
										}
										if (_strength<0) _strength = 0;
									} else {
										for (i = 0; i<totalLights; i++) {
											_light = lightListArray[i];
											_light.lightingTest(_pixelScreenVertex, _pixelScreenVector);
											if (_light.hasShadow) {
												_shadowRedRatio = _light._shadow.redRatio;
												_shadowGreenRatio = _light._shadow.greenRatio;
												_shadowBlueRatio = _light._shadow.blueRatio;
												if (_shadowRedRatio == 1 && _shadowGreenRatio == 1 && _shadowBlueRatio == 1) continue;
											}
											_strengthRatio = _light.strengthRatio;
											if (_strengthRatio<0) _strengthRatio = _doubleSidedLightEnabled ? -_strengthRatio : 0;
											_lightStrength = _light.strength*_strengthRatio*_lightingReflectionRadio;
											_strength += _lightStrength;
											if (_light.colorLightingEnabled) {
												_tempColor = _light.lightingColor;
												_tempColor = ((_tempColor>>24&0xFF)*_light.strength*_strengthRatio)<<24|_tempColor&0xFFFFFF;
												if (_useBlendColor) {
													_blendColor = Color.colorBlend(_tempColor, _blendColor);
												} else {
													_blendColor = _tempColor;
													_useBlendColor = true;
												}
												if (_light.hasShadow) {
													_shadowAlphaRatio = _light.shadow.alphaRatio;
													_blendColor = ((_blendColor>>24&0xFF)*(1-_shadowAlphaRatio)+255*_shadowAlphaRatio)<<24|((_blendColor>>16&0xFF)*_shadowRedRatio)<<16|((_blendColor>>8&0xFF)*_shadowGreenRatio)<<8|((_blendColor&0xFF)*_shadowBlueRatio);
												}
											} else if (_light.hasShadow) {
												_blendColor = (_lightStrength*_light._shadow.alphaRatio*255)<<24|(_shadowRedRatio*255)<<16|(_shadowGreenRatio*255)<<8|(_shadowBlueRatio*255);
												_useBlendColor = true;
											}
										}
									}
									if (specularTextureEnabled) {
										_specularColor = _specularBitmapData.getPixel(_specularTextureWidth*_textureU, _specularTextureHeight*_textureV);
										_strength *= 1+((_specularColor>>16&0xFF)+(_specularColor>>8&0xFF)+(_specularColor&0xFF))/765;
									}
									if (_strength>1) _strength = 1;
									if (lightingStrengthTextureEnabled) {
										_lightingStrengthColor = _lightingStrengthBitmapData.getPixel(_lightingStrengthTextureWidth*_strength, 0);
										_strength = ((_lightingStrengthColor>>16&0xFF)+(_lightingStrengthColor>>8&0xFF)+(_lightingStrengthColor&0xFF))/765;
									}
									_brightness = _strength*(1-_selfLuminationStrength)+_selfLuminationStrength;
									if (_brightness != 0.5) {
										_colorRed = _color>>16&0xFF;
										_colorGreen = _color>>8&0xFF;
										_colorBlue = _color&0xFF;
										if (_brightness>0.5) {
											_brightness = _brightness*2-1;
											_colorRed += (255-_colorRed)*_brightness;
											_colorGreen += (255-_colorGreen)*_brightness;
											_colorBlue += (255-_colorBlue)*_brightness;
										} else {
											_brightness *= 2;
											_colorRed *= _brightness;
											_colorGreen *= _brightness;
											_colorBlue *= _brightness;
										}
										_color = _color&0xFF000000|_colorRed<<16|_colorGreen<<8|_colorBlue;
									}
									if (_useBlendColor) _color = Color.colorBlend(_color, _blendColor);
									
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
									sourceBitmapData.setPixel32(_nx, -ny, Color.colorBlendWithPixelAlphaColorAndOpaqueColor(_info));
								} else {
									//trace(info.opaqueColor == MAX_NUMBER);
								}
							} else {
								if (!_info.useOpaqueColor) {
									//No4
									if (bumpTextureEnabled) {
										_bumpX = _bumpTextureWidth*_textureU;
										_bumpY = _bumpTextureHeight*_textureV;
										_bumpkx = (_bumpBitmapData.getPixel((_bumpX == 0 ? _bumpX : _bumpX-1), _bumpY)-_bumpBitmapData.getPixel((_bumpX == _bumpTextureWidth ? _bumpX : _bumpX+1), _bumpY))/16777215;
										_bumpky = (_bumpBitmapData.getPixel(_bumpX, (_bumpY == 0 ? _bumpY : _bumpY-1))-_bumpBitmapData.getPixel(_bumpX, (_bumpY == _bumpTextureHeight ? _bumpY : _bumpY+1)))/16777215;
										
										_tempMatrix.copy(_tangentMatrix);
										_tempMatrix.rotationY = 90*_bumpkx;
										_tempMatrix.rotationX = 90*_bumpky;
										
										_pixelScreenVector.x = _tempMatrix.c;
										_pixelScreenVector.y = _tempMatrix.f;
										_pixelScreenVector.z = _tempMatrix.i;
									} else if (normalTextureEnabled) {
										_normalColor = _normalBitmapData.getPixel(_normalTextureWidth*_textureU, _normalTextureHeight*_textureV);
										_normalColorX = _normalColor>>16&0xFF;
										_normalColorY = _normalColor>>8&0xFF;
										_normalColorZ = _normalColor&0xFF;
										if (_normalColorX>127) {
											_normalZVectorX = (_normalColorX-127)/128;
										} else if (_normalColorX<127) {
											_normalZVectorX = (_normalColorX-127)/127;
										} else {
											_normalZVectorX = 0;
										}
										if (_normalColorY>127) {
											_normalZVectorY = (_normalColorY-127)/128;
										} else if (_normalColorY<127) {
											_normalZVectorY = (_normalColorY-127)/127;
										} else {
											_normalZVectorY = 0;
										}
										if (_normalColorZ>127) {
											_normalZVectorZ = (_normalColorZ-127)/128;
										} else if (_normalColorZ<127) {
											_normalZVectorZ = (_normalColorZ-127)/127;
										} else {
											_normalZVectorZ = 0;
										}
										
										_pixelScreenVector.x = _normalZVectorX*_tangentMatrix.a+_normalZVectorY*_tangentMatrix.b+_normalZVectorZ*_tangentMatrix.c;
										_pixelScreenVector.y = _normalZVectorX*_tangentMatrix.d+_normalZVectorY*_tangentMatrix.e+_normalZVectorZ*_tangentMatrix.f;
										_pixelScreenVector.z = _normalZVectorX*_tangentMatrix.g+_normalZVectorY*_tangentMatrix.h+_normalZVectorZ*_tangentMatrix.i;
									} else if (_shadingType == SHADING_PHONG) {
										_count = 0;
										//0
										_phongY = _phongLineValue1;
										if (_phongY != 0) {
											_phongK1 = (firstY-_pixelScreenVertex.screenY)/_phongY;
											if (_phongK1>=0 && _phongK1<=1) {
												_count++;
												_phongK2 = 1-_phongK1;
												_phongX = firstX-_phongK1*_phongLineValue0;
												if (_count == 1) {
													_phongFirstX = _phongX;
													_phongFirstVectorX = _firstVector.x*_phongK2+_secondVector.x*_phongK1;
													_phongFirstVectorY = _firstVector.y*_phongK2+_secondVector.y*_phongK1;
													_phongFirstVectorZ = _firstVector.z*_phongK2+_secondVector.z*_phongK1;
													//1
													_phongY = _phongLineValue3;
													if (_phongY != 0) {
														_phongK1 = (secondY-_pixelScreenVertex.screenY)/_phongY;
														if (_phongK1>=0 && _phongK1<=1) {
															_count++;
															_phongK2 = 1-_phongK1;
															_phongX = secondX-_phongK1*_phongLineValue2;
															if (_count == 1) {
																_phongFirstX = _phongX;
																_phongFirstVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
																_phongFirstVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
																_phongFirstVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
																//2
																_phongY = _phongLineValue5;
																if (_phongY != 0) {
																	_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
																	if (_phongK1>=0 && _phongK1<=1) {
																		_count++;
																		_phongK2 = 1-_phongK1;
																		_phongX = lastX-_phongK1*_phongLineValue4;
																		if (_count == 1) {
																			_phongFirstX = _phongX;
																			_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																			_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																			_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																		} else {
																			_phongSecondX = _phongX;
																			_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																			_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																			_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																		}
																	}
																}
															} else {
																_phongSecondX = _phongX;
																_phongSecondVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
																_phongSecondVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
																_phongSecondVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
															}
														} else {
															//2
															_phongY = _phongLineValue5;
															if (_phongY != 0) {
																_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
																if (_phongK1>=0 && _phongK1<=1) {
																	_count++;
																	_phongK2 = 1-_phongK1;
																	_phongX = lastX-_phongK1*_phongLineValue4;
																	if (_count == 1) {
																		_phongFirstX = _phongX;
																		_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																		_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																		_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																	} else {
																		_phongSecondX = _phongX;
																		_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																		_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																		_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																	}
																}
															}
														}
													} else {
														//2
														_phongY = _phongLineValue5;
														if (_phongY != 0) {
															_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
															if (_phongK1>=0 && _phongK1<=1) {
																_count++;
																_phongK2 = 1-_phongK1;
																_phongX = lastX-_phongK1*_phongLineValue4;
																if (_count == 1) {
																	_phongFirstX = _phongX;
																	_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																} else {
																	_phongSecondX = _phongX;
																	_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																}
															}
														}
													}
												} else {
													_phongSecondX = _phongX;
													_phongSecondVectorX = _firstVector.x*_phongK2+_secondVector.x*_phongK1;
													_phongSecondVectorY = _firstVector.y*_phongK2+_secondVector.y*_phongK1;
													_phongSecondVectorZ = _firstVector.z*_phongK2+_secondVector.z*_phongK1;
												}
											} else {
												//1
												_phongY = _phongLineValue3;
												if (_phongY != 0) {
													_phongK1 = (secondY-_pixelScreenVertex.screenY)/_phongY;
													if (_phongK1>=0 && _phongK1<=1) {
														_count++;
														_phongK2 = 1-_phongK1;
														_phongX = secondX-_phongK1*_phongLineValue2;
														if (_count == 1) {
															_phongFirstX = _phongX;
															_phongFirstVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
															_phongFirstVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
															_phongFirstVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
															//2
															_phongY = _phongLineValue5;
															if (_phongY != 0) {
																_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
																if (_phongK1>=0 && _phongK1<=1) {
																	_count++;
																	_phongK2 = 1-_phongK1;
																	_phongX = lastX-_phongK1*_phongLineValue4;
																	if (_count == 1) {
																		_phongFirstX = _phongX;
																		_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																		_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																		_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																	} else {
																		_phongSecondX = _phongX;
																		_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																		_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																		_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																	}
																}
															}
														} else {
															_phongSecondX = _phongX;
															_phongSecondVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
															_phongSecondVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
															_phongSecondVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
														}
													} else {
														//2
														_phongY = _phongLineValue5;
														if (_phongY != 0) {
															_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
															if (_phongK1>=0 && _phongK1<=1) {
																_count++;
																_phongK2 = 1-_phongK1;
																_phongX = lastX-_phongK1*_phongLineValue4;
																if (_count == 1) {
																	_phongFirstX = _phongX;
																	_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																} else {
																	_phongSecondX = _phongX;
																	_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																}
															}
														}
													}
												} else {
													//2
													_phongY = _phongLineValue5;
													if (_phongY != 0) {
														_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
														if (_phongK1>=0 && _phongK1<=1) {
															_count++;
															_phongK2 = 1-_phongK1;
															_phongX = lastX-_phongK1*_phongLineValue4;
															if (_count == 1) {
																_phongFirstX = _phongX;
																_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
															} else {
																_phongSecondX = _phongX;
																_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
															}
														}
													}
												}
											}
										} else {
											//1
											_phongY = _phongLineValue3;
											if (_phongY != 0) {
												_phongK1 = (secondY-_pixelScreenVertex.screenY)/_phongY;
												if (_phongK1>=0 && _phongK1<=1) {
													_count++;
													_phongK2 = 1-_phongK1;
													_phongX = secondX-_phongK1*_phongLineValue2;
													if (_count == 1) {
														_phongFirstX = _phongX;
														_phongFirstVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
														_phongFirstVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
														_phongFirstVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
														//2
														_phongY = _phongLineValue5;
														if (_phongY != 0) {
															_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
															if (_phongK1>=0 && _phongK1<=1) {
																_count++;
																_phongK2 = 1-_phongK1;
																_phongX = lastX-_phongK1*_phongLineValue4;
																if (_count == 1) {
																	_phongFirstX = _phongX;
																	_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																} else {
																	_phongSecondX = _phongX;
																	_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																}
															}
														}
													} else {
														_phongSecondX = _phongX;
														_phongSecondVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
														_phongSecondVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
														_phongSecondVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
													}
												} else {
													//2
													_phongY = _phongLineValue5;
													if (_phongY != 0) {
														_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
														if (_phongK1>=0 && _phongK1<=1) {
															_count++;
															_phongK2 = 1-_phongK1;
															_phongX = lastX-_phongK1*_phongLineValue4;
															if (_count == 1) {
																_phongFirstX = _phongX;
																_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
															} else {
																_phongSecondX = _phongX;
																_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
															}
														}
													}
												}
											} else {
												//2
												_phongY = _phongLineValue5;
												if (_phongY != 0) {
													_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
													if (_phongK1>=0 && _phongK1<=1) {
														_count++;
														_phongK2 = 1-_phongK1;
														_phongX = lastX-_phongK1*_phongLineValue4;
														if (_count == 1) {
															_phongFirstX = _phongX;
															_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
															_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
															_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
														} else {
															_phongSecondX = _phongX;
															_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
															_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
															_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
														}
													}
												}
											}
										}
										
										_phongK1 = (_pixelScreenVertex.screenX-_phongSecondX)/(_phongFirstX-_phongSecondX);
										_phongK2 = 1-_phongK1;
										
										_pixelScreenVector.x = _phongFirstVectorX*_phongK1+_phongSecondVectorX*_phongK2;
										_pixelScreenVector.y = _phongFirstVectorY*_phongK1+_phongSecondVectorY*_phongK2;
										_pixelScreenVector.z = _phongFirstVectorZ*_phongK1+_phongSecondVectorZ*_phongK2;
									}
									
									if (_colorSelfLuminationEnabled) _color = Color.colorBlend(_selfLuminationColor, _color);
									
									_strength = 0;
									_useBlendColor = false;
									if (_shadingType == SHADING_GOURAUD) {
										_useBlendColor = _gouraudUseBlendColor;
										_strength = _gouraudStrength;
										for (i = 0; i<totalLights; i++) {
											_light = lightListArray[i];
											_light.lightingTest(_pixelScreenVertex, _pixelScreenVector);
											_strengthRatio = _light.strengthRatio;
											if (_strengthRatio<0) _strengthRatio = _doubleSidedLightEnabled ? -_strengthRatio : 0;
											if (_light.hasShadow) {
												_shadowRedRatio = _light._shadow.redRatio;
												_shadowGreenRatio = _light._shadow.greenRatio;
												_shadowBlueRatio = _light._shadow.blueRatio;
												if (_shadowRedRatio == 1 && _shadowGreenRatio == 1 && _shadowBlueRatio == 1) {
													_strength -= _light.strength*_strengthRatio*_lightingReflectionRadio;
													continue;
												}
											}
											_lightStrength = _light.strength*_strengthRatio*_lightingReflectionRadio;
											if (_light.colorLightingEnabled) {
												if (_light.hasShadow) {
													_shadowAlphaRatio = _light.shadow.alphaRatio;
													_blendColor = ((_blendColor>>24&0xFF)*(1-_shadowAlphaRatio)+255*_shadowAlphaRatio)<<24|((_blendColor>>16&0xFF)*_shadowRedRatio)<<16|((_blendColor>>8&0xFF)*_shadowGreenRatio)<<8|((_blendColor&0xFF)*_shadowBlueRatio);
												}
											} else if (_light.hasShadow) {
												_blendColor = (_lightStrength*_light._shadow.alphaRatio*255)<<24|(_shadowRedRatio*255)<<16|(_shadowGreenRatio*255)<<8|(_shadowBlueRatio*255);
												_useBlendColor = true;
											}
										}
										if (_strength<0) _strength = 0;
									} else {
										for (i = 0; i<totalLights; i++) {
											_light = lightListArray[i];
											_light.lightingTest(_pixelScreenVertex, _pixelScreenVector);
											if (_light.hasShadow) {
												_shadowRedRatio = _light._shadow.redRatio;
												_shadowGreenRatio = _light._shadow.greenRatio;
												_shadowBlueRatio = _light._shadow.blueRatio;
												if (_shadowRedRatio == 1 && _shadowGreenRatio == 1 && _shadowBlueRatio == 1) continue;
											}
											_strengthRatio = _light.strengthRatio;
											if (_strengthRatio<0) _strengthRatio = _doubleSidedLightEnabled ? -_strengthRatio : 0;
											_lightStrength = _light.strength*_strengthRatio*_lightingReflectionRadio;
											_strength += _lightStrength;
											if (_light.colorLightingEnabled) {
												_tempColor = _light.lightingColor;
												_tempColor = ((_tempColor>>24&0xFF)*_light.strength*_strengthRatio)<<24|_tempColor&0xFFFFFF;
												if (_useBlendColor) {
													_blendColor = Color.colorBlend(_tempColor, _blendColor);
												} else {
													_blendColor = _tempColor;
													_useBlendColor = true;
												}
												if (_light.hasShadow) {
													_shadowAlphaRatio = _light.shadow.alphaRatio;
													_blendColor = ((_blendColor>>24&0xFF)*(1-_shadowAlphaRatio)+255*_shadowAlphaRatio)<<24|((_blendColor>>16&0xFF)*_shadowRedRatio)<<16|((_blendColor>>8&0xFF)*_shadowGreenRatio)<<8|((_blendColor&0xFF)*_shadowBlueRatio);
												}
											} else if (_light.hasShadow) {
												_blendColor = (_lightStrength*_light._shadow.alphaRatio*255)<<24|(_shadowRedRatio*255)<<16|(_shadowGreenRatio*255)<<8|(_shadowBlueRatio*255);
												_useBlendColor = true;
											}
										}
									}
									if (specularTextureEnabled) {
										_specularColor = _specularBitmapData.getPixel(_specularTextureWidth*_textureU, _specularTextureHeight*_textureV);
										_strength *= 1+((_specularColor>>16&0xFF)+(_specularColor>>8&0xFF)+(_specularColor&0xFF))/765;
									}
									if (_strength>1) _strength = 1;
									if (lightingStrengthTextureEnabled) {
										_lightingStrengthColor = _lightingStrengthBitmapData.getPixel(_lightingStrengthTextureWidth*_strength, 0);
										_strength = ((_lightingStrengthColor>>16&0xFF)+(_lightingStrengthColor>>8&0xFF)+(_lightingStrengthColor&0xFF))/765;
									}
									_brightness = _strength*(1-_selfLuminationStrength)+_selfLuminationStrength;
									if (_brightness != 0.5) {
										_colorRed = _color>>16&0xFF;
										_colorGreen = _color>>8&0xFF;
										_colorBlue = _color&0xFF;
										if (_brightness>0.5) {
											_brightness = _brightness*2-1;
											_colorRed += (255-_colorRed)*_brightness;
											_colorGreen += (255-_colorGreen)*_brightness;
											_colorBlue += (255-_colorBlue)*_brightness;
										} else {
											_brightness *= 2;
											_colorRed *= _brightness;
											_colorGreen *= _brightness;
											_colorBlue *= _brightness;
										}
										_color = _color&0xFF000000|_colorRed<<16|_colorGreen<<8|_colorBlue;
									}
									if (_useBlendColor) _color = Color.colorBlend(_color, _blendColor);
									
									PixelInfo.alphaColorSort(_info, _color, _depth);
									sourceBitmapData.setPixel32(_nx, -ny, Color.colorBlendWithPixelAlphaColor(_info));
										
								} else if (_depth<=_info.opaqueColorDepth) {
									//No5
									if (bumpTextureEnabled) {
										_bumpX = _bumpTextureWidth*_textureU;
										_bumpY = _bumpTextureHeight*_textureV;
										_bumpkx = (_bumpBitmapData.getPixel((_bumpX == 0 ? _bumpX : _bumpX-1), _bumpY)-_bumpBitmapData.getPixel((_bumpX == _bumpTextureWidth ? _bumpX : _bumpX+1), _bumpY))/16777215;
										_bumpky = (_bumpBitmapData.getPixel(_bumpX, (_bumpY == 0 ? _bumpY : _bumpY-1))-_bumpBitmapData.getPixel(_bumpX, (_bumpY == _bumpTextureHeight ? _bumpY : _bumpY+1)))/16777215;
										
										_tempMatrix.copy(_tangentMatrix);
										_tempMatrix.rotationY = 90*_bumpkx;
										_tempMatrix.rotationX = 90*_bumpky;
										
										_pixelScreenVector.x = _tempMatrix.c;
										_pixelScreenVector.y = _tempMatrix.f;
										_pixelScreenVector.z = _tempMatrix.i;
									} else if (normalTextureEnabled) {
										_normalColor = _normalBitmapData.getPixel(_normalTextureWidth*_textureU, _normalTextureHeight*_textureV);
										_normalColorX = _normalColor>>16&0xFF;
										_normalColorY = _normalColor>>8&0xFF;
										_normalColorZ = _normalColor&0xFF;
										_normalColorZ = _normalColor&0xFF;
										if (_normalColorX>127) {
											_normalZVectorX = (_normalColorX-127)/128;
										} else if (_normalColorX<127) {
											_normalZVectorX = (_normalColorX-127)/127;
										} else {
											_normalZVectorX = 0;
										}
										if (_normalColorY>127) {
											_normalZVectorY = (_normalColorY-127)/128;
										} else if (_normalColorY<127) {
											_normalZVectorY = (_normalColorY-127)/127;
										} else {
											_normalZVectorY = 0;
										}
										if (_normalColorZ>127) {
											_normalZVectorZ = (_normalColorZ-127)/128;
										} else if (_normalColorZ<127) {
											_normalZVectorZ = (_normalColorZ-127)/127;
										} else {
											_normalZVectorZ = 0;
										}
										
										_pixelScreenVector.x = _normalZVectorX*_tangentMatrix.a+_normalZVectorY*_tangentMatrix.b+_normalZVectorZ*_tangentMatrix.c;
										_pixelScreenVector.y = _normalZVectorX*_tangentMatrix.d+_normalZVectorY*_tangentMatrix.e+_normalZVectorZ*_tangentMatrix.f;
										_pixelScreenVector.z = _normalZVectorX*_tangentMatrix.g+_normalZVectorY*_tangentMatrix.h+_normalZVectorZ*_tangentMatrix.i;
									} else if (_shadingType == SHADING_PHONG) {
										_count = 0;
										//0
										_phongY = _phongLineValue1;
										if (_phongY != 0) {
											_phongK1 = (firstY-_pixelScreenVertex.screenY)/_phongY;
											if (_phongK1>=0 && _phongK1<=1) {
												_count++;
												_phongK2 = 1-_phongK1;
												_phongX = firstX-_phongK1*_phongLineValue0;
												if (_count == 1) {
													_phongFirstX = _phongX;
													_phongFirstVectorX = _firstVector.x*_phongK2+_secondVector.x*_phongK1;
													_phongFirstVectorY = _firstVector.y*_phongK2+_secondVector.y*_phongK1;
													_phongFirstVectorZ = _firstVector.z*_phongK2+_secondVector.z*_phongK1;
													//1
													_phongY = _phongLineValue3;
													if (_phongY != 0) {
														_phongK1 = (secondY-_pixelScreenVertex.screenY)/_phongY;
														if (_phongK1>=0 && _phongK1<=1) {
															_count++;
															_phongK2 = 1-_phongK1;
															_phongX = secondX-_phongK1*_phongLineValue2;
															if (_count == 1) {
																_phongFirstX = _phongX;
																_phongFirstVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
																_phongFirstVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
																_phongFirstVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
																//2
																_phongY = _phongLineValue5;
																if (_phongY != 0) {
																	_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
																	if (_phongK1>=0 && _phongK1<=1) {
																		_count++;
																		_phongK2 = 1-_phongK1;
																		_phongX = lastX-_phongK1*_phongLineValue4;
																		if (_count == 1) {
																			_phongFirstX = _phongX;
																			_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																			_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																			_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																		} else {
																			_phongSecondX = _phongX;
																			_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																			_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																			_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																		}
																	}
																}
															} else {
																_phongSecondX = _phongX;
																_phongSecondVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
																_phongSecondVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
																_phongSecondVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
															}
														} else {
															//2
															_phongY = _phongLineValue5;
															if (_phongY != 0) {
																_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
																if (_phongK1>=0 && _phongK1<=1) {
																	_count++;
																	_phongK2 = 1-_phongK1;
																	_phongX = lastX-_phongK1*_phongLineValue4;
																	if (_count == 1) {
																		_phongFirstX = _phongX;
																		_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																		_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																		_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																	} else {
																		_phongSecondX = _phongX;
																		_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																		_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																		_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																	}
																}
															}
														}
													} else {
														//2
														_phongY = _phongLineValue5;
														if (_phongY != 0) {
															_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
															if (_phongK1>=0 && _phongK1<=1) {
																_count++;
																_phongK2 = 1-_phongK1;
																_phongX = lastX-_phongK1*_phongLineValue4;
																if (_count == 1) {
																	_phongFirstX = _phongX;
																	_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																} else {
																	_phongSecondX = _phongX;
																	_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																}
															}
														}
													}
												} else {
													_phongSecondX = _phongX;
													_phongSecondVectorX = _firstVector.x*_phongK2+_secondVector.x*_phongK1;
													_phongSecondVectorY = _firstVector.y*_phongK2+_secondVector.y*_phongK1;
													_phongSecondVectorZ = _firstVector.z*_phongK2+_secondVector.z*_phongK1;
												}
											} else {
												//1
												_phongY = _phongLineValue3;
												if (_phongY != 0) {
													_phongK1 = (secondY-_pixelScreenVertex.screenY)/_phongY;
													if (_phongK1>=0 && _phongK1<=1) {
														_count++;
														_phongK2 = 1-_phongK1;
														_phongX = secondX-_phongK1*_phongLineValue2;
														if (_count == 1) {
															_phongFirstX = _phongX;
															_phongFirstVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
															_phongFirstVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
															_phongFirstVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
															//2
															_phongY = _phongLineValue5;
															if (_phongY != 0) {
																_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
																if (_phongK1>=0 && _phongK1<=1) {
																	_count++;
																	_phongK2 = 1-_phongK1;
																	_phongX = lastX-_phongK1*_phongLineValue4;
																	if (_count == 1) {
																		_phongFirstX = _phongX;
																		_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																		_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																		_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																	} else {
																		_phongSecondX = _phongX;
																		_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																		_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																		_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																	}
																}
															}
														} else {
															_phongSecondX = _phongX;
															_phongSecondVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
															_phongSecondVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
															_phongSecondVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
														}
													} else {
														//2
														_phongY = _phongLineValue5;
														if (_phongY != 0) {
															_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
															if (_phongK1>=0 && _phongK1<=1) {
																_count++;
																_phongK2 = 1-_phongK1;
																_phongX = lastX-_phongK1*_phongLineValue4;
																if (_count == 1) {
																	_phongFirstX = _phongX;
																	_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																} else {
																	_phongSecondX = _phongX;
																	_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																}
															}
														}
													}
												} else {
													//2
													_phongY = _phongLineValue5;
													if (_phongY != 0) {
														_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
														if (_phongK1>=0 && _phongK1<=1) {
															_count++;
															_phongK2 = 1-_phongK1;
															_phongX = lastX-_phongK1*_phongLineValue4;
															if (_count == 1) {
																_phongFirstX = _phongX;
																_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
															} else {
																_phongSecondX = _phongX;
																_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
															}
														}
													}
												}
											}
										} else {
											//1
											_phongY = _phongLineValue3;
											if (_phongY != 0) {
												_phongK1 = (secondY-_pixelScreenVertex.screenY)/_phongY;
												if (_phongK1>=0 && _phongK1<=1) {
													_count++;
													_phongK2 = 1-_phongK1;
													_phongX = secondX-_phongK1*_phongLineValue2;
													if (_count == 1) {
														_phongFirstX = _phongX;
														_phongFirstVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
														_phongFirstVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
														_phongFirstVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
														//2
														_phongY = _phongLineValue5;
														if (_phongY != 0) {
															_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
															if (_phongK1>=0 && _phongK1<=1) {
																_count++;
																_phongK2 = 1-_phongK1;
																_phongX = lastX-_phongK1*_phongLineValue4;
																if (_count == 1) {
																	_phongFirstX = _phongX;
																	_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																} else {
																	_phongSecondX = _phongX;
																	_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																}
															}
														}
													} else {
														_phongSecondX = _phongX;
														_phongSecondVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
														_phongSecondVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
														_phongSecondVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
													}
												} else {
													//2
													_phongY = _phongLineValue5;
													if (_phongY != 0) {
														_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
														if (_phongK1>=0 && _phongK1<=1) {
															_count++;
															_phongK2 = 1-_phongK1;
															_phongX = lastX-_phongK1*_phongLineValue4;
															if (_count == 1) {
																_phongFirstX = _phongX;
																_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
															} else {
																_phongSecondX = _phongX;
																_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
															}
														}
													}
												}
											} else {
												//2
												_phongY = _phongLineValue5;
												if (_phongY != 0) {
													_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
													if (_phongK1>=0 && _phongK1<=1) {
														_count++;
														_phongK2 = 1-_phongK1;
														_phongX = lastX-_phongK1*_phongLineValue4;
														if (_count == 1) {
															_phongFirstX = _phongX;
															_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
															_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
															_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
														} else {
															_phongSecondX = _phongX;
															_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
															_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
															_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
														}
													}
												}
											}
										}
										
										_phongK1 = (_pixelScreenVertex.screenX-_phongSecondX)/(_phongFirstX-_phongSecondX);
										_phongK2 = 1-_phongK1;
										
										_pixelScreenVector.x = _phongFirstVectorX*_phongK1+_phongSecondVectorX*_phongK2;
										_pixelScreenVector.y = _phongFirstVectorY*_phongK1+_phongSecondVectorY*_phongK2;
										_pixelScreenVector.z = _phongFirstVectorZ*_phongK1+_phongSecondVectorZ*_phongK2;
									}
									
									if (_colorSelfLuminationEnabled) _color = Color.colorBlend(_selfLuminationColor, _color);
									
									_strength = 0;
									_useBlendColor = false;
									if (_shadingType == SHADING_GOURAUD) {
										_useBlendColor = _gouraudUseBlendColor;
										_strength = _gouraudStrength;
										for (i = 0; i<totalLights; i++) {
											_light = lightListArray[i];
											_light.lightingTest(_pixelScreenVertex, _pixelScreenVector);
											_strengthRatio = _light.strengthRatio;
											if (_strengthRatio<0) _strengthRatio = _doubleSidedLightEnabled ? -_strengthRatio : 0;
											if (_light.hasShadow) {
												_shadowRedRatio = _light._shadow.redRatio;
												_shadowGreenRatio = _light._shadow.greenRatio;
												_shadowBlueRatio = _light._shadow.blueRatio;
												if (_shadowRedRatio == 1 && _shadowGreenRatio == 1 && _shadowBlueRatio == 1) {
													_strength -= _light.strength*_strengthRatio*_lightingReflectionRadio;
													continue;
												}
											}
											_lightStrength = _light.strength*_strengthRatio*_lightingReflectionRadio;
											if (_light.colorLightingEnabled) {
												if (_light.hasShadow) {
													_shadowAlphaRatio = _light.shadow.alphaRatio;
													_blendColor = ((_blendColor>>24&0xFF)*(1-_shadowAlphaRatio)+255*_shadowAlphaRatio)<<24|((_blendColor>>16&0xFF)*_shadowRedRatio)<<16|((_blendColor>>8&0xFF)*_shadowGreenRatio)<<8|((_blendColor&0xFF)*_shadowBlueRatio);
												}
											} else if (_light.hasShadow) {
												_blendColor = (_lightStrength*_light._shadow.alphaRatio*255)<<24|(_shadowRedRatio*255)<<16|(_shadowGreenRatio*255)<<8|(_shadowBlueRatio*255);
												_useBlendColor = true;
											}
										}
										if (_strength<0) _strength = 0;
									} else {
										for (i = 0; i<totalLights; i++) {
											_light = lightListArray[i];
											_light.lightingTest(_pixelScreenVertex, _pixelScreenVector);
											if (_light.hasShadow) {
												_shadowRedRatio = _light._shadow.redRatio;
												_shadowGreenRatio = _light._shadow.greenRatio;
												_shadowBlueRatio = _light._shadow.blueRatio;
												if (_shadowRedRatio == 1 && _shadowGreenRatio == 1 && _shadowBlueRatio == 1) continue;
											}
											_strengthRatio = _light.strengthRatio;
											if (_strengthRatio<0) _strengthRatio = _doubleSidedLightEnabled ? -_strengthRatio : 0;
											_lightStrength = _light.strength*_strengthRatio*_lightingReflectionRadio;
											_strength += _lightStrength;
											if (_light.colorLightingEnabled) {
												_tempColor = _light.lightingColor;
												_tempColor = ((_tempColor>>24&0xFF)*_light.strength*_strengthRatio)<<24|_tempColor&0xFFFFFF;
												if (_useBlendColor) {
													_blendColor = Color.colorBlend(_tempColor, _blendColor);
												} else {
													_blendColor = _tempColor;
													_useBlendColor = true;
												}
												if (_light.hasShadow) {
													_shadowAlphaRatio = _light.shadow.alphaRatio;
													_blendColor = ((_blendColor>>24&0xFF)*(1-_shadowAlphaRatio)+255*_shadowAlphaRatio)<<24|((_blendColor>>16&0xFF)*_shadowRedRatio)<<16|((_blendColor>>8&0xFF)*_shadowGreenRatio)<<8|((_blendColor&0xFF)*_shadowBlueRatio);
												}
											} else if (_light.hasShadow) {
												_blendColor = (_lightStrength*_light._shadow.alphaRatio*255)<<24|(_shadowRedRatio*255)<<16|(_shadowGreenRatio*255)<<8|(_shadowBlueRatio*255);
												_useBlendColor = true;
											}
										}
									}
									if (specularTextureEnabled) {
										_specularColor = _specularBitmapData.getPixel(_specularTextureWidth*_textureU, _specularTextureHeight*_textureV);
										_strength *= 1+((_specularColor>>16&0xFF)+(_specularColor>>8&0xFF)+(_specularColor&0xFF))/765;
									}
									if (_strength>1) _strength = 1;
									if (lightingStrengthTextureEnabled) {
										_lightingStrengthColor = _lightingStrengthBitmapData.getPixel(_lightingStrengthTextureWidth*_strength, 0);
										_strength = ((_lightingStrengthColor>>16&0xFF)+(_lightingStrengthColor>>8&0xFF)+(_lightingStrengthColor&0xFF))/765;
									}
									_brightness = _strength*(1-_selfLuminationStrength)+_selfLuminationStrength;
									if (_brightness != 0.5) {
										_colorRed = _color>>16&0xFF;
										_colorGreen = _color>>8&0xFF;
										_colorBlue = _color&0xFF;
										if (_brightness>0.5) {
											_brightness = _brightness*2-1;
											_colorRed += (255-_colorRed)*_brightness;
											_colorGreen += (255-_colorGreen)*_brightness;
											_colorBlue += (255-_colorBlue)*_brightness;
										} else {
											_brightness *= 2;
											_colorRed *= _brightness;
											_colorGreen *= _brightness;
											_colorBlue *= _brightness;
										}
										_color = _color&0xFF000000|_colorRed<<16|_colorGreen<<8|_colorBlue;
									}
									if (_useBlendColor) _color = Color.colorBlend(_color, _blendColor);
										
									if (_info.alphaColorList == null) {
										_info.alphaColorList = [_color, _depth];
									} else {
										PixelInfo.alphaColorSort(_info, _color, _depth);
									}
									sourceBitmapData.setPixel32(_nx, -ny, Color.colorBlendWithPixelAlphaColorAndOpaqueColor(_info));
								}
							}
						} else {
							//No6
							if (bumpTextureEnabled) {
								_bumpX = _bumpTextureWidth*_textureU;
								_bumpY = _bumpTextureHeight*_textureV;
								_bumpkx = (_bumpBitmapData.getPixel((_bumpX == 0 ? _bumpX : _bumpX-1), _bumpY)-_bumpBitmapData.getPixel((_bumpX == _bumpTextureWidth ? _bumpX : _bumpX+1), _bumpY))/16777215;
								_bumpky = (_bumpBitmapData.getPixel(_bumpX, (_bumpY == 0 ? _bumpY : _bumpY-1))-_bumpBitmapData.getPixel(_bumpX, (_bumpY == _bumpTextureHeight ? _bumpY : _bumpY+1)))/16777215;
								
								_tempMatrix.copy(_tangentMatrix);
								_tempMatrix.rotationY = 90*_bumpkx;
								_tempMatrix.rotationX = 90*_bumpky;
										
								_pixelScreenVector.x = _tempMatrix.c;
								_pixelScreenVector.y = _tempMatrix.f;
								_pixelScreenVector.z = _tempMatrix.i;
							} else if (normalTextureEnabled) {
								_normalColor = _normalBitmapData.getPixel(_normalTextureWidth*_textureU, _normalTextureHeight*_textureV);
								_normalColorX = _normalColor>>16&0xFF;
								_normalColorY = _normalColor>>8&0xFF;
								_normalColorZ = _normalColor&0xFF;
								if (_normalColorX>127) {
									_normalZVectorX = (_normalColorX-127)/128;
								} else if (_normalColorX<127) {
									_normalZVectorX = (_normalColorX-127)/127;
								} else {
									_normalZVectorX = 0;
								}
								if (_normalColorY>127) {
									_normalZVectorY = (_normalColorY-127)/128;
								} else if (_normalColorY<127) {
									_normalZVectorY = (_normalColorY-127)/127;
								} else {
									_normalZVectorY = 0;
								}
								if (_normalColorZ>127) {
									_normalZVectorZ = (_normalColorZ-127)/128;
								} else if (_normalColorZ<127) {
									_normalZVectorZ = (_normalColorZ-127)/127;
								} else {
									_normalZVectorZ = 0;
								}
								
								_pixelScreenVector.x = _normalZVectorX*_tangentMatrix.a+_normalZVectorY*_tangentMatrix.b+_normalZVectorZ*_tangentMatrix.c;
								_pixelScreenVector.y = _normalZVectorX*_tangentMatrix.d+_normalZVectorY*_tangentMatrix.e+_normalZVectorZ*_tangentMatrix.f;
								_pixelScreenVector.z = _normalZVectorX*_tangentMatrix.g+_normalZVectorY*_tangentMatrix.h+_normalZVectorZ*_tangentMatrix.i;
							} else if (_shadingType == SHADING_PHONG) {
								_count = 0;
								//0
								_phongY = _phongLineValue1;
								if (_phongY != 0) {
									_phongK1 = (firstY-_pixelScreenVertex.screenY)/_phongY;
									if (_phongK1>=0 && _phongK1<=1) {
										_count++;
										_phongK2 = 1-_phongK1;
										_phongX = firstX-_phongK1*_phongLineValue0;
										if (_count == 1) {
											_phongFirstX = _phongX;
											_phongFirstVectorX = _firstVector.x*_phongK2+_secondVector.x*_phongK1;
											_phongFirstVectorY = _firstVector.y*_phongK2+_secondVector.y*_phongK1;
											_phongFirstVectorZ = _firstVector.z*_phongK2+_secondVector.z*_phongK1;
											//1
											_phongY = _phongLineValue3;
											if (_phongY != 0) {
												_phongK1 = (secondY-_pixelScreenVertex.screenY)/_phongY;
												if (_phongK1>=0 && _phongK1<=1) {
													_count++;
													_phongK2 = 1-_phongK1;
													_phongX = secondX-_phongK1*_phongLineValue2;
													if (_count == 1) {
														_phongFirstX = _phongX;
														_phongFirstVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
														_phongFirstVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
														_phongFirstVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
														//2
														_phongY = _phongLineValue5;
														if (_phongY != 0) {
															_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
															if (_phongK1>=0 && _phongK1<=1) {
																_count++;
																_phongK2 = 1-_phongK1;
																_phongX = lastX-_phongK1*_phongLineValue4;
																if (_count == 1) {
																	_phongFirstX = _phongX;
																	_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																} else {
																	_phongSecondX = _phongX;
																	_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																	_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																	_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
																}
															}
														}
													} else {
														_phongSecondX = _phongX;
														_phongSecondVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
														_phongSecondVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
														_phongSecondVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
													}
												} else {
													//2
													_phongY = _phongLineValue5;
													if (_phongY != 0) {
														_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
														if (_phongK1>=0 && _phongK1<=1) {
															_count++;
															_phongK2 = 1-_phongK1;
															_phongX = lastX-_phongK1*_phongLineValue4;
															if (_count == 1) {
																_phongFirstX = _phongX;
																_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
															} else {
																_phongSecondX = _phongX;
																_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
															}
														}
													}
												}
											} else {
												//2
												_phongY = _phongLineValue5;
												if (_phongY != 0) {
													_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
													if (_phongK1>=0 && _phongK1<=1) {
														_count++;
														_phongK2 = 1-_phongK1;
														_phongX = lastX-_phongK1*_phongLineValue4;
														if (_count == 1) {
															_phongFirstX = _phongX;
															_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
															_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
															_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
														} else {
															_phongSecondX = _phongX;
															_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
															_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
															_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
														}
													}
												}
											}
										} else {
											_phongSecondX = _phongX;
											_phongSecondVectorX = _firstVector.x*_phongK2+_secondVector.x*_phongK1;
											_phongSecondVectorY = _firstVector.y*_phongK2+_secondVector.y*_phongK1;
											_phongSecondVectorZ = _firstVector.z*_phongK2+_secondVector.z*_phongK1;
										}
									} else {
										//1
										_phongY = _phongLineValue3;
										if (_phongY != 0) {
											_phongK1 = (secondY-_pixelScreenVertex.screenY)/_phongY;
											if (_phongK1>=0 && _phongK1<=1) {
												_count++;
												_phongK2 = 1-_phongK1;
												_phongX = secondX-_phongK1*_phongLineValue2;
												if (_count == 1) {
													_phongFirstX = _phongX;
													_phongFirstVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
													_phongFirstVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
													_phongFirstVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
													//2
													_phongY = _phongLineValue5;
													if (_phongY != 0) {
														_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
														if (_phongK1>=0 && _phongK1<=1) {
															_count++;
															_phongK2 = 1-_phongK1;
															_phongX = lastX-_phongK1*_phongLineValue4;
															if (_count == 1) {
																_phongFirstX = _phongX;
																_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
															} else {
																_phongSecondX = _phongX;
																_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
																_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
																_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
															}
														}
													}
												} else {
													_phongSecondX = _phongX;
													_phongSecondVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
													_phongSecondVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
													_phongSecondVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
												}
											} else {
												//2
												_phongY = _phongLineValue5;
												if (_phongY != 0) {
													_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
													if (_phongK1>=0 && _phongK1<=1) {
														_count++;
														_phongK2 = 1-_phongK1;
														_phongX = lastX-_phongK1*_phongLineValue4;
														if (_count == 1) {
															_phongFirstX = _phongX;
															_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
															_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
															_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
														} else {
															_phongSecondX = _phongX;
															_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
															_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
															_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
														}
													}
												}
											}
										} else {
											//2
											_phongY = _phongLineValue5;
											if (_phongY != 0) {
												_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
												if (_phongK1>=0 && _phongK1<=1) {
													_count++;
													_phongK2 = 1-_phongK1;
													_phongX = lastX-_phongK1*_phongLineValue4;
													if (_count == 1) {
														_phongFirstX = _phongX;
														_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
														_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
														_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
													} else {
														_phongSecondX = _phongX;
														_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
														_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
														_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
													}
												}
											}
										}
									}
								} else {
									//1
									_phongY = _phongLineValue3;
									if (_phongY != 0) {
										_phongK1 = (secondY-_pixelScreenVertex.screenY)/_phongY;
										if (_phongK1>=0 && _phongK1<=1) {
											_count++;
											_phongK2 = 1-_phongK1;
											_phongX = secondX-_phongK1*_phongLineValue2;
											if (_count == 1) {
												_phongFirstX = _phongX;
												_phongFirstVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
												_phongFirstVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
												_phongFirstVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
												//2
												_phongY = _phongLineValue5;
												if (_phongY != 0) {
													_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
													if (_phongK1>=0 && _phongK1<=1) {
														_count++;
														_phongK2 = 1-_phongK1;
														_phongX = lastX-_phongK1*_phongLineValue4;
														if (_count == 1) {
															_phongFirstX = _phongX;
															_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
															_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
															_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
														} else {
															_phongSecondX = _phongX;
															_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
															_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
															_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
														}
													}
												}
											} else {
												_phongSecondX = _phongX;
												_phongSecondVectorX = _secondVector.x*_phongK2+_thirdVector.x*_phongK1;
												_phongSecondVectorY = _secondVector.y*_phongK2+_thirdVector.y*_phongK1;
												_phongSecondVectorZ = _secondVector.z*_phongK2+_thirdVector.z*_phongK1;
											}
										} else {
											//2
											_phongY = _phongLineValue5;
											if (_phongY != 0) {
												_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
												if (_phongK1>=0 && _phongK1<=1) {
													_count++;
													_phongK2 = 1-_phongK1;
													_phongX = lastX-_phongK1*_phongLineValue4;
													if (_count == 1) {
														_phongFirstX = _phongX;
														_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
														_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
														_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
													} else {
														_phongSecondX = _phongX;
														_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
														_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
														_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
													}
												}
											}
										}
									} else {
										//2
										_phongY = _phongLineValue5;
										if (_phongY != 0) {
											_phongK1 = (lastY-_pixelScreenVertex.screenY)/_phongY;
											if (_phongK1>=0 && _phongK1<=1) {
												_count++;
												_phongK2 = 1-_phongK1;
												_phongX = lastX-_phongK1*_phongLineValue4;
												if (_count == 1) {
													_phongFirstX = _phongX;
													_phongFirstVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
													_phongFirstVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
													_phongFirstVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
												} else {
													_phongSecondX = _phongX;
													_phongSecondVectorX = _thirdVector.x*_phongK2+_firstVector.x*_phongK1;
													_phongSecondVectorY = _thirdVector.y*_phongK2+_firstVector.y*_phongK1;
													_phongSecondVectorZ = _thirdVector.z*_phongK2+_firstVector.z*_phongK1;
												}
											}
										}
									}
								}
								
								_phongK1 = (_pixelScreenVertex.screenX-_phongSecondX)/(_phongFirstX-_phongSecondX);
								_phongK2 = 1-_phongK1;
								
								_pixelScreenVector.x = _phongFirstVectorX*_phongK1+_phongSecondVectorX*_phongK2;
								_pixelScreenVector.y = _phongFirstVectorY*_phongK1+_phongSecondVectorY*_phongK2;
								_pixelScreenVector.z = _phongFirstVectorZ*_phongK1+_phongSecondVectorZ*_phongK2;
							}
									
							if (_colorSelfLuminationEnabled) _color = Color.colorBlend(_selfLuminationColor, _color);
							
							_strength = 0;
							_useBlendColor = false;
							if (_shadingType == SHADING_GOURAUD) {
								_useBlendColor = _gouraudUseBlendColor;
								_strength = _gouraudStrength;
								for (i = 0; i<totalLights; i++) {
									_light = lightListArray[i];
									_light.lightingTest(_pixelScreenVertex, _pixelScreenVector);
									_strengthRatio = _light.strengthRatio;
									if (_strengthRatio<0) _strengthRatio = _doubleSidedLightEnabled ? -_strengthRatio : 0;
									if (_light.hasShadow) {
										_shadowRedRatio = _light._shadow.redRatio;
										_shadowGreenRatio = _light._shadow.greenRatio;
										_shadowBlueRatio = _light._shadow.blueRatio;
										if (_shadowRedRatio == 1 && _shadowGreenRatio == 1 && _shadowBlueRatio == 1) {
											_strength -= _light.strength*_strengthRatio*_lightingReflectionRadio;
											continue;
										}
									}
									_lightStrength = _light.strength*_strengthRatio*_lightingReflectionRadio;
									if (_light.colorLightingEnabled) {
										if (_light.hasShadow) {
											_shadowAlphaRatio = _light.shadow.alphaRatio;
											_blendColor = ((_blendColor>>24&0xFF)*(1-_shadowAlphaRatio)+255*_shadowAlphaRatio)<<24|((_blendColor>>16&0xFF)*_shadowRedRatio)<<16|((_blendColor>>8&0xFF)*_shadowGreenRatio)<<8|((_blendColor&0xFF)*_shadowBlueRatio);
										}
									} else if (_light.hasShadow) {
										_blendColor = (_lightStrength*_light._shadow.alphaRatio*255)<<24|(_shadowRedRatio*255)<<16|(_shadowGreenRatio*255)<<8|(_shadowBlueRatio*255);
										_useBlendColor = true;
									}
								}
								if (_strength<0) _strength = 0;
							} else {
								for (i = 0; i<totalLights; i++) {
									_light = lightListArray[i];
									_light.lightingTest(_pixelScreenVertex, _pixelScreenVector);
									if (_light.hasShadow) {
										_shadowRedRatio = _light._shadow.redRatio;
										_shadowGreenRatio = _light._shadow.greenRatio;
										_shadowBlueRatio = _light._shadow.blueRatio;
										if (_shadowRedRatio == 1 && _shadowGreenRatio == 1 && _shadowBlueRatio == 1) continue;
									}
									_strengthRatio = _light.strengthRatio;
									if (_strengthRatio<0) _strengthRatio = _doubleSidedLightEnabled ? -_strengthRatio : 0;
									_lightStrength = _light.strength*_strengthRatio*_lightingReflectionRadio;
									_strength += _lightStrength;
									if (_light.colorLightingEnabled) {
										_tempColor = _light.lightingColor;
										_tempColor = ((_tempColor>>24&0xFF)*_light.strength*_strengthRatio)<<24|_tempColor&0xFFFFFF;	
										if (_useBlendColor) {
											_blendColor = Color.colorBlend(_tempColor, _blendColor);
										} else {
											_blendColor = _tempColor;
											_useBlendColor = true;
										}
										if (_light.hasShadow) {
											_shadowAlphaRatio = _light.shadow.alphaRatio;
											_blendColor = ((_blendColor>>24&0xFF)*(1-_shadowAlphaRatio)+255*_shadowAlphaRatio)<<24|((_blendColor>>16&0xFF)*_shadowRedRatio)<<16|((_blendColor>>8&0xFF)*_shadowGreenRatio)<<8|((_blendColor&0xFF)*_shadowBlueRatio);
										}
									} else if (_light.hasShadow) {
										_blendColor = (_lightStrength*_light._shadow.alphaRatio*255)<<24|(_shadowRedRatio*255)<<16|(_shadowGreenRatio*255)<<8|(_shadowBlueRatio*255);
										_useBlendColor = true;
									}
								}
							}
							if (specularTextureEnabled) {
								_specularColor = _specularBitmapData.getPixel(_specularTextureWidth*_textureU, _specularTextureHeight*_textureV);
								_strength *= 1+((_specularColor>>16&0xFF)+(_specularColor>>8&0xFF)+(_specularColor&0xFF))/765;
							}
							if (_strength>1) _strength = 1;
							if (lightingStrengthTextureEnabled) {
								_lightingStrengthColor = _lightingStrengthBitmapData.getPixel(_lightingStrengthTextureWidth*_strength, 0);
								_strength = ((_lightingStrengthColor>>16&0xFF)+(_lightingStrengthColor>>8&0xFF)+(_lightingStrengthColor&0xFF))/765;
							}
							_brightness = _strength*(1-_selfLuminationStrength)+_selfLuminationStrength;
							if (_brightness != 0.5) {
								_colorRed = _color>>16&0xFF;
								_colorGreen = _color>>8&0xFF;
								_colorBlue = _color&0xFF;
								if (_brightness>0.5) {
									_brightness = _brightness*2-1;
									_colorRed += (255-_colorRed)*_brightness;
									_colorGreen += (255-_colorGreen)*_brightness;
									_colorBlue += (255-_colorBlue)*_brightness;
								} else {
									_brightness *= 2;
									_colorRed *= _brightness;
									_colorGreen *= _brightness;
									_colorBlue *= _brightness;
								}
								_color = _color&0xFF000000|_colorRed<<16|_colorGreen<<8|_colorBlue;
							}
							if (_useBlendColor) _color = Color.colorBlend(_color, _blendColor);
							
							if (_alpha == 255) {
								_info.opaqueColor = _color;
								_info.opaqueColorDepth = _depth;
								_info.alphaColorList = null;
								_info.useOpaqueColor = true;
							} else {
								_info.alphaColorList = [_color, _depth];
								_info.useOpaqueColor = false;
							}
							
							sourceBitmapData.setPixel32(_nx, -ny, _color);
							_info.refreshCount = refreshCount;
						}
						//source.setPixel32(nx, -ny, 0xFFff0000);
					}
				}
			}
			sourceBitmapData.unlock();
			var viewType:String = view.viewType;
			if (viewType == ViewType.BITMAPDATA) {
				(view.canvas as BitmapData).draw(sourceBitmapData, _matrix, null, null, null, true);
			} else {
				var graphics:Graphics;
				if (viewType == ViewType.SHAPE) {
					graphics = (view.canvas as Shape).graphics;
				} else if (viewType == ViewType.SPRITE) {
					graphics = (view.canvas as Sprite).graphics;
				}
				if (graphics != null) {
					graphics.beginBitmapFill(sourceBitmapData, _matrix, false, true);
					graphics.drawRect(0, 0, width, height);
				}
			}
			for (i = 0; i<totalLights; i++) {
				lightListArray[i].complete();
			}
			_info = null;
			_concatFaceNormal = null;
			_concatVertex = null;
			_lightingStrengthBitmapData = null;
			_specularBitmapData = null;
			_bumpBitmapData = null;
			_normalBitmapData = null;
			_light = null;
			_concatFaceList = null;
			_concatFace = null;
			_firstVertex = null;
			_secondVertex = null;
			_lastVertex = null;
			_firstUV = null;
			_secondUV = null;
			_lastUV = null;
			_tempList = null;
			completeFunction();
		}
		private static function _pixelBlend(c1:uint, c2:uint, k:Number):uint {
			var k1:Number = 1-k;
			return ((c1>>24&0xFF)*k1+(c2>>24&0xFF)*k)<<24|((c1>>16&0xFF)*k1+(c2>>16&0xFF)*k)<<16|((c1>>8&0xFF)*k1+(c2>>8&0xFF)*k)<<8|((c1&0xFF)*k1+(c2&0xFF)*k);
		}
	}
}