package com.net.socket.parser
{
	public class SocketParserVO
	{
		public function SocketParserVO()
		{
			insertFuncs = [];
		}
		
		public var command:int;
		
		public var insertFuncs:Array;
		
		public var func:Function;
		
		public function doFunction(data:*):void{
			if(func != null){
				func(data);
			}
			for each(var f:Function in insertFuncs){
				f(data);
			}
		}
		
		public function addInsertFunc(f:Function):void{
			if(insertFuncs.indexOf(f)==-1){
				insertFuncs.push(f);
			}
		}
		
		public function removeInsertFunc(f:Function):void{
			var i:int = insertFuncs.indexOf(f);
			if(i<0){
				return;
			}
			insertFuncs.splice(i,1);
		}
	}
}