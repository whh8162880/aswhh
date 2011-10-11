package com.utils
{
	import flash.external.ExternalInterface;
	

	public class JSExternalInterface
	{
		public function JSExternalInterface()
		{
		}
		
		public static function regFunction(type:String,func:Function):void{
			if(ExternalInterface.available){
				ExternalInterface.addCallback(type, func);
			}
		}
		
	}
}