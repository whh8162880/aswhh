package com.theworld.utils
{
	import com.utils.StringUtils;

	public class TXCore
	{
		public function TXCore()
		{
		}
		
		public static function renderUserName(name:String,color:String):String{
			return StringUtils.substitute("<font color='{0}'> {1} </font>",color,name);
		}
	}
}