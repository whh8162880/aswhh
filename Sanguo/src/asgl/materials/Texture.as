package asgl.materials {
	import __AS3__.vec.Vector;
	
	import asgl.events.TextureEvent;
	import asgl.math.Color;
	
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Vector3D;
	
	[Event(name="textureResourceChanged", type="asgl.events.MaterialEvent")]
	
	public class Texture extends EventDispatcher {
		public static var defaultColor:uint = 0xFFFFFFFF;
		private static var _mipMatrix:Matrix = new Matrix(0.5, 0, 0, 0.5);
		public var url:String;
		protected var _bitmapData:BitmapData;
		private var _mipTextureEnabled:Boolean = false;
		private var _mipTextureLevel:int;
		protected var _height:uint;
		protected var _width:uint;
		private var _mipTextureList:Vector.<BitmapData>;
		public function Texture(source:BitmapData=null):void {
			if (source == null) source = new BitmapData(1, 1, true, defaultColor);
			_bitmapData = source;
			_height = _bitmapData.height;
			_width = _bitmapData.width;
		}
		public function get bitmapData():BitmapData {
			return _bitmapData;
		}
		public function set bitmapData(value:BitmapData):void {
			if (value) {
				_bitmapData = value;
				_height = _bitmapData.height;
				_width = _bitmapData.width;
				if (_mipTextureEnabled) _setMipTexture();
				this.dispatchEvent(new TextureEvent(TextureEvent.TEXTURE_RESOURCE_CHANGE));
			}
		}
		public function get height():uint {
			return _height;
		}
		public function get mipTextureEnabled():Boolean {
			return _mipTextureEnabled;
		}
		public function set mipTextureEnabled(value:Boolean):void {
			if (value) {
				if (!_mipTextureEnabled) {
					_mipTextureEnabled = true;
					_setMipTexture();
				}
			} else {
				_mipTextureEnabled = false;
				_mipTextureList = null;
			}
		}
		public function get widht():uint {
			return _width;
		}
		public function destroy():void {
			if (_mipTextureList != null) {
				for (var i:int = _mipTextureList.length-1; i>=0; i--) {
					try {
						_mipTextureList[i].dispose();
					} catch (e:Error) {}
				}
				_mipTextureList = null;
			}
			_bitmapData = null;
		}
		public function getMipBitmapData(level:int):BitmapData {
			if (!_mipTextureEnabled) this.mipTextureEnabled = true;
			if (level<1) {
				level = 1;
			} else if (level>_mipTextureLevel) {
				level = _mipTextureLevel;
			}
			return _mipTextureList[level-1];
		}
		public function getBilinearFilteringPixel32(x:Number, y:Number):uint {
			var bx:int = int(x);
			var by:int = int(y);
			var kx:Number = x-bx;
			var ky:Number = y-by;
			return Color.pixelBlend(Color.pixelBlend(_bitmapData.getPixel32(bx, by), _bitmapData.getPixel32(++bx, by++), kx), Color.pixelBlend(_bitmapData.getPixel32(--bx, by), _bitmapData.getPixel32(++bx, by), kx), ky);
		}
		/**
		 * return a texture space of vector.
		 */
		public function getNormalTextureVector(x:int, y:int):Vector3D {
			if (x<0) {
				x = 0;
			} else if (x>=_width) {
				x = _width-1;
			}
			if (y<0) {
				y = 0;
			} else if (y>=_height) {
				y = _height-1;
			}
			var color:uint = _bitmapData.getPixel(x, y);
			var nx:int = color>>16&0xFF;
			var ny:int = color>>8&0xFF;
			var nz:int = color&0xFF;
			var v:Vector3D = new Vector3D();
			if (nx>127) {
				v.x = (nx-127)/128;
			} else if (nx<127) {
				v.x = (nx-127)/127;
			}
			if (ny>127) {
				v.y = (ny-127)/128;
			} else if (ny<127) {
				v.y = (ny-127)/127;
			}
			if (nz>127) {
				v.z = (nz-127)/128;
			} else if (nz<127) {
				v.z = (nz-127)/127;
			}
			return v;
		}
		public function getPixel32(x:int, y:int):uint {
			if (x<0) {
				x = 0;
			} else if (x>=_width) {
				x = _width-1;
			}
			if (y<0) {
				y = 0;
			} else if (y>=_height) {
				y = _height-1;
			}
			return _bitmapData.getPixel32(x, y);
		}
		private function _setMipTexture():void {
			_mipTextureList = new Vector.<BitmapData>();
			_mipTextureList[0] = _bitmapData;
			var h:int = _height;
			var w:int = _width;
			if (h == 1 || w ==1) {
				_mipTextureLevel = 1;
				return;
			}
			var sourceBitmapData:BitmapData = _bitmapData;
			while (true) {
				h *= 0.5;
				w *= 0.5;
				var mipBitmapData:BitmapData = new BitmapData(w, h, true, 0x00);
				mipBitmapData.draw(sourceBitmapData, _mipMatrix);
				_mipTextureList.push(mipBitmapData);
				if (h == 1 || w == 1) break;
				sourceBitmapData = mipBitmapData;
			}
			_mipTextureLevel = _mipTextureList.length;
		}
	}
}