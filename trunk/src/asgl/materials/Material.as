package asgl.materials {
	import asgl.events.TextureEvent;
	
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	
	public class Material extends EventDispatcher {
		public var bilinearFilteringEnabled:Boolean = false;
		public var colorSelfLuminationEnabled:Boolean = false;
		public var doubleSidedLightEnabled:Boolean = false;
		/**
		 * 0-1.
		 */
		public var lightingReflectionRadio:Number = 1;
		/**
		 * 0-1.
		 */
		public var selfLuminationStrength:Number;
		public var name:String;
		public var color:uint = 0xFFFFFFFF;
		public var selfLuminationColor:uint = 0xFFFFFFFF;
		
		//hide
		public var _shadingType:int = ShadingType.FLAT;
		public var _bumpBitmapData:BitmapData;
		public var _diffuseBitmapData:BitmapData;
		public var _lightingStrengthBitmapData:BitmapData;
		public var _normalBitmapData:BitmapData;
		public var _specularBitmapData:BitmapData;
		public var _bumpTextureEnabled:Boolean = false;
		public var _diffuseTextureEnabled:Boolean = false;
		public var _lightingStrengthTextureEnabled:Boolean = false;
		public var _normalTextureEnabled:Boolean = false;
		public var _specularTextureEnalbed:Boolean = false;
		public var _bumpTextureHeight:int;
		public var _bumpTextureWidth:int;
		public var _diffuseTextureHeight:int;
		public var _diffuseTextureWidth:int;
		public var _lightingStrengthTextureWidth:int;
		public var _normalTextureHeight:int;
		public var _normalTextureWidth:int;
		public var _specularTextureHeight:int;
		public var _specularTextureWidth:int;
		
		private var _bumpTexture:Texture;
		private var _diffuseTexture:Texture;
		private var _lightingStrengthTexture:Texture;
		private var _normalTexture:Texture;
		private var _specularTexture:Texture;
		public function Material(name:String=null, selfLuminationStrength:Number=0.5):void {
			this.name = name;
			this.selfLuminationStrength = selfLuminationStrength;
		}
		public function get bumpTexture():Texture {
			return _bumpTexture;
		}
		public function set bumpTexture(value:Texture):void {
			if (_bumpTexture == null) {
				if (value != null) _bumpTextureInit(value);
			} else {
				if (value == null) {
					_bumpTextureEnabled = false;
				} else {
					_bumpTexture.removeEventListener(TextureEvent.TEXTURE_RESOURCE_CHANGE, _bumpTextureResourceChangedHandler);
					_bumpTextureInit(value);
				}
			}
		}
		public function get bumpTextureEnabled():Boolean {
			return _bumpTextureEnabled;
		}
		public function set bumpTextureEnabled(value:Boolean):void {
			if (value) {
				if (_bumpTexture != null) {
					_bumpTextureEnabled = true;
					_normalTextureEnabled = false;
					if (_shadingType == ShadingType.PHONG) _shadingType = ShadingType.FLAT;
				}
			} else {
				_bumpTextureEnabled = false;
			}
		}
		public function get diffuseTexture():Texture {
			return _diffuseTexture;
		}
		public function set diffuseTexture(value:Texture):void {
			if (_diffuseTexture == null) {
				if (value != null) _diffuseTextureInit(value);
			} else {
				if (value == null) {
					_diffuseTextureEnabled = false;
				} else {
					_diffuseTexture.removeEventListener(TextureEvent.TEXTURE_RESOURCE_CHANGE, _diffuseTextureResourceChangedHandler);
					_diffuseTextureInit(value);
				}
			}
		}
		public function get diffuseTextureEnabled():Boolean {
			return _diffuseTextureEnabled;
		}
		public function set diffuseTextureEnabled(value:Boolean):void {
			if (value) {
				_diffuseTextureEnabled = _diffuseTexture != null;
			} else {
				_diffuseTextureEnabled = false;
			}
		}
		public function get lightingStrengthTexture():Texture {
			return _lightingStrengthTexture;
		}
		public function set lightingStrengthTexture(value:Texture):void {
			if (_lightingStrengthTexture == null) {
				if (value != null) _lightingStrengthTextureInit(value);
			} else {
				if (value == null) {
					_lightingStrengthTextureEnabled = false;
				} else {
					_lightingStrengthTexture.removeEventListener(TextureEvent.TEXTURE_RESOURCE_CHANGE, _lightingStrengthTextureResourceChangedHandler);
					_lightingStrengthTextureInit(value);
				}
			}
		}
		public function get lightingStrengthTextureEnabled():Boolean {
			return _lightingStrengthTextureEnabled;
		}
		public function set lightingStrengthTextureEnabled(value:Boolean):void {
			if (value) {
				_lightingStrengthTextureEnabled = _lightingStrengthTexture != null;
			} else {
				_lightingStrengthTextureEnabled = false;
			}
		}
		public function get normalTexture():Texture {
			return _normalTexture;
		}
		public function set normalTexture(value:Texture):void {
			if (_normalTexture == null) {
				if (value != null) _normalTextureInit(value);
			} else {
				if (value == null) {
					_normalTextureEnabled = false;
				} else {
					_normalTexture.removeEventListener(TextureEvent.TEXTURE_RESOURCE_CHANGE, _normalTextureResourceChangedHandler);
					_normalTextureInit(value);
				}
			}
		}
		public function get normalTextureEnabled():Boolean {
			return _normalTextureEnabled;
		}
		public function set normalTextureEnabled(value:Boolean):void {
			if (value) {
				if (_normalTexture != null) {
					_normalTextureEnabled = true;
					_bumpTextureEnabled = false;
					if (_shadingType == ShadingType.PHONG) _shadingType = ShadingType.FLAT;
				}
			} else {
				_normalTextureEnabled = false;
			}
		}
		public function get shadingType():int {
			return _shadingType;
		}
		public function set shadingType(value:int):void {
			_shadingType = value;
			if (_shadingType == ShadingType.PHONG) {
				_normalTextureEnabled = false;
				_bumpTextureEnabled = false;
			}
		}
		public function get specularTexture():Texture {
			return _specularTexture;
		}
		public function set specularTexture(value:Texture):void {
			if (_specularTexture == null) {
				if (value != null) _specularTextureInit(value);
			} else {
				if (value == null) {
					_specularTextureEnalbed = false;
				} else {
					_specularTexture.removeEventListener(TextureEvent.TEXTURE_RESOURCE_CHANGE, _specularTextureResourceChangedHandler);
					_specularTextureInit(value);
				}
			}
		}
		public function get specularTextureEnabled():Boolean {
			return _specularTextureEnalbed;
		}
		public function set specularTextureEnabled(value:Boolean):void {
			if (value) {
				_specularTextureEnalbed = _specularTexture != null;
			} else {
				_specularTextureEnalbed = false;
			}
		}
		public function copyTextures(material:Material):void {
			this.bumpTexture = material.bumpTexture;
			this.diffuseTexture = material.diffuseTexture;
			this.lightingStrengthTexture = material.lightingStrengthTexture;
			this.normalTexture = material.normalTexture;
		}
		public function copyTexturesState(material:Material):void {
			this.bumpTextureEnabled = material.bumpTextureEnabled;
			this.diffuseTextureEnabled = material.diffuseTextureEnabled;
			this.lightingStrengthTextureEnabled = material.lightingStrengthTextureEnabled;
			this.normalTextureEnabled = material.normalTextureEnabled;
		}
		public function destroy():void {
			if (_bumpTexture != null) {
				_bumpTexture.removeEventListener(TextureEvent.TEXTURE_RESOURCE_CHANGE, _bumpTextureResourceChangedHandler);
				_bumpTexture = null;
			}
			if (_diffuseTexture != null) {
				_diffuseTexture.removeEventListener(TextureEvent.TEXTURE_RESOURCE_CHANGE, _diffuseTextureResourceChangedHandler);
				_diffuseTexture = null;
			}
			if (_lightingStrengthTexture != null) {
				_lightingStrengthTexture.removeEventListener(TextureEvent.TEXTURE_RESOURCE_CHANGE, _lightingStrengthTextureResourceChangedHandler);
				_lightingStrengthTexture = null;
			}
			if (_normalTexture != null) {
				_normalTexture.removeEventListener(TextureEvent.TEXTURE_RESOURCE_CHANGE, _normalTextureResourceChangedHandler);
				_normalTexture = null;
			}
			if (_specularTexture != null) {
				_specularTexture.removeEventListener(TextureEvent.TEXTURE_RESOURCE_CHANGE, _specularTextureResourceChangedHandler);
				_specularTexture = null;
			}
			try {
				_bumpBitmapData.dispose();
			} catch (e:Error) {}
			try {
				_diffuseBitmapData.dispose();
			} catch (e:Error) {}
			try {
				_lightingStrengthBitmapData.dispose();
			} catch (e:Error) {}
			try {
				_normalBitmapData.dispose();
			} catch (e:Error) {}
			try {
				_specularBitmapData.dispose();
			} catch (e:Error) {}
			_bumpBitmapData = null;
			_diffuseBitmapData = null;
			_lightingStrengthBitmapData = null;
			_normalBitmapData = null;
			_specularBitmapData = null;
		}
		private function _bumpTextureInit(texture:Texture):void {
			_bumpTexture = texture;
			_bumpBitmapData = _bumpTexture.bitmapData;
			_bumpTextureWidth = _bumpBitmapData.width-1;
			_bumpTextureHeight = _bumpBitmapData.height-1;
			_bumpTexture.addEventListener(TextureEvent.TEXTURE_RESOURCE_CHANGE, _bumpTextureResourceChangedHandler, false, 0, true);
		}
		private function _bumpTextureResourceChangedHandler(e:TextureEvent):void {
			_bumpBitmapData = _bumpTexture.bitmapData;
			_bumpTextureWidth = _bumpBitmapData.width-1;
			_bumpTextureHeight = _bumpBitmapData.height-1;
		}
		private function _diffuseTextureInit(texture:Texture):void {
			_diffuseTexture = texture;
			_diffuseBitmapData = _diffuseTexture.bitmapData;
			_diffuseTextureWidth = _diffuseBitmapData.width-1;
			_diffuseTextureHeight = _diffuseBitmapData.height-1;
			_diffuseTexture.addEventListener(TextureEvent.TEXTURE_RESOURCE_CHANGE, _diffuseTextureResourceChangedHandler, false, 0, true);
		}
		private function _diffuseTextureResourceChangedHandler(e:TextureEvent):void {
			_diffuseBitmapData = _diffuseTexture.bitmapData;
			_diffuseTextureWidth = _diffuseBitmapData.width-1;
			_diffuseTextureHeight = _diffuseBitmapData.height-1;
		}
		private function _lightingStrengthTextureInit(texture:Texture):void {
			_lightingStrengthTexture = texture;
			_lightingStrengthBitmapData = _lightingStrengthTexture.bitmapData;
			_lightingStrengthTextureWidth = _lightingStrengthBitmapData.width-1;
			_lightingStrengthTexture.addEventListener(TextureEvent.TEXTURE_RESOURCE_CHANGE, _lightingStrengthTextureResourceChangedHandler, false, 0, true);
		}
		private function _lightingStrengthTextureResourceChangedHandler(e:TextureEvent):void {
			_lightingStrengthBitmapData = _normalTexture.bitmapData;
			_lightingStrengthTextureWidth = _lightingStrengthBitmapData.width-1;
		}
		private function _normalTextureInit(texture:Texture):void {
			_normalTexture = texture;
			_normalBitmapData = _normalTexture.bitmapData;
			_normalTextureWidth = _normalBitmapData.width-1;
			_normalTextureHeight = _normalBitmapData.height-1;
			_normalTexture.addEventListener(TextureEvent.TEXTURE_RESOURCE_CHANGE, _normalTextureResourceChangedHandler, false, 0, true);
		}
		private function _normalTextureResourceChangedHandler(e:TextureEvent):void {
			_normalBitmapData = _normalTexture.bitmapData;
			_normalTextureWidth = _normalBitmapData.width-1;
			_normalTextureHeight = _normalBitmapData.height-1;
		}
		private function _specularTextureInit(texture:Texture):void {
			_specularTexture = texture;
			_specularBitmapData = _specularTexture.bitmapData;
			_specularTextureWidth = _specularBitmapData.width-1;
			_specularTextureHeight = _specularBitmapData.height-1;
			_specularTexture.addEventListener(TextureEvent.TEXTURE_RESOURCE_CHANGE, _specularTextureResourceChangedHandler, false, 0, true);
		}
		private function _specularTextureResourceChangedHandler(e:TextureEvent):void {
			_specularBitmapData = _specularTexture.bitmapData;
			_specularTextureWidth = _specularBitmapData.width-1;
			_specularTextureHeight = _specularBitmapData.height-1;
		}
	}
}