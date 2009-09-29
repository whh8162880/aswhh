package asgl.handlers {
	import __AS3__.vec.Vector;
	
	import asgl.drivers.AbstractRenderDriver;
	import asgl.drivers.ProjectionType;
	import asgl.events.Mouse3DEvent;
	import asgl.math.Vertex3D;
	import asgl.mesh.TriangleFace;
	import asgl.utils.Mouse3D;
	
	import flash.display.InteractiveObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	[Event(name="click", type="asgl.events.Mouse3DEvent")]
	[Event(name="mouseDown", type="asgl.events.Mouse3DEvent")]
	[Event(name="mouseMove", type="asgl.events.Mouse3DEvent")]
	[Event(name="mouseOut", type="asgl.events.Mouse3DEvent")]
	[Event(name="mouseOver", type="asgl.events.Mouse3DEvent")]
	[Event(name="mouseUp", type="asgl.events.Mouse3DEvent")]

	public class Mouse3DDetector extends EventDispatcher implements IHandler {
		public var useCustomFaces:Boolean = false;
		public var originOffsetX:Number;
		public var originOffsetY:Number;
		private var _moveHasFace:Boolean = false;
		private var _interactiveObject:InteractiveObject;
		private var _mouse:Mouse3D = new Mouse3D();
		private var _stageMouseUpPoint:Point = new Point();
		private var _stage:Stage;
		private var _mouseDownFace:TriangleFace;
		private var _clickVertex:Vertex3D = new Vertex3D();
		public function Mouse3DDetector(interactiveObject:InteractiveObject=null, originOffsetX:Number=0, originOffsetY:Number=0):void {
			this.interactiveObject = interactiveObject;
			this.originOffsetX = originOffsetX;
			this.originOffsetY = originOffsetY;
		}
		public function set customFaces(value:Vector.<TriangleFace>):void {
			if (useCustomFaces) _mouse.faces = value;
		}
		public function get interactiveObject():InteractiveObject {
			return _interactiveObject;
		}
		public function set interactiveObject(value:InteractiveObject):void {
			if (_interactiveObject != value) {
				if (_interactiveObject != null) {
					_interactiveObject.removeEventListener(MouseEvent.MOUSE_DOWN, _mouseDownHandler);
					_interactiveObject.removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMoveHandler);
					_interactiveObject.removeEventListener(MouseEvent.MOUSE_UP, _mouseUpHandler);
					_interactiveObject.removeEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
					if (_stage != null) {
						_stage.removeEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
						_stage.removeEventListener(MouseEvent.MOUSE_UP, _stageMouseUpHandler);
						_stage = null;
					}
				}
				_interactiveObject = value;
				_mouseDownFace = null;
				if (_interactiveObject != null) {
					if (hasEventListener(Mouse3DEvent.MOUSE_DOWN)) _interactiveObject.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDownHandler);
					if (hasEventListener(Mouse3DEvent.MOUSE_MOVE) || hasEventListener(Mouse3DEvent.MOUSE_OUT) || hasEventListener(Mouse3DEvent.MOUSE_OVER)) _interactiveObject.addEventListener(MouseEvent.MOUSE_MOVE, _mouseMoveHandler);
					if (hasEventListener(Mouse3DEvent.MOUSE_UP))_interactiveObject.addEventListener(MouseEvent.MOUSE_UP, _mouseUpHandler);
					if (hasEventListener(Mouse3DEvent.CLICK)) {
						_mouseDownFace = null;
						_interactiveObject.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDownHandler);
						_stage = _interactiveObject.stage;
						if (_stage == null) {
							_interactiveObject.addEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
						} else {
							_addedToStageHandler(null);
						}
					}
				}
			}
		}
		public override function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
			if (_interactiveObject != null) {
				if (type == Mouse3DEvent.MOUSE_DOWN) {
					_interactiveObject.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDownHandler);
				} else if (type == Mouse3DEvent.MOUSE_MOVE || type == Mouse3DEvent.MOUSE_OUT || type == Mouse3DEvent.MOUSE_OVER) {
					_interactiveObject.addEventListener(MouseEvent.MOUSE_MOVE, _mouseMoveHandler);
				} else if (type == Mouse3DEvent.MOUSE_UP) {
					_interactiveObject.addEventListener(MouseEvent.MOUSE_UP, _mouseUpHandler);
				} else if (type == Mouse3DEvent.CLICK) {
					_mouseDownFace = null;
					_interactiveObject.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDownHandler);
					_stage = _interactiveObject.stage;
					if (_stage == null) {
						_interactiveObject.addEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
					} else {
						_addedToStageHandler(null);
					}
				}
			}
		}
		public function clear():void {
			_mouse.clear();
			this.interactiveObject = null;
			_moveHasFace = false;
		}
		public function handle(driver:AbstractRenderDriver, faces:Vector.<TriangleFace>, completeFucntion:Function):void {
			_mouse.camera = driver.camera;
			if (!useCustomFaces) _mouse.faces = faces.concat();
			_mouse.isPerspective = driver.projectionType == ProjectionType.PERSPECTIVE;
			completeFucntion(faces);
		}
		public override function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
			super.removeEventListener(type, listener, useCapture);
			if (_interactiveObject != null) {
				if (type == Mouse3DEvent.MOUSE_DOWN) {
					if (!hasEventListener(type)) _interactiveObject.removeEventListener(MouseEvent.MOUSE_DOWN, _mouseDownHandler);
				} else if (type == Mouse3DEvent.MOUSE_MOVE || type == Mouse3DEvent.MOUSE_OUT || type == Mouse3DEvent.MOUSE_OVER) {
					if (!hasEventListener(Mouse3DEvent.MOUSE_MOVE) && !hasEventListener(Mouse3DEvent.MOUSE_OUT) && !hasEventListener(Mouse3DEvent.MOUSE_OVER)) _interactiveObject.removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMoveHandler);
				} else if (type == Mouse3DEvent.MOUSE_UP) {
					if (!hasEventListener(type)) _interactiveObject.removeEventListener(MouseEvent.MOUSE_UP, _mouseUpHandler);
				} else if (type == Mouse3DEvent.CLICK) {
					if (!hasEventListener(Mouse3DEvent.MOUSE_DOWN)) _interactiveObject.removeEventListener(MouseEvent.MOUSE_DOWN, _mouseDownHandler);
					if (_stage != null) {
						_stage.removeEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
						_stage.removeEventListener(MouseEvent.MOUSE_UP, _stageMouseUpHandler);
						_stage = null;
					}
					_mouseDownFace = null;
				}
			}
		}
		private function _addedToStageHandler(e:Event):void {
			_interactiveObject.removeEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
			_stage = _interactiveObject.stage;
			_stage.addEventListener(MouseEvent.MOUSE_UP, _stageMouseUpHandler);
		}
		private function _mouseDownHandler(e:MouseEvent):void {
			var face:TriangleFace = _mouse.click(e.localX+originOffsetX, e.localY+originOffsetY, _clickVertex);
			if (hasEventListener(Mouse3DEvent.CLICK)) _mouseDownFace = face;
			if (face != null) dispatchEvent(new Mouse3DEvent(Mouse3DEvent.MOUSE_DOWN, face, _mouse.isPerspective ? _clickVertex.cloneCamera() : _clickVertex.cloneScreen()));
		}
		private function _mouseMoveHandler(e:MouseEvent):void {
			var face:TriangleFace = _mouse.click(e.localX+originOffsetX, e.localY+originOffsetY, _clickVertex);
			var hasFace:Boolean = face != null;
			if (face != null && hasEventListener(Mouse3DEvent.MOUSE_MOVE)) dispatchEvent(new Mouse3DEvent(Mouse3DEvent.MOUSE_MOVE, face, _mouse.isPerspective ? _clickVertex.cloneCamera() : _clickVertex.cloneScreen()));
			if (_moveHasFace && !hasFace && hasEventListener(Mouse3DEvent.MOUSE_OUT)) dispatchEvent(new Mouse3DEvent(Mouse3DEvent.MOUSE_OUT));
			if (!_moveHasFace && hasFace && hasEventListener(Mouse3DEvent.MOUSE_OVER)) dispatchEvent(new Mouse3DEvent(Mouse3DEvent.MOUSE_OVER, face, _mouse.isPerspective ? _clickVertex.cloneCamera() : _clickVertex.cloneScreen()));
			_moveHasFace = hasFace;
		}
		private function _mouseUpHandler(e:MouseEvent):void {
			var face:TriangleFace = _mouse.click(e.localX+originOffsetX, e.localY+originOffsetY, _clickVertex);
			if (face != null) dispatchEvent(new Mouse3DEvent(Mouse3DEvent.MOUSE_UP, face, _mouse.isPerspective ? _clickVertex.cloneCamera() : _clickVertex.cloneScreen()));
		}
		private function _stageMouseUpHandler(e:MouseEvent):void {
			if (_mouseDownFace != null) {
				_stageMouseUpPoint.x = e.stageX;
				_stageMouseUpPoint.y = e.stageY;
				_stageMouseUpPoint = _interactiveObject.globalToLocal(_stageMouseUpPoint);
				var face:TriangleFace = _mouse.click(_stageMouseUpPoint.x+originOffsetX, _stageMouseUpPoint.y+originOffsetY, _clickVertex);
				var face2:TriangleFace = _mouseDownFace;
				_mouseDownFace = null;
				if (face != null && face2 == face) dispatchEvent(new Mouse3DEvent(Mouse3DEvent.CLICK, face, _mouse.isPerspective ? _clickVertex.cloneCamera() : _clickVertex.cloneScreen()));
			}
		}
	}
}