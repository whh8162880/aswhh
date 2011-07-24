package com.model.log
{
	public class Log
	{
		private static var _logArea:Ilog;
		public static function bindLogArea(value:Ilog):void{
			_logArea = value;
		}
		
		public static function print(...args):void{
			if(_logArea){
				_logArea.showlog.apply(null,args);
			}else{
				trace(args);
			}
		}
	}
}