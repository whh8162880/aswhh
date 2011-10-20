package rfcomponents.image
{
	import com.net.request.StreamAsyncRequest;
	import com.utils.BitmapdataUtils;
	import com.utils.FilterUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.ProgressEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	import rfcomponents.progressbar.ProgressBar;
	import rfcomponents.text.Text;
	
	public class Image extends Sprite
	{
		protected var _w:int;
		protected var _h:int;
		protected var t:TextField;
		public function Image(w:int,h:int,alpha:Number = 0)
		{
			this._w = w;
			this._h = h;
			t = Text.createText(0xFFFFFF,FilterUtils.textBlackFilter);
//			graphics.lineStyle(1);
			graphics.beginFill(0xFFFFFF,alpha);
			graphics.drawRect(0,0,_w,_h);
			graphics.endFill();
		}
		
		
		public function loadImage(url:String):void{
			new StreamAsyncRequest(url,url,null,false,true).invoke(loadImageSuccess,loadImageProgress);
			t.htmlText = '准备加载';
			layoutTextField();
		}
		protected function loadImageSuccess(id:String,byte:ByteArray,loader:Loader = null):void{
			if(loader){
				setBitmapdata((loader.content as Bitmap).bitmapData);
				if(t.parent){
					t.parent.removeChild(t);
				}
			}else{
				t.text = '加载失败'
			}
		}
		protected function loadImageProgress(id:String,event:ProgressEvent):void{
			t.htmlText = int(event.bytesLoaded / event.bytesTotal * 100) + "%" ;
			layoutTextField();
		}
		protected function layoutTextField():void{
			t.width = t.textWidth + 5;
			t.height = t.textHeight+2;
			t.x = (_w - t.width)/2;
			t.y = (_h - t.height)/2;
			addChild(t);
		}
		
		public function setImage(d:DisplayObject):void{
			var scale:Number;
			var dw:Number = _w/d.width;
			var dh:Number = _h/d.height;
			scale = (dw < dh ? dw : dh);
			
			d.scaleX = d.scaleY = scale;
			var dx:Number = (_w - d.width)/2;
			var dy:Number = (_h - d.height)/2;
			d.x = dx;
			d.y = dy;
			addChild(d);
		}
		
		public function setBitmapdata(bmd:BitmapData):void{
			var scale:Number;
			var dx:Number;
			var dy:Number;
			var dw:Number = _w/bmd.width;
			var dh:Number = _h/bmd.height;
			scale = (dw < dh ? dw : dh);
			
			
//			bmd = BitmapdataUtils.resizeBitmapByScale(bmd,scale);
//			dx = (_w - bmd.width)/2;
//			dy = (_h - bmd.height)/2;
			
			dw = bmd.width*scale;
			dh = bmd.height*scale;
			dx = (_w - dw)/2;
			dy = (_h - dh)/2;
			
			graphics.beginBitmapFill(bmd,new Matrix(scale,0,0,scale,dx,dy),true,true);
			graphics.drawRect(dx,dy,dw,dh);
			
		}
		
		
		
	}
}