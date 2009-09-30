package asgl.utils {
	import __AS3__.vec.Vector;
	
	import asgl.math.Coordinates3D;
	import asgl.math.GLMatrix3D;
	import asgl.math.Vertex3D;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	public class RotationControlSphere extends Sprite {
		private static const COLOR_BG:uint = 0x666666;
		private static const COLOR_X:uint = 0xFF0000;
		private static const COLOR_Y:uint = 0xFF00;
		private static const COLOR_Z:uint = 0xFF;
		/**
		 * function()
		 */
		public var axisXmouseDownHandler:Function;
		public var axisYmouseDownHandler:Function;
		public var axisZmouseDownHandler:Function;
		/**
		 * function(currentAngle:Number)
		 */
		public var axisXmouseMoveHandler:Function;
		public var axisYmouseMoveHandler:Function;
		public var axisZmouseMoveHandler:Function;
		/**
		 * function(totalAngle:Number)
		 */
		public var axisXmouseUpHandler:Function;
		public var axisYmouseUpHandler:Function;
		public var axisZmouseUpHandler:Function;
		public var coordToAngleRatio:Number;
		public var thickness:uint;
		private var _coord:Coordinates3D = new Coordinates3D();
		private var _angle:Number;
		private var _backgroundAlpha:Number;
		private var _foregroundAlpha:Number;
		private var _mouseX:Number;
		private var _mouseY:Number;
		private var _radius:Number;
		private var _lineXBg:Sprite = new Sprite();
		private var _lineYBg:Sprite = new Sprite();
		private var _lineZBg:Sprite = new Sprite();
		private var _lineX:Sprite = new Sprite();
		private var _lineY:Sprite = new Sprite();
		private var _lineZ:Sprite = new Sprite();
		private var _stage:Stage;
		private var _txt:TextField = new TextField();
		private var _samplingListX:Vector.<Vertex3D> = new Vector.<Vertex3D>();
		private var _samplingListY:Vector.<Vertex3D> = new Vector.<Vertex3D>();
		private var _samplingListZ:Vector.<Vertex3D> = new Vector.<Vertex3D>();
		public function RotationControlSphere(radius:Number=50, samplingAmount:uint=30, thickness:uint=1, foregroundAlpha:Number=1, backgroundAlpha:Number=0.5, coordToAngleRatio:Number=1):void {
			_radius = radius;
			this.thickness = thickness;
			this.foregroundAlpha = foregroundAlpha;
			this.backgroundAlpha = backgroundAlpha;
			this.coordToAngleRatio = coordToAngleRatio;
			if (samplingAmount<4) samplingAmount = 4;
			var a:Number = 360/samplingAmount;
			var coord:Coordinates3D = new Coordinates3D();
			
			var v:Vertex3D = new Vertex3D(0, 0, radius);
			_coord.addVertex(v);
			_samplingListX[0] = v;
			for (var i:int = 1; i<samplingAmount; i++) {
				v = new Vertex3D(0, 0, radius);
				_samplingListX[i] = v;
				coord.localRotationX = a;
				coord.addVertex(v);
				v.localX = v.worldX;
				v.localY = v.worldY;
				v.localZ = v.worldZ;
				coord.removeVertex(v);
				_coord.addVertex(v);
			}
			
			v = new Vertex3D(radius);
			_coord.addVertex(v);
			_samplingListY[0] = v;
			coord.reset();
			for (i = 1; i<samplingAmount; i++) {
				v = new Vertex3D(radius);
				_samplingListY[i] = v;
				coord.localRotationY = a;
				coord.addVertex(v);
				v.localX = v.worldX;
				v.localY = v.worldY;
				v.localZ = v.worldZ;
				coord.removeVertex(v);
				_coord.addVertex(v);
			}
			
			v = new Vertex3D(radius);
			_coord.addVertex(v);
			_samplingListZ[0] = v;
			coord.reset();
			for (i = 1; i<samplingAmount; i++) {
				v = new Vertex3D(radius);
				_samplingListZ[i] = v;
				coord.localRotationZ = a;
				coord.addVertex(v);
				v.localX = v.worldX;
				v.localY = v.worldY;
				v.localZ = v.worldZ;
				coord.removeVertex(v);
				_coord.addVertex(v);
			}
			
			_drawLine(_lineX, _lineXBg, _samplingListX, COLOR_X);
			_drawLine(_lineY, _lineYBg, _samplingListY, COLOR_Y);
			_drawLine(_lineZ, _lineZBg, _samplingListZ, COLOR_Z);
			
			_txt.x = radius/3;
			_txt.y = -radius-30;
			_txt.textColor = 0xFFFF00;
			_txt.selectable = false;
			_txt.autoSize = TextFieldAutoSize.LEFT;
			
			this.addChild(_lineXBg);
			this.addChild(_lineYBg);
			this.addChild(_lineZBg);
			this.addChild(_lineX);
			this.addChild(_lineY);
			this.addChild(_lineZ);
			this.addChild(_txt);
		}
		public function get backgroundAlpha():Number {
			return _backgroundAlpha;
		}
		public function set backgroundAlpha(value:Number):void {
			if (value<0) {
				value = 0;
			} else if (value>1) {
				value = 1;
			}
			_backgroundAlpha = value;
		}
		public function get foregroundAlpha():Number {
			return _foregroundAlpha;
		}
		public function set foregroundAlpha(value:Number):void {
			if (value<0) {
				value = 0;
			} else if (value>1) {
				value = 1;
			}
			_foregroundAlpha = value;
		}
		public function set matrix(value:GLMatrix3D):void {
			_coord.localMatrix = value;
			_drawLine(_lineX, _lineXBg, _samplingListX, COLOR_X);
			_drawLine(_lineY, _lineYBg, _samplingListY, COLOR_Y);
			_drawLine(_lineZ, _lineZBg, _samplingListZ, COLOR_Z);
		}
		public function get radius():Number {
			return _radius;
		}
		public function clearHandlers():void {
			axisXmouseMoveHandler = null;
			axisYmouseMoveHandler = null;
			axisZmouseMoveHandler = null;
			axisXmouseUpHandler = null;
			axisYmouseUpHandler = null;
			axisZmouseUpHandler = null;
		}
		public function start():void {
			if (this.stage == null) {
				this.addEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
			} else {
				_start();
			}
		}
		public function stop():void {
			if (_stage == null) return;
			_lineX.removeEventListener(MouseEvent.MOUSE_OVER, _lineXMouseOverHandler);
			_lineX.removeEventListener(MouseEvent.MOUSE_OUT, _lineXMouseOutHandler);
			_lineX.removeEventListener(MouseEvent.MOUSE_DOWN, _lineXMouseDownHandler);
			_lineY.removeEventListener(MouseEvent.MOUSE_OVER, _lineYMouseOverHandler);
			_lineY.removeEventListener(MouseEvent.MOUSE_OUT, _lineYMouseOutHandler);
			_lineY.removeEventListener(MouseEvent.MOUSE_DOWN, _lineYMouseDownHandler);
			_lineZ.removeEventListener(MouseEvent.MOUSE_OVER, _lineZMouseOverHandler);
			_lineZ.removeEventListener(MouseEvent.MOUSE_OUT, _lineZMouseOutHandler);
			_lineZ.removeEventListener(MouseEvent.MOUSE_DOWN, _lineZMouseDownHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, _lineXMouseMoveHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, _lineYMouseMoveHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, _lineZMouseMoveHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, _lineXMouseUpHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, _lineYMouseUpHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, _lineZMouseUpHandler);
		}
		private function _addedToStageHandler(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, _addedToStageHandler);
			_stage = this.stage;
			_start();
		}
		private function _drawLine(line:Sprite, bg:Sprite, samplingList:Vector.<Vertex3D>, color:uint):void {
			var g:Graphics = line.graphics;
			g.clear();
			g.lineStyle(thickness, color, _foregroundAlpha);
			var g2:Graphics = bg.graphics;
			g2.clear();
			g2.lineStyle(thickness, COLOR_BG, _backgroundAlpha);
			var v0:Vertex3D = samplingList[0];
			var v0x:Number = v0.worldX;
			var v0y:Number = v0.worldY;
			var v0z:Number = v0.worldZ;
			g.moveTo(v0x, v0y);
			g2.moveTo(v0x, v0y);
			var state:int = v0z>0 ? 0 : 1;//0:back 1:fore
			var length:int = samplingList.length;
			for (var i:int = 1; i<length; i++) {
				var v:Vertex3D = samplingList[i];
				var x:Number = v.worldX;
				var y:Number = v.worldY;
				if (v.worldZ>0) {
					if (state == 1) state = 0;
					g.moveTo(x, y);
					g2.lineTo(x, y);
				} else {
					if (state == 0) state = 1;
					g.lineTo(x, y);
					g2.moveTo(x, y);
				}
			}
			if (v0z>0) {
				g2.lineTo(v0x, v0y);
			} else {
				g.lineTo(v0x, v0y);
			}
		}
		private function _lineXMouseOverHandler(e:MouseEvent):void {
			_lineX.removeEventListener(MouseEvent.MOUSE_OVER, _lineXMouseOverHandler);
			_lineY.removeEventListener(MouseEvent.MOUSE_OVER, _lineYMouseOverHandler);
			_lineZ.removeEventListener(MouseEvent.MOUSE_OVER, _lineZMouseOverHandler);
			_lineX.addEventListener(MouseEvent.MOUSE_DOWN, _lineXMouseDownHandler);
			_lineX.addEventListener(MouseEvent.MOUSE_OUT, _lineXMouseOutHandler);
			_drawLine(_lineX, _lineXBg, _samplingListX, 0xFFFF00);
		}
		private function _lineXMouseDownHandler(e:MouseEvent):void {
			_lineX.removeEventListener(MouseEvent.MOUSE_DOWN, _lineXMouseDownHandler);
			_lineX.removeEventListener(MouseEvent.MOUSE_OUT, _lineXMouseOutHandler);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, _lineXMouseMoveHandler);
			_stage.addEventListener(MouseEvent.MOUSE_UP, _lineXMouseUpHandler);
			_mouseX = _stage.mouseX;
			_mouseY = _stage.mouseY;
			_angle = 0;
			if (axisXmouseDownHandler != null) axisXmouseDownHandler();
		}
		private function _lineXMouseMoveHandler(e:MouseEvent):void {
			var currentX:Number = _stage.mouseX;
			var currentY:Number = _stage.mouseY;
			var angle:Number = (currentX-_mouseX+currentY-_mouseY)*coordToAngleRatio%360;
			_angle = (_angle+angle)%360;
			_mouseX = currentX;
			_mouseY = currentY;
			_setText(_angle, 0, 0);
			_coord.localRotationX = angle;
			_drawLine(_lineY, _lineYBg, _samplingListY, COLOR_Y);
			_drawLine(_lineZ, _lineZBg, _samplingListZ, COLOR_Z);
			if (axisXmouseMoveHandler != null) axisXmouseMoveHandler(angle);
		}
		private function _lineXMouseUpHandler(e:MouseEvent):void {
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, _lineXMouseMoveHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, _lineXMouseUpHandler);
			_txt.text = '';
			start();
			_drawLine(_lineX, _lineXBg, _samplingListX, COLOR_X);
			if (axisXmouseUpHandler != null) axisXmouseUpHandler(_angle);
		}
		private function _lineXMouseOutHandler(e:MouseEvent):void {
			_lineX.removeEventListener(MouseEvent.MOUSE_DOWN, _lineXMouseDownHandler);
			_lineX.removeEventListener(MouseEvent.MOUSE_OUT, _lineXMouseOutHandler);
			start();
			_drawLine(_lineX, _lineXBg, _samplingListX, COLOR_X);
		}
		
		private function _lineYMouseOverHandler(e:MouseEvent):void {
			_lineX.removeEventListener(MouseEvent.MOUSE_OVER, _lineXMouseOverHandler);
			_lineY.removeEventListener(MouseEvent.MOUSE_OVER, _lineYMouseOverHandler);
			_lineZ.removeEventListener(MouseEvent.MOUSE_OVER, _lineZMouseOverHandler);
			_lineY.addEventListener(MouseEvent.MOUSE_DOWN, _lineYMouseDownHandler);
			_lineY.addEventListener(MouseEvent.MOUSE_OUT, _lineYMouseOutHandler);
			_drawLine(_lineY, _lineYBg, _samplingListY, 0xFFFF00);
		}
		private function _lineYMouseDownHandler(e:MouseEvent):void {
			_lineY.removeEventListener(MouseEvent.MOUSE_DOWN, _lineYMouseDownHandler);
			_lineY.removeEventListener(MouseEvent.MOUSE_OUT, _lineYMouseOutHandler);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, _lineYMouseMoveHandler);
			_stage.addEventListener(MouseEvent.MOUSE_UP, _lineYMouseUpHandler);
			_mouseX = _stage.mouseX;
			_mouseY = _stage.mouseY;
			_angle = 0;
			if (axisYmouseDownHandler != null) axisYmouseDownHandler();
		}
		private function _lineYMouseMoveHandler(e:MouseEvent):void {
			var currentX:Number = _stage.mouseX;
			var currentY:Number = _stage.mouseY;
			var angle:Number = (currentX-_mouseX+currentY-_mouseY)*coordToAngleRatio%360;
			_angle = (_angle+angle)%360;
			_mouseX = currentX;
			_mouseY = currentY;
			_setText(0, _angle, 0);
			_coord.localRotationY = angle;
			_drawLine(_lineX, _lineXBg, _samplingListX, COLOR_X);
			_drawLine(_lineZ, _lineZBg, _samplingListZ, COLOR_Z);
			if (axisYmouseMoveHandler != null) axisYmouseMoveHandler(angle);
		}
		private function _lineYMouseUpHandler(e:MouseEvent):void {
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, _lineYMouseMoveHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, _lineYMouseUpHandler);
			_txt.text = '';
			start();
			_drawLine(_lineY, _lineYBg, _samplingListY, COLOR_Y);
			if (axisYmouseUpHandler != null) axisYmouseUpHandler(_angle);
		}
		private function _lineYMouseOutHandler(e:MouseEvent):void {
			_lineY.removeEventListener(MouseEvent.MOUSE_DOWN, _lineYMouseDownHandler);
			_lineY.removeEventListener(MouseEvent.MOUSE_OUT, _lineYMouseOutHandler);
			start();
			_drawLine(_lineY, _lineYBg, _samplingListY, COLOR_Y);
		}
		
		private function _lineZMouseOverHandler(e:MouseEvent):void {
			_lineX.removeEventListener(MouseEvent.MOUSE_OVER, _lineXMouseOverHandler);
			_lineY.removeEventListener(MouseEvent.MOUSE_OVER, _lineYMouseOverHandler);
			_lineZ.removeEventListener(MouseEvent.MOUSE_OVER, _lineZMouseOverHandler);
			_lineZ.addEventListener(MouseEvent.MOUSE_DOWN, _lineZMouseDownHandler);
			_lineZ.addEventListener(MouseEvent.MOUSE_OUT, _lineZMouseOutHandler);
			_drawLine(_lineZ, _lineZBg, _samplingListZ, 0xFFFF00);
		}
		private function _lineZMouseDownHandler(e:MouseEvent):void {
			_lineZ.removeEventListener(MouseEvent.MOUSE_DOWN, _lineZMouseDownHandler);
			_lineZ.removeEventListener(MouseEvent.MOUSE_OUT, _lineZMouseOutHandler);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, _lineZMouseMoveHandler);
			_stage.addEventListener(MouseEvent.MOUSE_UP, _lineZMouseUpHandler);
			_mouseX = _stage.mouseX;
			_mouseY = _stage.mouseY;
			_angle = 0;
			if (axisZmouseDownHandler != null) axisZmouseDownHandler();
		}
		private function _lineZMouseMoveHandler(e:MouseEvent):void {
			var currentX:Number = _stage.mouseX;
			var currentY:Number = _stage.mouseY;
			var angle:Number = (currentX-_mouseX+currentY-_mouseY)*coordToAngleRatio%360;
			_angle = (_angle+angle)%360;
			_mouseX = currentX;
			_mouseY = currentY;
			_setText(0, 0, _angle);
			_coord.localRotationZ = angle;
			_drawLine(_lineX, _lineXBg, _samplingListX, COLOR_X);
			_drawLine(_lineY, _lineYBg, _samplingListY, COLOR_Y);
			if (axisZmouseMoveHandler != null) axisZmouseMoveHandler(angle);
		}
		private function _lineZMouseUpHandler(e:MouseEvent):void {
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, _lineZMouseMoveHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, _lineZMouseUpHandler);
			_txt.text = '';
			start();
			_drawLine(_lineZ, _lineZBg, _samplingListZ, COLOR_Z);
			if (axisZmouseUpHandler != null) axisZmouseUpHandler(_angle);
		}
		private function _lineZMouseOutHandler(e:MouseEvent):void {
			_lineZ.removeEventListener(MouseEvent.MOUSE_DOWN, _lineZMouseDownHandler);
			_lineZ.removeEventListener(MouseEvent.MOUSE_OUT, _lineZMouseOutHandler);
			start();
			_drawLine(_lineZ, _lineZBg, _samplingListZ, COLOR_Z);
		}
		private function _setText(x:Number, y:Number, z:Number):void {
			_txt.text = '['+x.toFixed(2)+' '+y.toFixed(2)+' '+z.toFixed(2)+']';
		}
		private function _start():void {
			_lineX.addEventListener(MouseEvent.MOUSE_OVER, _lineXMouseOverHandler);
			_lineY.addEventListener(MouseEvent.MOUSE_OVER, _lineYMouseOverHandler);
			_lineZ.addEventListener(MouseEvent.MOUSE_OVER, _lineZMouseOverHandler);
		}
	}
}