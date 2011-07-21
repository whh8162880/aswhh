package rfcomponents.zother
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import rfcomponents.Size;

	public class _9Skin extends Size
	{
		public function _9Skin()
		{
			
		}
		
		private var draw:Graphics;
		
		private var tl:BitmapData;
		private var t:BitmapData;
		private var tr:BitmapData;
		private var r:BitmapData;
		private var rb:BitmapData;
		private var b:BitmapData;
		private var lb:BitmapData;
		private var l:BitmapData;
		private var c:BitmapData;
		public function init(draw:Graphics,d:BitmapData,top:int,left:int,right:int,bottom:int):void{
			this.draw = draw;
			var w:int = d.width;
			var h:int = d.height;
			var point:Point = new Point(0,0);
			var rect:Rectangle = new Rectangle();
			
			tl = new BitmapData(left,top,true,0xFFFFFF);
			rect.width = tl.width;
			rect.height = tl.height;
			tl.copyPixels(d,rect,point);
			
			t = new BitmapData(w-right - left,top,true,0xFFFFFF);
			rect.width = tl.width;
			rect.height = tl.height;
			rect.x = left;
			t.copyPixels(d,rect,point);
			
			tr = new BitmapData
			
		}
		
		override protected function doSizeRender():void{
			
		}
	}
}