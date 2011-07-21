package com.csv.parser
{
	import com.csv.CsvBase;
	
	import flash.filesystem.File;
	
	public class InitCsvParser extends CsvBase
	{
		public function InitCsvParser(type:String)
		{
			super(type);
		}
		
		override public function parser(file:File,arr:Array):void{
			arr = csv2Objs(arr);
			write(arr,file.parent.nativePath+"\\"+(file.name.replace(file.type,""))+".dat",false);
		}
		
		override public function getDisc():String{
			return "初始值"
		}
	}
}