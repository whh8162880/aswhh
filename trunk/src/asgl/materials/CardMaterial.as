package asgl.materials {
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Shape;
	import flash.geom.Matrix;
	
	public class CardMaterial extends Material {
		//hide
		public var _lightBitmapData:BitmapData;
		public function CardMaterial(name:String=null, selfLuminationStrength:Number=0.5, lightMapWidth:uint=128, lightMapHeight:uint=128, lightColor:uint=0xFFFFFF, ambientColor:uint=0):void {
			super(name, selfLuminationStrength);
			createLightMap(lightMapWidth, lightMapHeight, lightColor, ambientColor);
		}
		public function get lightMap():BitmapData {
			return _lightBitmapData;
		}
		public function createLightMap(width:uint=128, height:uint=128, lightColor:uint=0xFFFFFF, ambientColor:uint=0):void {
			if (width<1) width = 1;
			if (height<1) height = 1;
			try {
				_lightBitmapData.dispose();
			} catch (e:Error) {}
			_lightBitmapData = new BitmapData(width, height, true, 0x0);
			var shape:Shape = new Shape();
			var mat:Matrix = new Matrix();
			mat.createGradientBox(width, height);
			shape.graphics.beginGradientFill(GradientType.LINEAR, [ambientColor, lightColor], [1, 1], [0, 255], mat);
			shape.graphics.drawRect(0, 0, width, height);
			_lightBitmapData.draw(shape);
		}
		public override function destroy():void {
			try {
				_lightBitmapData.dispose();
			} catch (e:Error) {}
			super.destroy();
		}
	}
}