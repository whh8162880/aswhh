package com.theworld.utils
{
	import mx.utils.StringUtil;

	public class TXCore
	{
		public function TXCore()
		{
		}
		
		public static function renderUserName(name:String,color:String):String{
			return StringUtil.substitute("<font color='{0}'> {1} </font>",color,name);
		}
	}
}