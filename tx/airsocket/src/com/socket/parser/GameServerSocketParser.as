package com.socket.parser
{
	import com.socket.AirSocketServer;
	import com.socket.ServerSocketParser;
	
	public class GameServerSocketParser extends AServerSocketParserBase
	{
		public function GameServerSocketParser(serverSocketParser:ServerSocketParser, socketServer:AirSocketServer)
		{
			super(serverSocketParser, socketServer);
		}
	}
}