package com.csv.parser
{
	import com.csv.CsvBase;
	import com.theworld.module.game.city.CityVO;
	
	import flash.filesystem.File;
	import flash.net.registerClassAlias;
	
	public class MapCsvDecode extends CsvBase
	{
		public function MapCsvDecode(type:String)
		{
			registerClassAlias("CityVO",CityVO);
			super(type,"地图表");
		}
		
		override public function parser(file:File, arr:Array):void{
			arr.shift();
			arr = csv2Objs(arr);
			arr.forEach(foreach);
			write(arr,getpath(file,".dat"),true);
		}
		
		override protected function foreach(element:*, index:int, arr:Array):void{
			var vo:CityVO = new CityVO();
			for(var p:String in element){
				if(vo.hasOwnProperty(p)){
					vo[p] = element[p];
				}
			}
			arr[index] = vo;
		}
	}
}