package com.csv
{
	import com.OpenFile;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	

	public class CsvBase
	{
		public var type:String;
		public var disc:String;
		public function CsvBase(type:String,disc:String="未知功能")
		{
			this.type = type;
			this.disc = disc;
		}
		
		
		protected const T_STRING:int = 0;
		protected const T_INT:int = 1;
		protected const T_NUMBER:int = 2;
		protected const T_ARRAY:int = 3;
		
		public function parser(file:File,arr:Array):void{
			
		}
		
		public function getDisc():String{
			return disc;
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
		
		protected function foreach(element : *, index : int, arr : Array):void{
			
		}
		
		protected function write(data:*,path:String,deflate:Boolean = true):File{
			var b:ByteArray
			if(data is ByteArray){
				b = data;
			}else{
				b = new ByteArray();
				b.writeObject(data);
			}
			
			b.position = 0;
			if(deflate)
				b.deflate();
			return OpenFile.write(b,path);
		}
		
		protected function writeString(str:String,path:String,charset:String = 'utf-8'):void{
			var b:ByteArray = new ByteArray();
			b.writeMultiByte(str,charset);
			b.position = 0;
			OpenFile.write(b,path);
		}
		
		protected function getpath(file:File,type:String=null):String{
			if(type){
				return file.parent.nativePath+"\\"+(file.name.replace(file.type,""))+type
			}else{
				return file.parent.nativePath+'\\';
			}
		}
		
		protected function encodeCsvValue(str:String):String{
			if(str.indexOf(",")!=-1){
				str = '"'+str+'"';
			}
			return str;
		}
		
		protected function getValue(value:Object,type:int):String{
			switch(type){
				case T_ARRAY:
					return decodeArrayValue(value as Array);
					break;
			}
			return value.toString();
		}
		
		private var arrayLevels:Array = [";","|",":"];
		private function decodeArrayValue(value:Array,level:int=0):String{
			var str:String = '';
			for each(var o:* in value){
				if(o is Array){
					str += decodeArrayValue(o,level++);
				}else{
					str += o.toString()+arrayLevels[level];
				}
			}
			return str.slice(0,str.length-1);
		}
		
		
	}
}