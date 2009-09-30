package asgl.renderers {
	import __AS3__.vec.Vector;
	
	import asgl.cameras.Camera3D;
	import asgl.drivers.AbstractRenderDriver;
	import asgl.drivers.ProjectionType;
	import asgl.lights.AbstractLight;
	import asgl.materials.CardMaterial;
	import asgl.materials.Material;
	import asgl.materials.ShadingType;
	import asgl.math.UV;
	import asgl.math.Vertex3D;
	import asgl.mesh.FaceType;
	import asgl.mesh.TriangleFace;
	import asgl.utils.Image;
	import asgl.views.BitmapDataView;
	import asgl.views.IView;
	import asgl.views.ViewType;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Vector3D;
	import flash.display.TriangleCulling;

	/**
	 * CardRenderer. this is a false 3d renderer.
	 * need CardMaterial.
	 * <p>Support:</p>
	 * <p>face:MaterialFace.</p>
	 * <p>texture:diffuse.</p>
	 * <p>FSAA:normal, h2x, v2x, 4x.</p>
	 * <p>light:all lights</p>
	 * need faces normal.
	 * if use lights, need faces normal.
	 * if use gouraud or phong shading, need concatFaces of faces.
	 */
	public class CardRenderer implements IRenderer {
		private static const SHADING_FLAT:int = ShadingType.FLAT;
		public var triangleCulling:String;
		public var materials:Vector.<Material>;
		private var _diffuseList:Array;
		private var _defaultMaterial:CardMaterial = new CardMaterial();
		private var _defaultView:BitmapDataView = new BitmapDataView();
		private var _isSmooth:Boolean = false;
		private var _totalLights:int;
		private var _canvas:Shape = new Shape();
		private var _lightCanvas:Shape = new Shape();
		private var _graphics:Graphics = _canvas.graphics;
		private var _lightGraphics:Graphics = _lightCanvas.graphics;
		private var _blendMode:String = BlendMode.MULTIPLY;
		private var _FSAALevel:String = FullSceneAntiAliasLevel.NORMAL;
		private var _lightList:Vector.<AbstractLight>;
		private var _uvVector:Vector.<Number> = new Vector.<Number>(6, true);
		private var _uvLightVector:Vector.<Number> = Vector.<Number>([0, 1, 0, 0, 0, 0.5]);
		private var _verticesVector:Vector.<Number> = new Vector.<Number>(6, true);
		
		private var _i:int;
		private var _totalConcatFaces:int;
		private var _normalX:Number;
		private var _normalY:Number;
		private var _normalZ:Number;
		private var _concatFace:TriangleFace;
		private var _concatNormal:Vector3D;
		private var _firstVector:Vector3D = new Vector3D();
		private var _normal:Vector3D;
		private var _secondVector:Vector3D = new Vector3D();
		private var _thirdVector:Vector3D = new Vector3D();
		private var _concatFaces:Vector.<TriangleFace>;
		private var _concatVertex:Vertex3D;
		public function CardRenderer(materials:Vector.<Material>=null, triangleCulling:String=TriangleCulling.NONE):void {
			this.materials = materials;
			this.triangleCulling = triangleCulling;
		}
		public function get facesType():String {
			return FaceType.MATERIAL_FACE;
		}
		public function get FSAALevel():String {
			return _FSAALevel;
		}
		public function set FSAALevel(value:String):void {
			if (value == FullSceneAntiAliasLevel.NORMAL) {
				_FSAALevel = value;
				_isSmooth = false;
			} else if (value == FullSceneAntiAliasLevel.HX2 || value == FullSceneAntiAliasLevel.VX2 || value == FullSceneAntiAliasLevel.X4) {
				_FSAALevel = value;
				_isSmooth = true;
			}
		}
		public function destroy():void {
			_canvas = null;
			_graphics = null;
			_lightCanvas = null;
			_lightGraphics = null;
			_firstVector = null;
			_secondVector = null;
			_thirdVector = null;
		}
		public function render(driver:AbstractRenderDriver, faces:Vector.<TriangleFace>, completeFunction:Function):void {
			var camera:Camera3D = driver.camera;
			var view:IView = driver.view;
			var viewType:String = view.viewType;
			var isBitmapData:Boolean = viewType == ViewType.BITMAPDATA;
			
			_lightList = driver.lights;
			_totalLights = _lightList == null ? 0 : _lightList.length;
			if (_totalLights>0) _transformMaterial();
			for (var i:int = 0; i<_totalLights; i++) {
				_lightList[i].init(driver);
			}
			if (driver.projectionType == ProjectionType.PARALLEL) {
				_parallelRender(faces);
			} else {
				_perspectiveRender(faces);
			}
			for (i = 0; i<_totalLights; i++) {
				_lightList[i].complete();
			}
			var output:BitmapData;
			if (isBitmapData) {
				output = view.canvas as BitmapData;
			} else {
				_defaultView.reset(camera.width, camera.height);
				output = _defaultView.canvas as BitmapData;
			}
			output.draw(_canvas);
			output.draw(_lightCanvas, null, null, _blendMode);
			if (!isBitmapData) {
				var graphics:Graphics;
				if (viewType == ViewType.SHAPE) {
					graphics = (view.canvas as Shape).graphics;
				} else if (viewType == ViewType.SPRITE) {
					graphics = (view.canvas as Sprite).graphics;
				}
				if (graphics != null) {
					graphics.beginBitmapFill(output);
					graphics.drawRect(0, 0, camera.width, camera.height);
				}
			}
			if (_totalLights>0) _reductionMaterial();
			_graphics.clear();
			_lightGraphics.clear();
			_lightList = null;
			_concatFace = null;
			_concatFaces = null;
			_concatNormal = null;
			_normal = null;
			completeFunction();
		}
		private function _parallelRender(faces:Vector.<TriangleFace>):void {
			var v0:Vertex3D;
			var v1:Vertex3D;
			var v2:Vertex3D;
			var v3:Vertex3D;
			var uv0:UV;
			var uv1:UV;
			var uv2:UV;
			var uv3:UV;
			var length:int = faces.length;
			var material:CardMaterial;
			var light:AbstractLight;
			var k:Number;
			var strengthRatio:Number;
			var j:int;
			for (var i:int = 0; i<length; i++) {
				var face:TriangleFace = faces[i];
				if (!face.isMaterialFace) continue;
				material = face.material as CardMaterial;
				if (material == null) {
					material = _defaultMaterial;
					material.color = face.color;
				}
				var isDouble:Boolean = material.doubleSidedLightEnabled;
				var lightingReflectionRadio:Number = material.lightingReflectionRadio;
				var selfLuminationStrength:Number  = material.selfLuminationStrength;
				v0 = face.vertex0;
				v1 = face.vertex1;
				v2 = face.vertex2;
				uv0 = face.uv0;
				uv1 = face.uv1;
				uv2 = face.uv2;
				
				var b0:Number = 0;
				var b1:Number = 0;
				var b2:Number = 0;
				if (material.shadingType == SHADING_FLAT) {
					for (j = 0; j<_totalLights; j++) {
						light = _lightList[j];
						k = light.strength*lightingReflectionRadio;
						
						light.lightingTest(v0, face.vector);
						strengthRatio = light.strengthRatio;
						if (strengthRatio<0) strengthRatio = isDouble ? -strengthRatio : 0;
						b0 += strengthRatio*k;
						
						light.lightingTest(v1, face.vector);
						strengthRatio = light.strengthRatio;
						if (strengthRatio<0) strengthRatio = isDouble ? -strengthRatio : 0;
						b1 += strengthRatio*k;
						
						light.lightingTest(v2, face.vector);
						strengthRatio = light.strengthRatio;
						if (strengthRatio<0) strengthRatio = isDouble ? -strengthRatio : 0;
						b2 += strengthRatio*k;
					}
				} else {
					_concatFaces = face.concatFaces;
					_normal = face.vector;
					for (j = 0; j<_totalLights; j++) {
						light = _lightList[j];
						k = light.strength*lightingReflectionRadio;
						
						if (_concatFaces == null || (_totalConcatFaces = _concatFaces.length) == 0) {
							_firstVector.x = _normal.x;
							_firstVector.y = _normal.y;
							_firstVector.z = _normal.z;
							
							_secondVector.x = _normal.x;
							_secondVector.y = _normal.y;
							_secondVector.z = _normal.z;
							
							_thirdVector.x = _normal.x;
							_thirdVector.y = _normal.y;
							_thirdVector.z = _normal.z;
						} else {
							_totalConcatFaces = _concatFaces.length;
							_normalX = _normal.x;
							_normalY = _normal.y;
							_normalZ = _normal.z;
							for (_i = 0; _i<_totalConcatFaces; _i++) {
								_concatFace = _concatFaces[_i];
								_concatVertex = _concatFace.vertex0;
								if (v0.screenX == _concatVertex.screenX && v0.screenY == _concatVertex.screenY && v0.screenZ == _concatVertex.screenZ) {
									_concatNormal = _concatFace.vector;
									_normalX += _concatNormal.x;
									_normalY += _concatNormal.y;
									_normalZ += _concatNormal.z;
								} else {
									_concatVertex = _concatFace.vertex1;
									if (v0.screenX == _concatVertex.screenX && v0.screenY == _concatVertex.screenY && v0.screenZ == _concatVertex.screenZ) {
										_concatNormal = _concatFace.vector;
										_normalX += _concatNormal.x;
										_normalY += _concatNormal.y;
										_normalZ += _concatNormal.z;
									} else {
										_concatVertex = _concatFace.vertex2;
										if (v0.screenX == _concatVertex.screenX && v0.screenY == _concatVertex.screenY && v0.screenZ == _concatVertex.screenZ) {
											_concatNormal = _concatFace.vector;
											_normalX += _concatNormal.x;
											_normalY += _concatNormal.y;
											_normalZ += _concatNormal.z;
										}
									}
								}
							}
							_firstVector.x = _normalX;
							_firstVector.y = _normalY;
							_firstVector.z = _normalZ;
							
							_normalX = _normal.x;
							_normalY = _normal.y;
							_normalZ = _normal.z;
							for (_i = 0; _i<_totalConcatFaces; _i++) {
								_concatFace = _concatFaces[_i];
								_concatVertex = _concatFace.vertex0;
								if (v1.screenX == _concatVertex.screenX && v1.screenY == _concatVertex.screenY && v1.screenZ == _concatVertex.screenZ) {
									_concatNormal = _concatFace.vector;
									_normalX += _concatNormal.x;
									_normalY += _concatNormal.y;
									_normalZ += _concatNormal.z;
								} else {
									_concatVertex = _concatFace.vertex1;
									if (v1.screenX == _concatVertex.screenX && v1.screenY == _concatVertex.screenY && v1.screenZ == _concatVertex.screenZ) {
										_concatNormal = _concatFace.vector;
										_normalX += _concatNormal.x;
										_normalY += _concatNormal.y;
										_normalZ += _concatNormal.z;
									} else {
										_concatVertex = _concatFace.vertex2;
										if (v1.screenX == _concatVertex.screenX && v1.screenY == _concatVertex.screenY && v1.screenZ == _concatVertex.screenZ) {
											_concatNormal = _concatFace.vector;
											_normalX += _concatNormal.x;
											_normalY += _concatNormal.y;
											_normalZ += _concatNormal.z;
										}
									}
								}
							}
							_secondVector.x = _normalX;
							_secondVector.y = _normalY;
							_secondVector.z = _normalZ;
							
							_normalX = _normal.x;
							_normalY = _normal.y;
							_normalZ = _normal.z;
							for (_i = 0; _i<_totalConcatFaces; _i++) {
								_concatFace = _concatFaces[_i];
								_concatVertex = _concatFace.vertex0;
								if (v2.screenX == _concatVertex.screenX && v2.screenY == _concatVertex.screenY && v2.screenZ == _concatVertex.screenZ) {
									_concatNormal = _concatFace.vector;
									_normalX += _concatNormal.x;
									_normalY += _concatNormal.y;
									_normalZ += _concatNormal.z;
								} else {
									_concatVertex = _concatFace.vertex1;
									if (v2.screenX == _concatVertex.screenX && v2.screenY == _concatVertex.screenY && v2.screenZ == _concatVertex.screenZ) {
										_concatNormal = _concatFace.vector;
										_normalX += _concatNormal.x;
										_normalY += _concatNormal.y;
										_normalZ += _concatNormal.z;
									} else {
										_concatVertex = _concatFace.vertex2;
										if (v2.screenX == _concatVertex.screenX && v2.screenY == _concatVertex.screenY && v2.screenZ == _concatVertex.screenZ) {
											_concatNormal = _concatFace.vector;
											_normalX += _concatNormal.x;
											_normalY += _concatNormal.y;
											_normalZ += _concatNormal.z;
										}
									}
								}
							}
							_thirdVector.x = _normalX;
							_thirdVector.y = _normalY;
							_thirdVector.z = _normalZ;
						}
						
						light.lightingTest(v0, _firstVector);
						strengthRatio = light.strengthRatio;
						if (strengthRatio<0) strengthRatio = isDouble ? -strengthRatio : 0;
						b0 += strengthRatio*k;
						
						light.lightingTest(v1, _secondVector);
						strengthRatio = light.strengthRatio;
						if (strengthRatio<0) strengthRatio = isDouble ? -strengthRatio : 0;
						b1 += strengthRatio*k;
						
						light.lightingTest(v2, _thirdVector);
						strengthRatio = light.strengthRatio;
						if (strengthRatio<0) strengthRatio = isDouble ? -strengthRatio : 0;
						b2 += strengthRatio*k;
					}
				}
				_renderTriangle(v0.screenX, -v0.screenY, v1.screenX, -v1.screenY, v2.screenX, -v2.screenY, uv0.u, uv0.v, uv1.u, uv1.v, uv2.u, uv2.v, material, selfLuminationStrength, b0, b1, b2);
			}
		}
		private function _perspectiveRender(faces:Vector.<TriangleFace>):void {
			var v0:Vertex3D;
			var v1:Vertex3D;
			var v2:Vertex3D;
			var uv0:UV;
			var uv1:UV;
			var uv2:UV;
			var length:int = faces.length;
			var material:CardMaterial;
			var light:AbstractLight;
			var k:Number;
			var strengthRatio:Number;
			var j:int;
			for (var i:int = 0; i<length; i++) {
				var face:TriangleFace = faces[i];
				if (!face.isMaterialFace) continue;
				material = face.material as CardMaterial;
				if (material == null) {
					material = _defaultMaterial;
					material.color = face.color;
				}
				var isDouble:Boolean = material.doubleSidedLightEnabled;
				var lightingReflectionRadio:Number = material.lightingReflectionRadio;
				var selfLuminationStrength:Number  = material.selfLuminationStrength;
				v0 = face.vertex0;
				v1 = face.vertex1;
				v2 = face.vertex2;
				uv0 = face.uv0;
				uv1 = face.uv1;
				uv2 = face.uv2;
				
				var b0:Number = 0;
				var b1:Number = 0;
				var b2:Number = 0;
				if (material.shadingType == SHADING_FLAT) {
					for (j = 0; j<_totalLights; j++) {
						light = _lightList[j];
						k = light.strength*lightingReflectionRadio;
						
						light.lightingTest(v0, face.vector);
						strengthRatio = light.strengthRatio;
						if (strengthRatio<0) strengthRatio = isDouble ? -strengthRatio : 0;
						b0 += strengthRatio*k;
						
						light.lightingTest(v1, face.vector);
						strengthRatio = light.strengthRatio;
						if (strengthRatio<0) strengthRatio = isDouble ? -strengthRatio : 0;
						b1 += strengthRatio*k;
						
						light.lightingTest(v2, face.vector);
						strengthRatio = light.strengthRatio;
						if (strengthRatio<0) strengthRatio = isDouble ? -strengthRatio : 0;
						b2 += strengthRatio*k;
					}
				} else {
					_concatFaces = face.concatFaces;
					_normal = face.vector;
					for (j = 0; j<_totalLights; j++) {
						light = _lightList[j];
						k = light.strength*lightingReflectionRadio;
						
						if (_concatFaces == null || (_totalConcatFaces = _concatFaces.length) == 0) {
							_firstVector.x = _normal.x;
							_firstVector.y = _normal.y;
							_firstVector.z = _normal.z;
							
							_secondVector.x = _normal.x;
							_secondVector.y = _normal.y;
							_secondVector.z = _normal.z;
							
							_thirdVector.x = _normal.x;
							_thirdVector.y = _normal.y;
							_thirdVector.z = _normal.z;
						} else {
							_totalConcatFaces = _concatFaces.length;
							_normalX = _normal.x;
							_normalY = _normal.y;
							_normalZ = _normal.z;
							for (_i = 0; _i<_totalConcatFaces; _i++) {
								_concatFace = _concatFaces[_i];
								_concatVertex = _concatFace.vertex0;
								if (v0.screenX == _concatVertex.screenX && v0.screenY == _concatVertex.screenY && v0.screenZ == _concatVertex.screenZ) {
									_concatNormal = _concatFace.vector;
									_normalX += _concatNormal.x;
									_normalY += _concatNormal.y;
									_normalZ += _concatNormal.z;
								} else {
									_concatVertex = _concatFace.vertex1;
									if (v0.screenX == _concatVertex.screenX && v0.screenY == _concatVertex.screenY && v0.screenZ == _concatVertex.screenZ) {
										_concatNormal = _concatFace.vector;
										_normalX += _concatNormal.x;
										_normalY += _concatNormal.y;
										_normalZ += _concatNormal.z;
									} else {
										_concatVertex = _concatFace.vertex2;
										if (v0.screenX == _concatVertex.screenX && v0.screenY == _concatVertex.screenY && v0.screenZ == _concatVertex.screenZ) {
											_concatNormal = _concatFace.vector;
											_normalX += _concatNormal.x;
											_normalY += _concatNormal.y;
											_normalZ += _concatNormal.z;
										}
									}
								}
							}
							_firstVector.x = _normalX;
							_firstVector.y = _normalY;
							_firstVector.z = _normalZ;
							
							_normalX = _normal.x;
							_normalY = _normal.y;
							_normalZ = _normal.z;
							for (_i = 0; _i<_totalConcatFaces; _i++) {
								_concatFace = _concatFaces[_i];
								_concatVertex = _concatFace.vertex0;
								if (v1.screenX == _concatVertex.screenX && v1.screenY == _concatVertex.screenY && v1.screenZ == _concatVertex.screenZ) {
									_concatNormal = _concatFace.vector;
									_normalX += _concatNormal.x;
									_normalY += _concatNormal.y;
									_normalZ += _concatNormal.z;
								} else {
									_concatVertex = _concatFace.vertex1;
									if (v1.screenX == _concatVertex.screenX && v1.screenY == _concatVertex.screenY && v1.screenZ == _concatVertex.screenZ) {
										_concatNormal = _concatFace.vector;
										_normalX += _concatNormal.x;
										_normalY += _concatNormal.y;
										_normalZ += _concatNormal.z;
									} else {
										_concatVertex = _concatFace.vertex2;
										if (v1.screenX == _concatVertex.screenX && v1.screenY == _concatVertex.screenY && v1.screenZ == _concatVertex.screenZ) {
											_concatNormal = _concatFace.vector;
											_normalX += _concatNormal.x;
											_normalY += _concatNormal.y;
											_normalZ += _concatNormal.z;
										}
									}
								}
							}
							_secondVector.x = _normalX;
							_secondVector.y = _normalY;
							_secondVector.z = _normalZ;
							
							_normalX = _normal.x;
							_normalY = _normal.y;
							_normalZ = _normal.z;
							for (_i = 0; _i<_totalConcatFaces; _i++) {
								_concatFace = _concatFaces[_i];
								_concatVertex = _concatFace.vertex0;
								if (v2.screenX == _concatVertex.screenX && v2.screenY == _concatVertex.screenY && v2.screenZ == _concatVertex.screenZ) {
									_concatNormal = _concatFace.vector;
									_normalX += _concatNormal.x;
									_normalY += _concatNormal.y;
									_normalZ += _concatNormal.z;
								} else {
									_concatVertex = _concatFace.vertex1;
									if (v2.screenX == _concatVertex.screenX && v2.screenY == _concatVertex.screenY && v2.screenZ == _concatVertex.screenZ) {
										_concatNormal = _concatFace.vector;
										_normalX += _concatNormal.x;
										_normalY += _concatNormal.y;
										_normalZ += _concatNormal.z;
									} else {
										_concatVertex = _concatFace.vertex2;
										if (v2.screenX == _concatVertex.screenX && v2.screenY == _concatVertex.screenY && v2.screenZ == _concatVertex.screenZ) {
											_concatNormal = _concatFace.vector;
											_normalX += _concatNormal.x;
											_normalY += _concatNormal.y;
											_normalZ += _concatNormal.z;
										}
									}
								}
							}
							_thirdVector.x = _normalX;
							_thirdVector.y = _normalY;
							_thirdVector.z = _normalZ;
						}
						
						light.lightingTest(v0, _firstVector);
						strengthRatio = light.strengthRatio;
						if (strengthRatio<0) strengthRatio = isDouble ? -strengthRatio : 0;
						b0 += strengthRatio*k;
						
						light.lightingTest(v1, _secondVector);
						strengthRatio = light.strengthRatio;
						if (strengthRatio<0) strengthRatio = isDouble ? -strengthRatio : 0;
						b1 += strengthRatio*k;
						
						light.lightingTest(v2, _thirdVector);
						strengthRatio = light.strengthRatio;
						if (strengthRatio<0) strengthRatio = isDouble ? -strengthRatio : 0;
						b2 += strengthRatio*k;
					}
				}
				_renderTriangle(v0.cameraX, -v0.cameraY, v1.cameraX, -v1.cameraY, v2.cameraX, -v2.cameraY, uv0.u, uv0.v, uv1.u, uv1.v, uv2.u, uv2.v, material, selfLuminationStrength, b0, b1, b2);
			}
		}
		private function _renderTriangle(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, u0:Number, v0:Number, u1:Number, v1:Number, u2:Number, v2:Number, material:CardMaterial, selfLuminationStrength:Number, brightness0:Number, brightness1:Number, brightness2:Number):void {
			var map:BitmapData;
			if (material._diffuseTextureEnabled) {
				map = material._diffuseBitmapData;
				_graphics.beginBitmapFill(map, null, false, _isSmooth);
				_verticesVector[0] = x0;
				_verticesVector[1] = y0;
				_verticesVector[2] = x1;
				_verticesVector[3] = y1;
				_verticesVector[4] = x2;
				_verticesVector[5] = y2;
				_uvVector[0] = u0;
				_uvVector[1] = v0;
				_uvVector[2] = u1;
				_uvVector[3] = v1;
				_uvVector[4] = u2;
				_uvVector[5] = v2;
				_graphics.drawTriangles(_verticesVector, null, _uvVector, triangleCulling)
			} else {
				_graphics.beginFill(material.color&0x00FFFFFF, (material.color>>24&0xFF)/255);
				_graphics.moveTo(x0, y0);
				_graphics.lineTo(x1, y1);
				_graphics.lineTo(x2, y2);
				_graphics.lineTo(x0, y0);
			}
			if (material.shadingType == SHADING_FLAT) {
				var brightness:Number = (brightness0+brightness1+brightness2)/3+selfLuminationStrength;
				if (brightness>1) brightness = 1;
				map = material._lightBitmapData;
				_lightGraphics.beginFill(map.getPixel((map.width-1)*brightness, 0));
				_lightGraphics.moveTo(x0, y0);
				_lightGraphics.lineTo(x1, y1);
				_lightGraphics.lineTo(x2, y2);
				_lightGraphics.lineTo(x0, y0);
			} else {
				brightness0 += selfLuminationStrength;
				brightness1 += selfLuminationStrength;
				brightness2 += selfLuminationStrength;
				if (brightness0>1) brightness0 = 1;
				if (brightness1>1) brightness1 = 1;
				if (brightness2>1) brightness2 = 1;
				map = material._lightBitmapData;
				if (brightness0 == brightness1 && brightness0 == brightness2) {
					_lightGraphics.beginFill(map.getPixel((map.width-1)*brightness0, 0));
					_lightGraphics.moveTo(x0, y0);
					_lightGraphics.lineTo(x1, y1);
					_lightGraphics.lineTo(x2, y2);
					_lightGraphics.lineTo(x0, y0);
				} else {
					_lightGraphics.beginBitmapFill(map, null, false);
					_verticesVector[0] = x0;
					_verticesVector[1] = y0;
					_verticesVector[2] = x1;
					_verticesVector[3] = y1;
					_verticesVector[4] = x2;
					_verticesVector[5] = y2;
					_uvLightVector[0] = brightness0;
					_uvLightVector[2] = brightness1;
					_uvLightVector[4] = brightness2;
					_lightGraphics.drawTriangles(_verticesVector, null, _uvLightVector, triangleCulling)
				}
			}
		}
		private function _reductionMaterial():void {
			if (materials == null) return;
			for (var i:int = materials.length-1; i>=0; i--) {
				var material:Material = materials[i];
				if (material._diffuseTextureEnabled && material._bumpTextureEnabled) {
					material._diffuseBitmapData.dispose();
					material._diffuseBitmapData = _diffuseList[i];
				}
			}
			_diffuseList = null;
		}
		private function _transformMaterial():void {
			if (materials == null) return;
			_diffuseList = [];
			var diffuse:BitmapData;
			for (var i:int = materials.length-1; i>=0; i--) {
				var material:Material = materials[i];
				if (material._diffuseTextureEnabled && material._bumpTextureEnabled) {
					diffuse = material._diffuseBitmapData;
					_diffuseList[i] = diffuse;
					material._diffuseBitmapData = Image.diffuseAndBumpBlend(diffuse, material._bumpBitmapData);
				}
			}
		}
	}
}