package rfcomponents.image
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import rfcomponents.zother.DragHelp;
	
	public class ScrollImage extends Sprite
	{
		private var drag:DragHelp
		public function ScrollImage()
		{
			super();
			shape = new Sprite();
			drag = new DragHelp(shape);
			addChild(shape);
		}
		
		protected var shape:Sprite;
		protected var w:int;
		protected var h:int;
		protected var bx:int;
		protected var by:int;
		protected var bw:int;
		protected var bh:int;
		protected var bitmapdata:BitmapData
		public function setBitmapdata(bitmap:BitmapData,width:int,height:int):void{
			this.w = bitmap.width;
			this.h = bitmap.height;
			bw = width;
			bh = height;
			bx = width > w ? (width - w)/2 : 0; 
			by = height > h ? (height - h)/2 : 0; 
			shape.graphics.beginBitmapFill(bitmap);
			shape.graphics.drawRect(0,0,w,h);
			shape.graphics.endFill();
			shape.x = bx;
			shape.y = by;
			bitmapdata = bitmap
			this.scrollRect = new Rectangle(0,0,width,height);
			drag.setDragRect(new Rectangle(-w+width,-h+height,w,h));
			drag.xlock = shape.x != 0;
			drag.ylock = shape.y != 0;
			drag.bindDragTarget(this);
			
			graphics.beginFill(0);
			graphics.drawRect(bx,by,10,10);
			graphics.endFill();
			
		}
	}
}