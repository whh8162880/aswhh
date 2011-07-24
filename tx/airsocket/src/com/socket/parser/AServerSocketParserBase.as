package com.socket.parser
{
	import com.socket.AirSocketServer;
	import com.socket.ServerSocketParser;
	import com.utils.ModelHelp;
	
	import flash.utils.ByteArray;

	public class AServerSocketParserBase
	{
		protected var serverSocketParser:ServerSocketParser;
		protected var socketServer:AirSocketServer;
		protected var encode:Function;
		public function AServerSocketParserBase(serverSocketParser:ServerSocketParser,socketServer:AirSocketServer)
		{
			this.serverSocketParser = serverSocketParser;
			this.socketServer = socketServer;
			this.encode = ModelHelp.configModel.encode;
		}
		
		protected function regcmd(command:int,func:Function):void{
			serverSocketParser.regCmd(command,func);
		}
		
		
	}
}