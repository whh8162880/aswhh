package com.edit
{
	import com.avater.AvaterTitle;
	import com.avater.NickNameTitleItem;
	import com.display.Box;
	import com.display.LayoutType;
	import com.display.event.LayoutEvent;
	import com.display.image.gif.GIFDecoder;
	import com.display.text.Text;
	import com.youbt.events.RFLoaderEvent;
	import com.youbt.net.RFStreamLoader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.ByteArray;
	
	import mx.controls.HSlider;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.events.SliderEvent;

	public class EditColorImage extends UIComponent
	{
		private var _decoder:GIFDecoder;
		private var _bitmap:Bitmap;
		private var _bitmapData:BitmapData;
		private var _txt:TextField;
		private var hslider:HSlider;
		private var _realBitmap:Bitmap;
		private var box:Box
		public function EditColorImage()
		{
			_bitmap = new Bitmap();
			_realBitmap = new Bitmap();
			_decoder = new GIFDecoder();
			_txt = new Text()
			_txt.selectable = true;
			hslider = new HSlider()
			hslider.width = 100;
			hslider.maximum = 239;
			hslider.snapInterval = 1;
			hslider.addEventListener(FlexEvent.CREATION_COMPLETE,createCompleteHandler);
			
			
			var title:AvaterTitle = new AvaterTitle()
			title.addEventListener(LayoutEvent.BUILD,function ():void{
				layout();
			});
			
			var item:NickNameTitleItem
			item = new NickNameTitleItem();
			item.data = {level:10,nickname:"汪鸿海"}
			title.regTitle(item);
			
			item = new NickNameTitleItem();
			item.data = {level:12,nickname:"汪鸿海"}
			title.regTitle(item);
			
			box = new Box(LayoutType.HORIZONTAL,false)
			
			hslider.addEventListener(SliderEvent.THUMB_DRAG,sliderHandler);
			hslider.addEventListener(Event.CHANGE,sliderHandler);
			this.addEventListener(MouseEvent.ROLL_OVER,rollhandelr);
			this.addEventListener(MouseEvent.ROLL_OUT,rollhandelr);
			
			box.addChild(title);
			box.addChild(_bitmap)
			box.addChild(_realBitmap);
			box.addChild(_txt)
//			box.addChild(hslider)
			box.hAlign = LayoutType.CENTER;
			box.vAlign = LayoutType.MIDDLE;
			
			addChild(box);
			
			
//			addChild(_bitmap);
//			addChild(_realBitmap);
//			addChild(_txt);
//			addChild(hslider);
		}
		
//		 override public function addChild(child:DisplayObject):DisplayObject{
//		 	var ui:UIComponent = new UIComponent()
//		 	ui.addChild(child);
//		 	return box.addChild(ui);
//		 }
		
		private function layout():void{
			box.refresh();
//			_txt.y = _bitmap.y+_bitmap.height + 10
//			hslider.x = _bitmap.x + _bitmap.width + 10;
//			hslider.y = _bitmap.y + 30;
//			_realBitmap.y = hslider.y + 100;
//			_realBitmap.x = hslider.x
		}
		
		private function createCompleteHandler(event:FlexEvent):void{
			layout()
		}
		
		
		private function sliderHandler(event:Event):void{
			var value:int = (event is SliderEvent) ? (event as SliderEvent).value :hslider.value; 
			showImage(0,value);
		}
		
		public function setGifPath(url:String):void{
			var loader:RFStreamLoader = new RFStreamLoader(url);
			loader.addEventListener(RFLoaderEvent.COMPLETE,gifLoadCompleteHandler);
			loader.load();
		}
		
		
		private function gifLoadCompleteHandler(event:RFLoaderEvent):void{
			(event.target as IEventDispatcher).removeEventListener(RFLoaderEvent.COMPLETE,gifLoadCompleteHandler);
			var b:ByteArray = event.arg as ByteArray;
			b.position = 0;
			_decoder.read(b);
			this.dispatchEvent(new Event(Event.CHANGE));
			_bitmapData = _decoder.getFrame(0);
			this._bitmap.bitmapData = _bitmapData
			this._realBitmap.bitmapData = _bitmapData;
			_bitmap.width *= 5
			_bitmap.height *= 5
			layout();
		}
		
		public function get decoder():GIFDecoder{
			return _decoder;
		}
		
		private function showImage(frame:int = 0,number:int = 0):void{
			_bitmapData = _decoder.getFrame(frame);
			
			_realBitmap.bitmapData = this._bitmap.bitmapData = replaceColor(_bitmapData,70,number)
		}
		
		public function startListener():void{
			if(_bitmapData)
				this.addEventListener(Event.ENTER_FRAME,enterframeHandler);
		}
		
		public function stopListener():void{
			this.removeEventListener(Event.ENTER_FRAME,enterframeHandler);
		}
		
		private function rollhandelr(event:MouseEvent):void{
			event.type == MouseEvent.ROLL_OVER ? startListener() : stopListener();
		}
		
		private function enterframeHandler(event:Event):void{
			var mousex:int = _bitmap.mouseX;
			var mousey:int = _bitmap.mouseY;
			var color:int = _bitmapData.getPixel(mousex,mousey)
			var hsl:Array = ColorUtils.RGB2HSL(color);
			_txt.text = color.toString(16).toLocaleUpperCase() + "\n" + 
						hsl.join(" ");
		}
		
		
		private function replaceColor(b:BitmapData,f:int,t:int):BitmapData{
			if(f==t) return b;
			b = b.clone();
			var w:int = b.width;
			var h:int = b.height;
			for(var i:int = 0;i<w;i++){
				for(var j:int = 0;j<h;j++){
					var temp:Array = ColorUtils.RGB2HSL(b.getPixel(i,j))
					var offset:int = temp[0]-f;
					if(Math.abs(offset)<2){
						t += offset
						b.setPixel(i,j,ColorUtils.HSL2RGB(t,temp[1],temp[2]));
					}
				}
			}
			
			return b;
		}
		
			
	}
}