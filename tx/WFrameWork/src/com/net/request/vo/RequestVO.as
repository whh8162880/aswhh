package com.net.request.vo
{
	public class RequestVO
	{
		public function RequestVO(id:String){
			this.id = id;
			this.handlers = [];
		}
		
		public var id:String;
		public var url:String;
		public var handlers:Array;
		public function addHandler(handler:Function):void{
			if(handlers.indexOf(handler)==-1){
				handlers.push(handler);
			}
		}
		
		public function removeHandler(handler:Function):Boolean{
			var i:int = handlers.indexOf(handler);
			if(i>-1){
				handlers.splice(i,1);
			}
			return handlers.length > 0;
		}
		
		public function doHandler(data:Object):void{
			for each(var f:Function in handlers){
				f(id,data);
			}
		}
		
		public function clear():void{
			handlers.length = 0;
		}
	}
}