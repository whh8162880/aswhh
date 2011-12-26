package com.utils
{
	public class DataUtils
	{
		public function DataUtils()
		{
		}
		
		
		public static function copyToVOPropery(form:Object,toVO:Object):void{
			for (var p:String in form){
				if(toVO.hasOwnProperty(p)){
					toVO[p] = form[p];
				}
			}
		}
	}
}