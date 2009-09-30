package asgl.renderers {
	import __AS3__.vec.Vector;
	
	import asgl.drivers.AbstractRenderDriver;
	import asgl.drivers.ProjectionType;
	import asgl.materials.Material;
	import asgl.math.UV;
	import asgl.math.Vertex3D;
	import asgl.mesh.FaceType;
	import asgl.mesh.TriangleFace;
	import asgl.utils.Image;
	import asgl.views.IView;
	import asgl.views.ViewType;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.TriangleCulling;
	/**
	 * CardRenderer. this is a false 3d renderer.
	 * <p>Support:</p>
	 * <p>face:MaterialFace.</p>
	 * <p>FSAA:normal, h2x, v2x, 4x.</p>
	 * <p>selfLuminationStrength.</p>
	 */
	public class BaseCardRenderer implements IRenderer {
		public var triangleCulling:String;
		public var materials:Vector.<Material>;
		private var _defaultMaterial:Material = new Material();
		private var _defaultCanvas:Shape = new Shape();
		private var _currentGraphics:Graphics;
		private var _defaultGraphics:Graphics = _defaultCanvas.graphics;
		private var _isSmooth:Boolean = false;
		private var _FSAALevel:String = FullSceneAntiAliasLevel.NORMAL;
		private var _diffuseList:Vector.<BitmapData>;
		private var _uvVector:Vector.<Number> = new Vector.<Number>(6, true);
		private var _verticesVector:Vector.<Number> = new Vector.<Number>(6, true);
		public function BaseCardRenderer(materials:Vector.<Material>=null, triangleCulling:String=TriangleCulling.NONE):void {
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
			materials = null;
			_defaultCanvas = null;
			_defaultGraphics = null;
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
				_transformMaterial();
				if (driver.projectionType == ProjectionType.PARALLEL) {
					_parallelRender(faces);
				} else {
					_perspectiveRender(faces);
				}
				if (isBitmapData) {
					(view.canvas as BitmapData).draw(_defaultCanvas);
					_currentGraphics.clear();
				}
				_currentGraphics = null;
				_reductionMaterial();
			}
			completeFunction();
		}
		private function _parallelRender(faces:Vector.<TriangleFace>):void {
			var v0:Vertex3D;
			var v1:Vertex3D;
			var v2:Vertex3D;
			var uv0:UV;
			var uv1:UV;
			var uv2:UV;
			var length:int = faces.length;
			var material:Material;
			for (var i:int = 0; i<length; i++) {
				var face:TriangleFace = faces[i];
				if (!face.isMaterialFace) continue;
				material = face.material;
				if (material == null) {
					material = _defaultMaterial;
					material.color = face.color;
				}
				v0 = face.vertex0;
				v1 = face.vertex1;
				v2 = face.vertex2;
				uv0 = face.uv0;
				uv1 = face.uv1;
				uv2 = face.uv2;
				_renderTriangle(v0.screenX, -v0.screenY, v1.screenX, -v1.screenY, v2.screenX, -v2.screenY, uv0.u, uv0.v, uv1.u, uv1.v, uv2.u, uv2.v, material);
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
			var material:Material;
			for (var i:int = 0; i<length; i++) {
				var face:TriangleFace = faces[i];
				if (!face.isMaterialFace) continue;
				material = face.material;
				if (material == null) {
					material = _defaultMaterial;
					material.color = face.color;
				}
				v0 = face.vertex0;
				v1 = face.vertex1;
				v2 = face.vertex2;
				uv0 = face.uv0;
				uv1 = face.uv1;
				uv2 = face.uv2;
				_renderTriangle(v0.cameraX, -v0.cameraY, v1.cameraX, -v1.cameraY, v2.cameraX, -v2.cameraY, uv0.u, uv0.v, uv1.u, uv1.v, uv2.u, uv2.v, material);
			}
		}
		private function _reductionMaterial():void {
			if (materials == null) return;
			for (var i:int = materials.length-1; i>=0; i--) {
				var material:Material = materials[i];
				if (material._diffuseTextureEnabled) {
					material._diffuseBitmapData.dispose();
					material._diffuseBitmapData = _diffuseList[i];
				}
			}
			_diffuseList = null;
		}
		private function _renderTriangle(x1:Number, y1:Number, x2:Number, y2:Number, x3:Number, y3:Number, u1:Number, v1:Number, u2:Number, v2:Number, u3:Number, v3:Number, material:Material):void {
			if (material._diffuseTextureEnabled) {
				_currentGraphics.beginBitmapFill(material._diffuseBitmapData, null, false, _isSmooth);
				_verticesVector[0] = x1;
				_verticesVector[1] = y1;
				_verticesVector[2] = x2;
				_verticesVector[3] = y2;
				_verticesVector[4] = x3;
				_verticesVector[5] = y3;
				_uvVector[0] = u1;
				_uvVector[1] = v1;
				_uvVector[2] = u2;
				_uvVector[3] = v2;
				_uvVector[4] = u3;
				_uvVector[5] = v3;
				_currentGraphics.drawTriangles(_verticesVector, null, _uvVector, triangleCulling)
			} else {
				_currentGraphics.beginFill(material.color&0x00FFFFFF, (material.color>>24&0xFF)/255);
				_currentGraphics.moveTo(x1, y1);
				_currentGraphics.lineTo(x2, y2);
				_currentGraphics.lineTo(x3, y3);
				_currentGraphics.lineTo(x1, y1);
			}
		}
		private function _transformMaterial():void {
			if (materials == null) return;
			_diffuseList = new Vector.<BitmapData>();
			var diffuse:BitmapData;
			for (var i:int = materials.length-1; i>=0; i--) {
				var material:Material = materials[i];
				if (material._diffuseTextureEnabled) {
					diffuse = material._diffuseBitmapData;
					_diffuseList[i] = diffuse;
					material._diffuseBitmapData = Image.setBrightness(diffuse, material.selfLuminationStrength);
				}
			}
		}
	}
}