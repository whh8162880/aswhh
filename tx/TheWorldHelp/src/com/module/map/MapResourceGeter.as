package com.module.map
{
	import com.OpenFile;
	import com.csv.CsvBase;
	import com.theworld.core.CoreGlobal;
	import com.tool.Config;
	import com.view.MapResourceGeterPanel;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	public class MapResourceGeter extends CsvBase
	{
		private var panel:MapResourceGeterPanel;
		public function MapResourceGeter()
		{
			super("");
			panel = new MapResourceGeterPanel();
			panel.show();
		}
		
		public function create():void{
			var w:int = 3000;
			var h:int = 3000;
			var ew:int = 100;
			var eh:int = 100;
			var offw:int = 0;
			var offh:int = 0;
			
			var cw:int = Math.ceil(w/ew);
			var ch:int = Math.ceil(h/eh);
			
			var i:int;
			var j:int;
			for(j=0;j<ch;j++){
				for(i=0;i<cw;i++){
					createArea(ew+offw,eh+offh,i,j);
				}
			}
				
			
			
		}
		
		private function createArea(w:int,h:int,x:int,y:int,write:Boolean = true):ByteArray{
			var i:int;
			var j:int;
			var b:ByteArray = new ByteArray();
			var len:int = w*h;
			for (i=0;i<len;i++){
				b.writeByte(0);
			}
			b.deflate();
			if(write)
				OpenFile.write(b,Config.resourcePath+"map/map"+x+"_"+y+".dat");
			b.position = 0;
			return b;
		}
		
		public function updataJpgMapData(resource:Object):void{
			var path:String = Config.mapResourcePath+"maprescfg.dat";
			write(resource[0],path,true);
			var b:ByteArray = resource[1];
			b.inflate();
			var w:int = b.readInt();
			var h:int = b.readInt();
			var db:ByteArray = new ByteArray();
			b.readBytes(db);
			
			panel.drawByteArray(resource[0],db,w,h);
			
			
			updataJpgMapData2(db,w,h,0,0,Math.ceil(w/100),Math.ceil(h/100)); 
		}
		
		private function updataJpgMapData2(b:ByteArray,w:int,h:int,i:int,j:int,mw:int,mh:int):void{
			
			if(i>=mw){
				j++;
				i = 0;
			}
			
			if(j>=mh){
				return;
			}
			
			var path:String = Config.mapResourcePath+"map"+i+"_"+j+".dat"
			
			var x:int;
			var y:int;
			var f:File = new File(path);
			var db:ByteArray;
			if(!f.exists){
				db = createArea(100,100,i,j,false);
			}else{
				db = OpenFile.open(f);
			}
			db.inflate();
			
			for (y=0;y<100;y++){
				if(j*100+y>=h){
					break;
				}
				for(x=0;x<100;x++){
					if(i*100+x>=w){
						break;
					}
					var len:int = y*100+x;
					var len2:int = (j*100+y)*w+(i*100)+x
					db[len] = b[len2] 
				}
			}
			
			trace(i,j);
			showMap(db,i,j);
			write(db,path,true);
			setTimeout(updataJpgMapData2,500,b,w,h,++i,j,mw,mh);
		}
		
		public function showMap(b:ByteArray,i:int,j:int):void{
			b.position = 0;
			var file:File = new File(Config.mapResourcePath+"maprescfg.dat");
			var mapres:Array;
			if(!file.exists){
				mapres = [];
			}else{
				mapres = OpenFile.openAsObj(file,true);
			}
			
			panel.drawByteArray2(mapres,b,i,j);
			
		}
		
		
	}
}