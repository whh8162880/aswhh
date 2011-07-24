package com.socket
{
	import com.net.socket.parser.SocketParser;
	import com.net.socket.parser.SocketParserVO;
	import com.socket.client.AirClient;
	import com.socket.parser.ChatServerSocketParser;
	import com.socket.parser.LoginServerSocketParser;
	
	import flash.utils.ByteArray;

	public class ServerSocketParser extends SocketParser
	{
		protected var socketServer:AirSocketServer
		public function ServerSocketParser(socketServer:AirSocketServer)
		{
			this.socketServer =socketServer;
			new ChatServerSocketParser(this,socketServer);
			new LoginServerSocketParser(this,socketServer);
		}
		
		public function serverDecoder(client:AirClient,byte:ByteArray):void{
			var o:Array = byte.readObject();
			var vo:ServerSocketParserVO = getParser(o[0]) as ServerSocketParserVO;
			vo.doFunction2(client,o[1]);
		}
		
		override protected function getParser(command:int,autoCreate:Boolean = false):SocketParserVO{
			var vo:SocketParserVO = parserDict[command];
			if(!vo){
				if(!autoCreate){
					return null;
				}
				vo = new ServerSocketParserVO();
				vo.command = command;
				parserDict[command] = vo;
			}
			return vo;
		}
		
		override public function decoder(byte:ByteArray):void{
			
		}
	}
}