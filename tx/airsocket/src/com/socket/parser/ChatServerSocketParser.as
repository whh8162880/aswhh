package com.socket.parser
{
	import com.socket.AirSocketServer;
	import com.socket.ServerSocketParser;
	import com.socket.TxClient;
	import com.socket.client.AirClient;
	
	public class ChatServerSocketParser extends AServerSocketParserBase
	{
		/**
		 * 世界频道 
		 */		
		public static const WORLD:String = 'channel_world';
		public function ChatServerSocketParser(serverSocketParser:ServerSocketParser,socketServer:AirSocketServer)
		{
			super(serverSocketParser,socketServer);
			
			regcmd(15002,receivePrivateChat);
			regcmd(15003,receiveNormalChat);
		}
		
		public function receivePrivateChat(client:TxClient,data:*):void{
			
		}
		
		public function receiveNormalChat(client:TxClient,data:*):void{
			
		}
	}
}