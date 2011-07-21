package com.theworld.net.socket.parser
{
	import com.net.socket.SocketServer;
	import com.net.socket.parser.SocketParser;
	import com.net.socket.parser.SocketParserBase;
	
	public class ChatSocketParser extends TxSocketParserBase
	{
		public function ChatSocketParser(parser:SocketParser, server:SocketServer)
		{
			super(parser, server);
		}
		
		override protected function bindCommand():void{
			regcmd(15001,receiveSystemChat);
			regcmd(15002,receivePrivateChat);
			regcmd(15003,receiveNormalChat);
		}
		
		public function receiveSystemChat(data:*):void{
			showMessage(data);
		}
		
		public function receivePrivateChat(data:*):void{
			
		}
		
		public function receiveNormalChat(data:*):void{
			
		}
	}
}