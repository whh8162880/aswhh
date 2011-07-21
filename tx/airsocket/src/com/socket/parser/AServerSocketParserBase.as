package com.socket.parser
{
	import com.socket.AirSocketServer;
	import com.socket.ServerSocketParser;

	public class AServerSocketParserBase
	{
		protected var serverSocketParser:ServerSocketParser;
		protected var socketServer:AirSocketServer;
		public function AServerSocketParserBase(serverSocketParser:ServerSocketParser,socketServer:AirSocketServer)
		{
			this.serverSocketParser = serverSocketParser;
			this.socketServer = socketServer;
		}
		
		protected function regcmd(command:int,func:Function):void{
			serverSocketParser.regCmd(command,func);
		}
	}
}