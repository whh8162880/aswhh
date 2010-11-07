package make.module.photoscale.view
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	public class PhotoView extends Sprite
	{
		public function PhotoView()
		{
			super();
		}
		
		public function setphoto(view:BitmapData,width:int,height:int):void{
			var _w:Number = view.width;
			var _h:Number = view.height;
			
			var scale:Number = Math.min(width/_w,height/_h);
			
			_w *= scale;
			_h *= scale;
			var ma:Matrix = new Matrix();
			ma.scale(scale,scale);
			var shape:Shape = new Shape();
			shape.graphics.beginBitmapFill(view,ma,true);
			shape.graphics.drawRect(0,0,_w,_h);
			shape.graphics.endFill();
			addChild(shape);
			shape.x = (width-_w)/2;
			shape.y = (height-_h)/2;
			graphics.lineStyle(1);
			graphics.drawRect(0,0,width,height);
		}
	}
}