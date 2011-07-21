package com.socket
{
	import com.net.socket.parser.SocketParserVO;
	import com.socket.client.AirClient;
	
	public class ServerSocketParserVO extends SocketParserVO
	{
		public function ServerSocketParserVO()
		{
			super();
		}
		
		public function doFunction2(client:AirClient,data:*):void{
			if(func != null){
				func(client,data);
			}
		}
		
		override public function doFunction(data:*):void{
			
		}
	}
}