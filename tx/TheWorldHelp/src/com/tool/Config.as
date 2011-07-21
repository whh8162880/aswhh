package com.tool
{
	public class Config
	{
		public function Config()
		{
		}
		
		public static var resourcePath:String = 'D:/theworld/txdata/';
		
		public static var mapResourcePath:String = resourcePath+"map/";
		
		public static function getMapDataPath(x:int,y:int):String{
			return resourcePath+"map/map"+x+"_"+y+".dat"
		}
	}
}