package com.utils
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * 有规律的bitmap生成器
	 * @author whh
	 *  displayObject --> bitMapData 
	 *  bitMapData(i,j) --> bitMap
	 */	
	public class BitMapCreater extends EventDispatcher
	{
		
		protected var cutWidth:int;
		protected var cutheight:int;
		protected var bitMapData:BitmapData;
		public function BitMapCreater()
		{
		}
		
		/**
		 * 生成bitmapdata
		 * @param item DisplayObject
		 * @param width 横切宽度 
		 * @param height 竖切宽度
		 * 
		 */		
		public function reg(item:DisplayObject,width:int,height:int):void{
			cutWidth = width
			cutheight = height;
			var _width:int = (int(item.width / width)+1)*width
			var _height:int = (int(item.height / height)+1)*height
			bitMapData = new BitmapData(_width,_height,true,0);
			bitMapData.draw(item);
		}
		
		public function reg2(bitmapdata:BitmapData,width:int,height:int):void{
			cutWidth = width;
			cutheight = height;
			this.bitMapData = bitmapdata;
		}
		
		/**
		 * 获取bitMap 
		 * @param i 
		 * @param j
		 * @return 
		 * 
		 */		
		public function getBitMap(i:int,j:int):Bitmap{
			var rect:Rectangle = new Rectangle(i*cutWidth,j*cutheight,cutWidth,cutheight);
			var bmp:BitmapData = new BitmapData(cutWidth,cutheight,true,0);
			bmp.copyPixels(bitMapData,rect,new Point(0,0));
			return new Bitmap(bmp);
		}
		
		public function getBitmapData(i:int,j:int):BitmapData{
			var rect:Rectangle = new Rectangle(i*cutWidth,j*cutheight,cutWidth,cutheight);
			var bmp:BitmapData = new BitmapData(cutWidth,cutheight,true,0);
			bmp.copyPixels(bitMapData,rect,new Point(0,0));
			return bmp;
		}
		
		public function getBitmapDatas(widthCount:int,heightCount:int):Array{
			var rect:Rectangle = new Rectangle();
			var p:Point = new Point(0,0)
			var icut:int = bitMapData.width/widthCount;
			var jcut:int = bitMapData.height/heightCount;
			var arr:Array = [];
			for(var i:int=0;i<heightCount;i++){
				var temp:Array = []
				for(var j:int = 0;j<widthCount;j++){
					rect.x = j*icut;
					rect.y = i*jcut;
					rect.width = icut;
					rect.height = jcut;
					var bmp:BitmapData = new BitmapData(icut,jcut,true,0);
					bmp.copyPixels(bitMapData,rect,p);
					temp.push(bmp);
				}
				arr.push(temp);
			} 
			
			return arr;
		}

	}
}