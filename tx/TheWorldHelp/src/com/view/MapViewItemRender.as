package com.view
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	import rfcomponents.SkinBase;
	
	public class MapViewItemRender extends SkinBase
	{
		private var bitmapdata:BitmapData;
		public function MapViewItemRender()
		{
			super();
			create(100,100,Math.random()*0xFFFFFF,false);
			bitmapdata = new BitmapData(100,100);
		}
		public var dx:int;
		public var dy:int;
		public function render(mapres:Array,b:ByteArray,x:int,y:int,ez:int):void{
			this.dx = x;
			this.dy = y;
			updata();
			if(!b){
				clear();
				return;
			}
			var len:int = 100/ez;
			var i:int;
			var j:int;
			if(ez == 1){
				render2(mapres,b);
			}
		}
		private var t:TextField;
		public function updata():void{
			if(!t){
				t = new TextField();
				t.mouseEnabled = false;
				t.width = 50;
				t.height = 20;
				addChild(t);
			}
			
			t.text = dx+"-"+dy
		}
		
		public function render2(mapres:Array,b:ByteArray):void{
			var g:Graphics = _skin.graphics;
			g.clear();
			var i:int,j:int;
			for (j=0;j<100;j++){
				for(i=0;i<100;i++){
					var index:int = b[j*100+i]
					var c:int = mapres[index]
					bitmapdata.setPixel(i,j,c);
				}
			}
			
			g.beginBitmapFill(bitmapdata);
			g.drawRect(0,0,100,100);
			g.endFill();
		}
		
		override public function dispose():void{
			//_skin.graphics.clear();
		//	bitmapdata.dispose();
			dx = -1;
			dy = -1;
		}
		
		override public function clear():void{
		//	bitmapdata.dispose();
		}
	}
}