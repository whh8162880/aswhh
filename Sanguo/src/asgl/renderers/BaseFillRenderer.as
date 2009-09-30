package asgl.renderers {
	import __AS3__.vec.Vector;
	
	import asgl.cameras.Camera3D;
	import asgl.drivers.AbstractRenderDriver;
	import asgl.drivers.ProjectionType;
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
	 */
	public class BaseFillRenderer implements IRenderer {
		private var _defaultCanvas:Shape = new Shape();
		private var _currentGraphics:Graphics;
		private var _defaultGraphics:Graphics = _defaultCanvas.graphics;
		public function get facesType():String {
			return FaceType.SHAPE_FACE;
		}
		public function destroy():void {
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
				if (driver.projectionType == ProjectionType.PERSPECTIVE) {
					_perspectiveRender(faces);
				} else {
					_parallelRender(faces);
				}
				if (isBitmapData) {
					(view.canvas as BitmapData).draw(_defaultCanvas);
					_currentGraphics.clear();
				}
				_currentGraphics = null;
			}
			completeFunction();
		}
		private function _parallelRender(faces:Vector.<TriangleFace>):void {
			var startX:Number;
			var startY:Number;
			var x:Number;
			var y:Number;
			var j:int;
			var vertex:Vertex3D;
			var totalFaces:int = faces.length;
			for (var i:int = 0; i<totalFaces; i++) {
				var face:TriangleFace = faces[i];
				_currentGraphics.beginFill(face.color&0x00FFFFFF, (face.color>>24&0xFF)/255);
				
				vertex = face.vertex0;
				startX = vertex.screenX;
				startY = -vertex.screenY;
				_currentGraphics.moveTo(startX, startY);
				
				vertex = face.vertex1;
				_currentGraphics.lineTo(vertex.screenX, -vertex.screenY);
				
				vertex = face.vertex2;
				_currentGraphics.lineTo(vertex.screenX, -vertex.screenY);
				
				_currentGraphics.lineTo(startX, startY);
			}
		}
		private function _perspectiveRender(faces:Vector.<TriangleFace>):void {
			var startX:Number;
			var startY:Number;
			var x:Number;
			var y:Number;
			var j:int;
			var vertex:Vertex3D;
			var totalFaces:int = faces.length;
			for (var i:int = 0; i<totalFaces; i++) {
				var face:TriangleFace = faces[i];
				_currentGraphics.beginFill(face.color&0x00FFFFFF, (face.color>>24&0xFF)/255);
				
				vertex = face.vertex0;
				startX = vertex.cameraX;
				startY = -vertex.cameraY;
				_currentGraphics.moveTo(startX, startY);
				
				vertex = face.vertex1;
				_currentGraphics.lineTo(vertex.cameraX, -vertex.cameraY);
				
				vertex = face.vertex2;
				_currentGraphics.lineTo(vertex.cameraX, -vertex.cameraY);
				
				_currentGraphics.lineTo(startX, startY);
			}
		}
	}
}