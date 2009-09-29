package asgl.renderers {
	import __AS3__.vec.Vector;
	
	import asgl.cameras.Camera3D;
	import asgl.drivers.AbstractRenderDriver;
	import asgl.drivers.ProjectionType;
	import asgl.lights.AbstractLight;
	import asgl.math.Color;
	import asgl.math.Vertex3D;
	import asgl.mesh.FaceType;
	import asgl.mesh.TriangleFace;
	import asgl.views.IView;
	import asgl.views.ViewType;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	/**
	 * FillRenderer.
	 * <p>Support:</p>
	 * <p>face:ShapeFace.</p>
	 * <p>light:all lights.if has lights, need screen vector of faces</p>
	 */
	public class FillRenderer implements IRenderer {
		private var _light:AbstractLight;
		private var _useBlendColor:Boolean;
		private var _defaultCanvas:Shape = new Shape();
		private var _currentGraphics:Graphics;
		private var _defaultGraphics:Graphics = _defaultCanvas.graphics;
		private var _colorRed:int;
		private var _colorGreen:int;
		private var _colorBlue:int;
		private var _i:int;
		private var _totalFaces:int;
		private var _totalLights:int;
		private var _brightness:Number;
		private var _lightStrength:Number;
		private var _startX:Number;
		private var _startY:Number;
		private var _strength:Number;
		private var _strengthRatio:Number;
		private var _blendColor:uint;
		private var _color:uint;
		private var _tempColor:uint;
		private var _lightArray:Vector.<AbstractLight>;
		private var _faceArray:Vector.<TriangleFace>;
		private var _screenVertex:Vertex3D = new Vertex3D();
		public function get facesType():String {
			return FaceType.SHAPE_FACE;
		}
		public function destroy():void {
			_defaultCanvas = null;
			_defaultGraphics = null;
			_screenVertex = null;
		}
		public function render(driver:AbstractRenderDriver, faces:Vector.<TriangleFace>, completeFunction:Function):void {
			var view:IView = driver.view;
			var viewType:String = view.viewType;
			var isBitmapData:Boolean = viewType == ViewType.BITMAPDATA;
			if (isBitmapData) {
				_currentGraphics = _defaultGraphics;
			} else if (viewType == ViewType.SHAPE) {
				_currentGraphics = (view.canvas as Shape).graphics;
			} else if (viewType == ViewType.SPRITE) {
				_currentGraphics = (view.canvas as Sprite).graphics;
			}
			
			if (_currentGraphics != null) {
				_faceArray = faces;
				_totalFaces = _faceArray.length;
				_lightArray = driver.lights == null ? new Vector.<AbstractLight>() : driver.lights;
				_totalLights = _lightArray.length;
				for (var i:int = 0; i<_totalLights; i++) {
					_lightArray[i].init(driver);
				}
				if (driver.projectionType == ProjectionType.PERSPECTIVE) {
					_perspectiveRender(faces);
				} else {
					_parallelRender(faces);
				}
				for (i = 0; i<_totalLights; i++) {
					_lightArray[i].complete();
				}
				if (isBitmapData) {
					(view.canvas as BitmapData).draw(_defaultCanvas);
					_currentGraphics.clear();
				}
				_currentGraphics = null;
				_light = null;
				_faceArray = null;
				_lightArray = null;
			}
			completeFunction();
		}
		private function _parallelRender(faces:Vector.<TriangleFace>):void {
			for (var i:int = 0; i<_totalFaces; i++) {
				var face:TriangleFace = _faceArray[i];
				var v0:Vertex3D = face.vertex0;
				var v1:Vertex3D = face.vertex1;
				var v2:Vertex3D = face.vertex2;
				_color = face.color&0x00FFFFFF;
				_strength = 0;
				_useBlendColor = false;
				for (_i = 0; _i<_totalLights; _i++) {
					_light = _lightArray[_i];
					_screenVertex.screenX = (v0.screenX+v1.screenX+v2.screenX)/3;
					_screenVertex.screenY = (v0.screenY+v1.screenY+v2.screenY)/3;
					_screenVertex.screenZ = (v0.screenZ+v1.screenZ+v2.screenZ)/3;
					_light.lightingTest(_screenVertex, face.vector);
					_strengthRatio = _light.strengthRatio;
					if (_strengthRatio<0) _strengthRatio = 0;
					_lightStrength = _light.strength*_strengthRatio;
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
					}
				}
				if (_strength>1) _strength = 1;
				_brightness = _strength;//(_strength+1)*0.5;
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
					_color = (_color>>24&0xFF)<<24|_colorRed<<16|_colorGreen<<8|_colorBlue;
				}
				if (_useBlendColor) _color = Color.colorBlend(_color, _blendColor);
				
				_currentGraphics.beginFill(_color, (face.color>>24&0xFF)/255);
				
				_startX = v0.screenX;
				_startY = -v0.screenY;
				_currentGraphics.moveTo(_startX, _startY);
				_currentGraphics.lineTo(v1.screenX, -v1.screenY);
				_currentGraphics.lineTo(v2.screenX, -v2.screenY);
				_currentGraphics.lineTo(_startX, _startY);
			}
		}
		private function _perspectiveRender(faces:Vector.<TriangleFace>):void {
			for (var i:int = 0; i<_totalFaces; i++) {
				var face:TriangleFace = _faceArray[i];
				var v0:Vertex3D = face.vertex0;
				var v1:Vertex3D = face.vertex1;
				var v2:Vertex3D = face.vertex2;
				_color = face.color&0x00FFFFFF;
				_strength = 0;
				_useBlendColor = false;
				for (_i = 0; _i<_totalLights; _i++) {
					_light = _lightArray[_i];
					_screenVertex.screenX = (v0.screenX+v1.screenX+v2.screenX)/3;
					_screenVertex.screenY = (v0.screenY+v1.screenY+v2.screenY)/3;
					_screenVertex.screenZ = (v0.screenZ+v1.screenZ+v2.screenZ)/3;
					_light.lightingTest(_screenVertex, face.vector);
					_strengthRatio = _light.strengthRatio;
					if (_strengthRatio<0) _strengthRatio = 0;
					_lightStrength = _light.strength*_strengthRatio;
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
					}
				}
				if (_strength>1) _strength = 1;
				_brightness = _strength;//(_strength+1)*0.5;
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
				
				_currentGraphics.beginFill(_color, (face.color>>24&0xFF)/255);
				
				_startX = v0.cameraX;
				_startY = -v0.cameraY;
				_currentGraphics.moveTo(_startX, _startY);
				_currentGraphics.lineTo(v1.cameraX, -v1.cameraY);
				_currentGraphics.lineTo(v2.cameraX, -v2.cameraY);
				_currentGraphics.lineTo(_startX, _startY);
			}
		}
	}
}