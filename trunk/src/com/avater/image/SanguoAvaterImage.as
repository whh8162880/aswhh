package com.avater.image
{
	import asgl.files.images.PNGReader;
	
	import com.avater.AvaterActionVO;
	import com.utils.BitMapCreater;
	
	import flash.display.BitmapData;
	import flash.utils.ByteArray;

	public class SanguoAvaterImage extends AvaterImage
	{
		private var _bitmapData:BitmapData
		public function SanguoAvaterImage()
		{
			super();
		}
		
		override protected function doComplete(data:Object, arg:Object):void{
			if(_bitmapData){
				_bitmapData.dispose();
			}
			var decode:PNGReader = new PNGReader(arg as ByteArray)
			_bitmapData = decode.bitmapData;
			decode = null;
			_images = decodeBitmapData();
		}
		
		private var directions:Array = [1,3,7,5]
		private var actions:Array = [1,2,3,0]
		private var actions2:Array = [1,0]
		private function decodeBitmapData():Array{
			var returnarr:Array = [];
			var b:BitMapCreater = new BitMapCreater()
			b.reg2(_bitmapData,0,0);
			var arr:Array = b.getBitmapDatas(4,4);
			var defaultArr:Array = []
			for (var i:int = 0;i<4;i++){
				var direction:int = directions[i]
				var bs:Array = arr[i]
				for(var j:int=0;j<4;j++){	
					var sb:String = _m + direction + j
					var sn:String = _m + direction +  actions[j]
					returnarr.push(new AvaterActionVO(sb,direction,j,bs[j],sn));
					if(j<2){
						sn = _m + direction +  actions2[j]
						defaultArr.push(new AvaterActionVO(sb,direction,j,bs[j],sn));
					}
				}
			}
			
			defaultActions = [5,defaultArr]
			runActions = [1,returnarr];
			walkActions = [2,returnarr];
			
			return returnarr;
		}
		
	}
}