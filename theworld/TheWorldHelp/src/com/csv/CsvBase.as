package com.csv
{
	import com.OpenFile;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	

	public class CsvBase
	{
		public var type:String
		public function CsvBase(type:String)
		{
			this.type = type;
		}
		
		public function parser(file:File,arr:Array):void{
			
		}
		
		public function getDisc():String{
			return "未知功能"
		}
		
		protected function csv2Objs(arr:Array):Array{
			arr.forEach(doCsv2Objs);
			arr.shift();
			return arr;
		}
		
		private function doCsv2Objs( element : *, index : int, arr : Array):void{
			if(!index){
				return;
			}
			var ps:Array = arr[0];
			var o:Object = {};
			var len:int =ps.length;
			for(var i:int = 0;i<len;i++){
				o[ps[i]] = element[i];
			}
			
			arr[index] = o;
		}
		
		protected function write(data:*,path:String,inflate:Boolean = true):void{
			var b:ByteArray = new ByteArray();
			b.writeObject(data);
			b.position = 0;
			if(inflate)
				b.inflate();
			OpenFile.write(b,path);
		}
		
	}
}