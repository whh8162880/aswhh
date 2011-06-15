package com.net.request
{
	import com.net.request.token.RemoteToken;
	
	public class BaseAsyncRequest
	{
		protected var token:RemoteToken
		public function BaseAsyncRequest()
		{
			token = new RemoteToken()
		}
		
		public function close():void{
			
		}
		
		public function invoke(handler:Function = null,progressFunction:Function = null):RemoteToken{
			return token;
		}

	}
}