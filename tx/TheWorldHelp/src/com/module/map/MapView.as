package com.module.map
{
	import com.OpenFile;
	import com.csv.CsvBase;
	import com.theworld.core.CoreGlobal;
	import com.tool.Config;
	import com.view.MapViewPanel;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class MapView extends CsvBase
	{
		public function MapView()
		{
			super("");
			
		}
		
		private var panel:MapViewPanel;
		private var mapres:Array;
		public function init():void{
			
			var file:File = new File(Config.mapResourcePath+"maprescfg.dat");
			if(!file.exists){
				mapres = [];
			}else{
				mapres = OpenFile.openAsObj(file,true);
			}
			
			var i:int = -1
			var j:int = -1;
			var w:int = 3;
			var h:int = 3;
			
			panel = new MapViewPanel();
			panel.create((w-i)*100,(w-i)*100);
			panel.show();
			
			
			var bs:Array = [];
			for(j;j<h;j++){
				i = -1;
				for(i;i<w;i++){
					bs.push(getMapdata(i,j));
				}
			}
			panel.initRender(0,0,mapres,bs,w+1,h+1,1);
			
		}
		
		private function getMapdata(x:int,y:int):ByteArray{
			var f:File = new File(Config.getMapDataPath(x,y));
			if(f.exists){
				var b:ByteArray = OpenFile.open(f);
				b.inflate();
				b.position = 0;
				return b;
			}
			return null;
		}
		
		public function render():void{
			
		}
	}
}