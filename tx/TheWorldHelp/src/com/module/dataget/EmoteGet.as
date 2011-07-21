package com.module.dataget
{
	import com.OpenFile;
	import com.csv.CsvBase;
	import com.theworld.module.emote.vo.EmoteVO;
	import com.tool.Config;
	
	import flash.filesystem.File;
	import flash.globalization.Collator;
	import flash.net.registerClassAlias;
	
	public class EmoteGet extends CsvBase
	{
		public function EmoteGet()
		{
			super("");
			registerClassAlias("EmoteVO",EmoteVO);
		}
		
		public function dedecoder(f:File,str:String):void{
//			str = str.replace(/<p.*?>|<\/p>|<br.*?>|<table.*?>|<\/table.*?>/g,"");
//			writeString(str,getpath(f,"2.xml"));
			str = str.replace(/\n|\r| /g,"");
			var reg:RegExp = /<tbody>(.*?)<\/tbody>/g;
			var dataarr:Array = [];
			var arr:Object;
			var len:int = str.length;
			var index:int = 1;
			while(index!=0 && index<len){
				arr = reg.exec(str);
				index = reg.lastIndex;
				if(!arr){
					break;
				}
				dataarr.push(arr[1]);
			}
			
			dataarr.forEach(foreach);
			
			write(dataarr,Config.resourcePath+"emote.dat");
		}
		
		override protected function foreach(element:*, temp:int, arr:Array):void{
			var str:String = element;
			str = str.replace(/&ldquo;|&rdquo;/g,'"')
			var dataArr:Array = [];
			var reg:RegExp = /<td.*?>(.*?)<\/td>/g;
			var arrs:Object;
			var len:int = str.length;
			var index:int = 1;
			while(index!=0 && index<len){
				arrs = reg.exec(str);
				index = reg.lastIndex;
				if(!arrs){
					break;
				}
				dataArr.push(arrs[1]);
			}
			
			var vo:EmoteVO = new EmoteVO();
			vo.cn = dataArr[1];
			vo.en = dataArr[3];
			vo.none = dataArr[5];
			vo.target = dataArr[7];
			vo.self = dataArr[9];
			
			arr[temp] = vo;
		}
		
	}
}