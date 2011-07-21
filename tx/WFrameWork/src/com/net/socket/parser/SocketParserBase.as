package com.net.socket.parser
{
	import com.net.socket.SocketServer;

	public class SocketParserBase
	{
		protected var parser:SocketParser;
		protected var server:SocketServer;
		public function SocketParserBase(parser:SocketParser,server:SocketServer)
		{
			this.parser = parser;
			this.server = server;
			bindCommand();
		}
		
		protected function bindCommand():void{
			
		}
		
		protected function regcmd(command:int,func:Function):void{
			parser.regCmd(command,func);
		}
	}
}