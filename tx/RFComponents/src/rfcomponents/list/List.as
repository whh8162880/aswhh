package rfcomponents.list
{
	import com.utils.Work;
	
	import flash.display.Graphics;
	import flash.geom.Rectangle;
	
	import rfcomponents.SkinBase;
	
	public class List extends SkinBase
	{
		private static var count:int;
		
		protected var cls:Class;
		protected var itemWidth:uint;
		protected var itemHeight:uint;
		protected var train:Boolean;
		protected var columnCount:uint = 1;
		
		protected var index:int;
		
		protected var bufferList:Array;
		protected var displayItemList:Array;
		public function List(cls:Class,itemWidth:uint,itemHeight:uint,train:Boolean = true,columnCount:uint = 1)
		{
			super();
			_name = "List"+count;
			this.cls = cls;
			this.itemWidth = itemWidth;
			this.itemHeight = itemHeight;
			this.train = train;
			this.columnCount = columnCount;
			bufferList = [];
			displayItemList = [];
			create(10,10);
		}
		
		override protected function doData():void{
			clear();
			var arr:Array = _data as Array;
			var len:int = arr.length;
			len = Math.ceil(len/columnCount);
			Work.addTask(_name,arr,doListItemRender);
			_width = train ? itemWidth*columnCount : itemWidth * len;
			_height = train ? itemHeight*len : itemHeight*columnCount;
			renderSize();
		}
		
		protected function doListItemRender(o:Object):void{
			var item:SkinBase;
			if(bufferList.length){
				item = bufferList.pop();
			}else{
				item = new cls();
			}
			item.data = o;
			arrange(item,index++);
			addChild(item.skin);
		}
		
		protected function arrange(item:SkinBase,i:uint):void{
			if(train){
				item.moveTo((i%columnCount) * itemWidth,(i/columnCount) * itemHeight);
			}else{
				item.moveTo((i/columnCount) * itemWidth,(i%columnCount) * itemHeight);
			}
		}
		
		override protected function doSizeRender():void{
			var g:Graphics = _skin.graphics;
			g.clear();
			g.beginFill(0xFFFFFF,1);
			g.drawRect(0,0,_width,_height);
			g.endFill();
			_skin.scrollRect = new Rectangle(0,0,_width+1,_height+1);
		}
		
		override public function clear():void{
			var item:SkinBase;
			while(displayItemList.length){
				item = displayItemList.pop();
				item.dispose();
				item.remove();
				bufferList.push(item);
			}
			index = 0;
		}
	}
}