package com.theworld.module.txmap.itemrender
{
	import com.map.IMapRender;
	import com.map.MapModel;
	import com.theworld.module.txmap.TXMapController;
	import com.theworld.utils.TXHelp;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	import rfcomponents.SkinBase;
	
	public class TXMapItemRender extends SkinBase implements IMapRender
	{
		private var controller:TXMapController;
		private var model:MapModel;
		public function TXMapItemRender()
		{
			super();
			controller = TXHelp.mapController;
			model = TXHelp.mapModel;
		}
		
		private var bitmapdata:BitmapData;
		public var offsetx:int;
		public var offsety:int;
		
		public var dx:int;
		public var dy:int;
		
		private var t:TextField;
		public function updata():void{
			if(!t){
				t = new TextField();
				t.mouseEnabled = false;
				t.width = 100;
				t.height =40;
				addChild(t);
			}
			
			t.text = dx+"-"+dy +"\n" + offsetx+","+offsety;
			//renderHelp.addRender("render_map",rendermap);
		}
		
		public function get graphics():Graphics{
			return _skin.graphics;
		}
		
		public function getoffsetx():int{
			return offsetx;
		}
		
		public function getoffsety():int{
			return offsety;
		}
		
		override public function clear():void{
			
		}
		
		public function rendermap(eachw:int,eachh:int):void{
			var g:Graphics = _skin.graphics;
			g.clear();
			var x:int = offsetx;
			var y:int = offsety;
			var w:int = _width;
			var h:int = _height;
			w = (x+w)/eachw;
			h = (y+h)/eachh;
			x /= eachw;
			y /= eachh;
			var i:int,j:int
			for(i=x;i<w;i++){
				for(j=y;j<h;j++){
					var c:uint = model.getXYItemRenderColor(i,j);
					g.beginFill(c);
					trace((i-x)*eachw,(j-y)*eachh);
					g.drawRect((i-x)*eachw,(j-y)*eachh,eachw,eachh);
					g.endFill();
				}
			}
			
			
			
		}
	}
}