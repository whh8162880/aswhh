package com.net.socket.parser
{
	public class SocketParserVO
	{
		public function SocketParserVO()
		{
			insertFuncs = [];
			callBackFuncs = [];
		}
		
		public var command:int;
		
		public var callBackFuncs:Array;
		
		public var insertFuncs:Array;
		
		public var _func:Function;
		
		public var doFunction:Function;
		
		public function set func(f:Function):void{
			_func = f;
			if(callBackFuncs.length || insertFuncs.length){
				doFunction = doHardFunction;
			}else{
				doFunction = _func;
			}
		}
		
		public function get func():Function{
			return _func;
		}
		
		
		public function doHardFunction(data:*):void{
			var f:Function
			if(_func != null){
				_func(data);
			}
			
			for each(f in insertFuncs){
				f(data);
			}
			
			while(callBackFuncs.length){
				f = callBackFuncs.pop();
				f(data);
			}
		}
		
		public function addInsertFunc(f:Function):void{
			if(insertFuncs.indexOf(f)==-1){
				insertFuncs.push(f);
			}
			doFunction = doHardFunction;
		}
		
		public function removeInsertFunc(f:Function):void{
			var i:int = insertFuncs.indexOf(f);
			if(i<0){
				return;
			}
			insertFuncs.splice(i,1);
		}
		
		public function addCallbackFunc(f:Function):void{
			if(callBackFuncs.indexOf(f)==-1){
				callBackFuncs.push(f);
			}
			doFunction = doHardFunction;
		}
		
		public function removeCallbackFunc(f:Function):void{
			var i:int = callBackFuncs.indexOf(f);
			if(i<0){
				return;
			}
			callBackFuncs.splice(i,1);
		}
	}
}