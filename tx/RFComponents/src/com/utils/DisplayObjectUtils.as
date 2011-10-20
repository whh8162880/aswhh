package com.utils
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;

	public class DisplayObjectUtils
	{
		public function DisplayObjectUtils()
		{
		}
		
		public static function getEmbedSkin(Cls:Class):Sprite{
			var s:Sprite = new Sprite();
			var g:Graphics = s.graphics;
			var b:BitmapData = (new Cls() as Object).bitmapData;
			g.beginBitmapFill(b);
			g.drawRect(0,0,b.width,b.height);
			g.endFill();
			return s;
		}
	}
}