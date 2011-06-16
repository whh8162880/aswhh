package com.tool
{
	import com.OpenFile;
	import com.csv.CsvBase;
	
	import flash.filesystem.File;

	public class NPCOnceTool extends CsvBase
	{
		public function NPCOnceTool(type:String)
		{
			super(type);
		}
		
		private var reg:RegExp = /<P>(.*?)<\/P>/g;
		public function decoder(file:File):void{
			var str:String = OpenFile.openAsTxt(file);
			var arr:Object;
			var index:int = reg.lastIndex = 0;
			var len:int = str.length;
			var datas:Array = [];
			var str2:String = '';
			while(index<len){
				arr = reg.exec(str);
				if(arr){
					str2 = arr[1];
					str2 = str2.replace("(","（");
					str2 = str2.replace(")","）");
					str2 = str2.replace("）","） ");
					str2 = str2.replace(/[\s　]{2,}/g," "); 
					str2 = str2.replace(/百 姓 |百 姓|普通百姓/g,"百姓");
					str2 = str2.replace("少 林 寺","少林寺");
					str2 = str2.replace("唐 门","唐门");
					str2 = str2.replace("双 龙 帮","双龙帮");
					str2 = str2.replace("魔 教","魔教");
					str2 = str2.replace("王 府","王府");
					datas.push(str2);
				}
				
				index = reg.lastIndex;
				if(index==0){
					break;
				}
				trace(index,len)
			}
			var f:File = write(datas,getpath(file)+"temp"+file.name.replace(file.type,"")+".dat",false);
			writeString(datas.join("\r\n"),getpath(file)+"temp"+file.name.replace(file.type,"")+".txt");
			decoder2(f);
		}
		
		public function decoder2(file:File):void{
			var arr:Array = OpenFile.openAsObj(file);
			arr.forEach(parserString);
			
			var temps:Array = [
						["id","编号",T_STRING],
						["name","名字",T_STRING],
						["city","城市",T_STRING],
						["pyname","拼音名字",T_STRING],
						["camp","阵营",T_STRING],
						["point","坐标",T_ARRAY],
						["items","道具",T_ARRAY],
						["level","武功评价",T_STRING]
				];
			
			var str:String = "";
			var ary:Array
			for each(ary in temps){
				str += encodeCsvValue(ary[0])+","
			}
			str = str.slice(0,str.length-1) + "\r\n";
			
			for each(ary in temps){
				str += encodeCsvValue(ary[1])+","
			}
			str = str.slice(0,str.length-1) + "\r\n";
			
			var i:int =0;
			var len:int = temps.length;
			for each(ary in arr){
				for(i=0;i<len;i++){
					str += encodeCsvValue(getValue(ary[i],temps[i][2]))+","
				}
				str +='\r\n';
			}
			writeString(str.slice(0,str.length-2),getpath(file,'.csv'),"gb2312");
		}
		
		private function parserString( element : *, index : int, arr : Array):void{
			var result:Array =[];
			var str:String = element;
			var temp:Array = /.[^0-9a-zA-Z]+/g.exec(str);
			var temp2:Array = /（(.*?)）/g.exec(str);
			str = str.replace(temp[0],"");
			if(temp2){
				str = str.replace(temp2[0],"");
			}
			var temp3:Array = str.split(" ");
			result.push("npc"+index);
			result.push((temp[0] as String).replace(/ /g,""));
			result.push(temp2 ? temp2[1] : "");
			result.push(temp3[0]+" "+temp3[1]);
			result.push(temp3[2]);
			result.push([int(temp3[3]),int(temp3[4])]);
			var i:int = 5;
			temp = [];
			while(i<temp3.length-1){
				temp.push(temp3[i++]);
			}
			result.push(temp.concat());
			result.push(temp3[temp3.length-1]);
			
			arr[index]= result;
		}
		
		
		private var reg2:RegExp = /<FONT.*?color=#cc00cc>(.*?)<\/FONT>/g
		public function decodeItem(file:File):void{
			var str:String = OpenFile.openAsTxt(file);
			str = str.replace(/\r|\n/g,"");
			var arr:Object;
			var index:int = reg2.lastIndex = 0;
			var len:int = str.length;
			var datas:Array = [];
			var str2:String = '';
			while(index<len){
				arr = reg2.exec(str);
				if(arr){
					str2 = arr[1];
					str2 = str2.replace("&nbsp;","");
					datas.push(str2);
				}
				
				index = reg2.lastIndex;
				if(index==0){
					break;
				}
				trace(index,len)
			}
			var f:File = write(datas,getpath(file)+"temp"+file.name.replace(file.type,"")+".dat",false);
			writeString(datas.join("\r\n"),getpath(file)+"temp"+file.name.replace(file.type,"")+".txt");
			decodeItem2(f);
		}
		
		public function decodeItem2(file:File):void{
			var arr:Array = OpenFile.openAsObj(file);
			var temps:Array = [
				["name","名字",T_STRING],
				["pyname","拼音名字",T_STRING]
			];
			
			var str:String = "";
			var ary:Array
			for each(ary in temps){
				str += encodeCsvValue(ary[0])+","
			}
			str = str.slice(0,str.length-1) + "\r\n";
			
			for each(ary in temps){
				str += encodeCsvValue(ary[1])+","
			}
			str = str.slice(0,str.length-1) + "\r\n";
			
			var i:int =0;
			var len:int = temps.length;
			for each(var str2:String in arr){
				str += encodeCsvValue(str2)+","
				str += encodeCsvValue(PinYinUtils.getPinYin(str2));
				str +='\r\n';
			}
			writeString(str.slice(0,str.length-2),getpath(file,'.csv'),"gb2312");
		}
	}
}