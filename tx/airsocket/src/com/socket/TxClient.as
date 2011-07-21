package com.socket
{
	import com.socket.client.AirClient;
	import com.socket.parser.ChatServerSocketParser;
	
	import flash.net.Socket;
	
	public class TxClient extends AirClient
	{
		public function TxClient(socket:Socket, index:Number, server:AirSocketServer)
		{
			super(socket, index, server);
		}
		
		override protected function onClient():void{
			server.addIntoGroup(ChatServerSocketParser.WORLD,this);
			server.sendByGroup(ChatServerSocketParser.WORLD,encodeData(15001,"有玩家进入"));
		}
		
	}
}