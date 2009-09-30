package com.display.image.parser
{
	import asgl.files.images.GIFReader;
	
	import com.display.image.ImageBase;
	import com.display.image.gif.GIFEncoder;
	import com.file.OpenFile;
	
	import flash.utils.ByteArray;
	
	public class GifImage extends ImageBase
	{
		public function GifImage()
		{
		}
		
		override protected function doComplete(data:Object,arg:Object):void{
			var g:GIFReader = new GIFReader()
			g.read(arg as ByteArray)
			var arr:Array = g.getFramesList().concat();
			_images = arr;
			
			
//			var e:GIFEncoder = new GIFEncoder()
//			e.start();
//			var i:int = 0
//			for each(var temp:Array in arr){
//				e.setRepeat(i++)
//				e.setDelay(temp[1])
//				e.addFrame(temp[0])
//			}
//			
//			e.finish();
//			
//			var file:OpenFile = new OpenFile()
//			file.write(e.stream,"D:\\workspace\\Sanguo\\src\\assets\\sanguo\\1.gif");
			
			
			return;
//			var i:int = 0
//			for each(var temp:Array in arr){
//				var o:Object = {}
//				o.bitmapdata = temp[0]
//				o.delay = temp[1]
//				_images[i++] = o;
//			}
		}
		
		public function encode():void{
			
			
		}

	}
}