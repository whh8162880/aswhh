package com.view
{
	import com.OpenFile;
	import com.net.request.StreamAsyncRequest;
	import com.theworld.components.panel.TXPanel;
	import com.theworld.utils.TxResourceHelp;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import rfcomponents.image.ScrollImage;
	
	public class MapResourceGeterPanel extends TXPanel
	{
		public function MapResourceGeterPanel()
		{
			super();
			create(800,600);
		}
		
		private var image:ScrollImage;
		private var sprite:Sprite;
		override protected function bindComponents():void{
			image = new ScrollImage();
			addChild(image);
			var loader:StreamAsyncRequest = new StreamAsyncRequest(TxResourceHelp.getMapResource("北方.jpg"));
			loader.swfHandler = swfHandler;
//			loader.invoke();
			
			
			sprite = new Sprite();
			sprite.x = 350
			addChild(sprite);
			
		}
		
		private var bitmapdata:BitmapData
		protected function swfHandler(loader:Loader):void{
			bitmapdata = (loader.content as Bitmap).bitmapData
			image.setBitmapdata(bitmapdata,300,600);
			_skin.addEventListener(Event.ENTER_FRAME,logicBitmapdata);
			ch = 0;
		}
		
		
		private var images:Array = [];
		private var colors:Array = [];
		private var logicArr:Array = [[0,0],[1,0],[0,1],[1,1]]
		private var ch:int;
		private var e:int = 4
		private function logicBitmapdata(event:Event = null):void{
			if(ch>=bitmapdata.height-e){
				_skin.removeEventListener(Event.ENTER_FRAME,logicBitmapdata);
				OpenFile.write([colors,draw()],File.desktopDirectory.nativePath+"/test1.iss");
				return;
			}
			var arr:Array;
			var flag:Boolean
			for(var j:int = 0;j<e;j++){
				arr = [];
				for(var i:int = 0;i<bitmapdata.width;i++){
					var c:int = bitmapdata.getPixel(i,ch+j);
					var temp:int = 0;
					flag = false;
					for each(var c2:int in colors){
						if(isLike(c,c2)){
							flag = true
							arr.push(temp);
							break;
						}
						temp++;
					}
					if(!flag){
						arr.push(temp);
						colors.push(c);
					}
				}
				
				images.push(arr);
			}
			
			
			ch +=e ;
			trace(ch,bitmapdata.height)
			
		}
		
		private function isLike(c1:uint,c2:uint):Boolean{
			var arr1:Array = [(c1>>16) & 0xFF,((c1&0xFF00)>>8),c1&0xFF];
			var arr2:Array = [(c2>>16) & 0xFF,((c2&0xFF00)>>8),c2&0xFF];
			
			for (var i:int = 0;i<3;i++){
				if(Math.abs(arr1[i]-arr2[i])>4){
					return false;
				}
			}
			
			return true;
		}
		
		
		
		private function draw():ByteArray{
			var byte:ByteArray = new ByteArray();
			var bitmapdata:BitmapData = new BitmapData(this.bitmapdata.width,this.bitmapdata.height);
			byte.writeInt(bitmapdata.width);
			byte.writeInt(images.length);
			for(var j:int = 0;j<images.length;j++){
				for(var i:int = 0;i<bitmapdata.width;i++){
					bitmapdata.setPixel(i,j,colors[images[j][i]]);
					byte.writeByte(images[j][i]);
				}
			}
			
			sprite.graphics.beginBitmapFill(bitmapdata);
			sprite.graphics.drawRect(0,0,bitmapdata.width,bitmapdata.height);
			sprite.graphics.endFill();
			byte.position = 0;
			byte.deflate();
			return byte;
		}
		
		
		public function drawByteArray(res:Array,b:ByteArray,w:int,h:int):void{
			var g:Graphics = sprite.graphics
			g.clear();
			var bitmapdata:BitmapData = new BitmapData(w,h);
			var j:int
			var i:int
			for(j = 0;j<h;j++){
				for(i = 0;i<w;i++){
					bitmapdata.setPixel(i,j,res[b[j*w+i]]);
				}
			}
			
			g.beginBitmapFill(bitmapdata);
			g.drawRect(0,0,bitmapdata.width,bitmapdata.height);
			g.endFill();
			sprite.x = 10;
			sprite.y = 10;
			
			g.lineStyle(1,0xFF0000);
			w = Math.ceil(w/100);
			h = Math.ceil(h/100);
			for(i=0;i<=w;i++){
				g.moveTo(i*100,0);
				g.lineTo(i*100,h*100);
			}
			
			for(i=0;i<=h;i++){
				g.moveTo(0,i*100);
				g.lineTo(w*100,i*100);
			}
		}
		
		public function drawByteArray2(res:Array,b:ByteArray,x:int,y:int):void{
			var g:Graphics = sprite.graphics
			var bitmapdata:BitmapData = new BitmapData(100,100);
			var j:int
			var i:int
			for(j = 0;j<100;j++){
				for(i = 0;i<100;i++){
					bitmapdata.setPixel(i,j,res[b[j*100+i]]);
				}
			}
			
			g.beginBitmapFill(bitmapdata);
			g.drawRect(x*100,y*100,bitmapdata.width,bitmapdata.height);
			g.endFill();
		}
		
	}
}