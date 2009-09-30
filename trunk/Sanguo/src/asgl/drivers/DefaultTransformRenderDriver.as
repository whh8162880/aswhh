package asgl.drivers {
	import __AS3__.vec.Vector;
	
	import asgl.cameras.Camera3D;
	import asgl.handlers.AllFacesClip;
	import asgl.handlers.MaterialFacesClip;
	import asgl.handlers.ScreenSpaceToCameraSpaceVerticesTransform;
	import asgl.handlers.ShapeFacesClip;
	import asgl.handlers.WorldSpaceToScreenSpaceVerticesTransform;
	import asgl.mesh.FaceType;
	import asgl.mesh.TriangleFace;
	import asgl.renderers.IRenderer;
	import asgl.views.IView;
	
	public class DefaultTransformRenderDriver extends FreeRenderDriver {
		private var _worldToScreenHandler:WorldSpaceToScreenSpaceVerticesTransform = new WorldSpaceToScreenSpaceVerticesTransform();
		private var _screenToCameraHandler:ScreenSpaceToCameraSpaceVerticesTransform = new ScreenSpaceToCameraSpaceVerticesTransform();
		private var _allFacesClipHandler:AllFacesClip = new AllFacesClip();
		private var _shapeFacesClipHandler:ShapeFacesClip = new ShapeFacesClip();
		private var _materialFacesClipHandler:MaterialFacesClip = new MaterialFacesClip();
		public function DefaultTransformRenderDriver(camera:Camera3D=null, view:IView=null, renderer:IRenderer=null):void {
			super(camera, view, renderer);
		}
		protected override function _startRender():void {
			_view.reset(_camera.width, _camera.height, backgroundColor);
			_resultFaces = faces == null ? new Vector.<TriangleFace>() : faces.concat();
			var facesClipType:String = _renderer.facesType; 
			_worldToScreenHandler.handle(this, _resultFaces, _defaultHandlerComplete);
			if (facesClipType == FaceType.MATERIAL_FACE) {
				_materialFacesClipHandler.handle(this, _resultFaces, _defaultHandlerComplete);
			} else if (facesClipType == FaceType.ALL_FACE) {
				_allFacesClipHandler.handle(this, _resultFaces, _defaultHandlerComplete);
			} else {
				_shapeFacesClipHandler.handle(this, _resultFaces, _defaultHandlerComplete);
			}
			if (_projectionType == ProjectionType.PERSPECTIVE) _screenToCameraHandler.handle(this, _resultFaces, _defaultHandlerComplete);
			_canRunRenderer = true;
			runHandlers();
		}
		private function _defaultHandlerComplete(faces:Vector.<TriangleFace>):void {
			_resultFaces = faces;
		}
	}
}