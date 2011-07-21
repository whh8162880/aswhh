package com.theworld.utils
{
	import com.theworld.core.CoreGlobal;

	public class TxResourceHelp
	{
		public function TxResourceHelp()
		{
		}
		
		public static function getMapResource(res:String = ''):String{
			return CoreGlobal.serverpath + "map/"+res;
		}
	}
}