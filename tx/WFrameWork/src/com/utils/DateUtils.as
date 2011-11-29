package com.utils
{
	public class DateUtils
	{
		public function DateUtils()
		{
		}
		
		private static var p:RegExp = /[{](.*?)[}]/g;
		
		public static var weeks:Array = ["日","一","二","三","四","五","六"]
		
		public static function getFormatDate(format_str:String,date:Date = null):String{
			if(!format_str){
				return "";
			}
			if(!date){
				date = new Date();
			}
			var ss:String = '';
			var len:int = format_str.length;
			var arr:Object;
			var index:int = p.lastIndex = 0;
			var temp:String,temp0:String,temp1:String;
			while(index<len){
				arr = p.exec(format_str);
				if(arr){
					temp0 = arr[0];
					temp1 = arr[1];
					temp = format_str.substring(index,p.lastIndex - temp0.length);
					if(temp){
						ss += temp;
					}
					index = p.lastIndex;
					
					var temp1Len:int = temp1.length;
					switch(temp1.charAt(0)){
						case "y":
						case "Y":
							//年
							if(temp1Len >= 3){
								ss += date.fullYear.toString();
							}else{
								ss += (date.fullYear % 100).toString();
							}
							break;
						case "M":
							//月
							ss += getFormatSting((date.month+1).toString(),temp1Len);
							break;
						case "d":
						case "D":
							//日
							ss += getFormatSting(date.date.toString(),temp1Len);
							break;
						case "h":
						case "H":
							//时
							ss += getFormatSting(date.hours.toString(),temp1Len);
							break;
						case "m":
							//分
							ss += getFormatSting(date.minutes.toString(),temp1Len);
							break;
						case "s":
						case "S":
							//秒
							ss += getFormatSting(date.seconds.toString(),temp1Len);
							break;
						
						case "w":
						case "W":
							ss += "星期"+weeks[date.day];
							break;
						
					}
					
				}else{
					temp = format_str.substring(index);
					if(temp){
						ss += temp;
					}
					break;
				}
			}
			
			return ss;
		}
		
		public static function getFormatSting(c:String,len:int):String{
			if(c.length>=len){
				return c;
			}
			
			len = len - c.length;
			while(len-->0){
				c = "0"+c;
			}
			return c;
		}
	}
}