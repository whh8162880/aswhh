package com.csv
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	public class CsvManager extends EventDispatcher
	{
		public function CsvManager(target:IEventDispatcher=null)
		{
			super(target);
			csvdecoder = new CSVDecoder();
		}
		
		public static var instance:CsvManager = new CsvManager();
		public static function parser(str:String):void{
			instance.parser(str);
		}
		
		
		private var csvdecoder:CSVDecoder
		public function parser(str:String):void{
			var arr:Array = csvdecoder.decode(str);
		}
	}
}