package com.theworld.net.socket
{
	import com.net.socket.SocketServer;
	import com.net.socket.parser.SocketParser;
	import com.theworld.net.socket.parser.ChatSocketParser;
	
	import flash.utils.ByteArray;
	
	public class TxSocket extends SocketServer
	{
		public var parser:SocketParser;
		public function TxSocket()
		{
			parser = new SocketParser();
			super();
			receiveFunction = parser.decoder;
			initCmd();
		}
		
		public function initCmd():void{
			new ChatSocketParser(parser,this);
		}
	}
}