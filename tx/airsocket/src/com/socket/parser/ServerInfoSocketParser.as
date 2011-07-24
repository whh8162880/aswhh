package com.socket.parser
{
	import com.socket.AirSocketServer;
	import com.socket.ServerSocketParser;
	
	public class ServerInfoSocketParser extends AServerSocketParserBase
	{
		public function ServerInfoSocketParser(serverSocketParser:ServerSocketParser, socketServer:AirSocketServer)
		{
			super(serverSocketParser, socketServer);
		}
	}
}