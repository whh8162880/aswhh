package make.utils
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	import mx.graphics.ImageSnapshot;

	public class BitmapdataUtils
	{
		public function BitmapdataUtils()
		{
		}
		
		public static function resizeBitmap(bmd:BitmapData,width:int,height:int,scaleMode:Boolean = true):BitmapData{
			var matrix:Matrix = new Matrix();
			var wScale:Number = width/bmd.width;
			var hScale:Number 
			if(scaleMode){
				hScale = wScale;
			}else{
				hScale = height/bmd.height;
			}
			matrix.scale(wScale,hScale);
			return ImageSnapshot.captureBitmapData(bmd,matrix,null,null,null,true);
		}
		
		public static function resizeBitmapByScale(bmd:BitmapData,scale:Number):BitmapData{
			var matrix:Matrix = new Matrix();
			var wScale:Number = bmd.width*scale;
			var hScale:Number = bmd.height*scale;
			matrix.scale(wScale,hScale);
			return ImageSnapshot.captureBitmapData(bmd,matrix,null,null,null,true);
		}
	}
}