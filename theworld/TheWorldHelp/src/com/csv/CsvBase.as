package com.csv
{
	public class CsvBase
	{
		public var type:String
		public function CsvBase(type:String)
		{
			this.type = type;
		}
		
		public function parser(arr:Array):void{
			
		}
		
		protected function csv2Objs(arr:Array):Array{
			var str:String = arr.shift();
			var ps:Array = str.split(",");
			for each(str in arr){
				
			}
		}
	}
}