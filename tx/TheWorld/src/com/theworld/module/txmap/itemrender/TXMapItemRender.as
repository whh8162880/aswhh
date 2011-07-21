package com.theworld.module.txmap.itemrender
{
	import com.map.IMapRender;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	import rfcomponents.SkinBase;
	
	public class TXMapItemRender extends SkinBase implements IMapRender
	{
		public function TXMapItemRender()
		{
			super();
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
			
			t.text = dx+"-"+dy +"\n" + offsetx+","+offsety
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
	}
}