package com.socket
{
	import com.net.socket.parser.SocketParser;
	import com.net.socket.parser.SocketParserVO;
	import com.socket.client.AirClient;
	import com.socket.parser.ChatServerSocketParser;
	
	import flash.utils.ByteArray;

	public class ServerSocketParser extends SocketParser
	{
		protected var socketServer:AirSocketServer
		public function ServerSocketParser(socketServer:AirSocketServer)
		{
			this.socketServer =socketServer;
			new ChatServerSocketParser(this,socketServer);
			
		}
		
		public function serverDecoder(client:AirClient,byte:ByteArray):void{
			var o:Array = byte.readObject();
			var vo:ServerSocketParserVO = getParser(o[0]) as ServerSocketParserVO;
			vo.doFunction2(client,o[1]);
		}
		
		override public function decoder(byte:ByteArray):void{
			
		}
	}
}