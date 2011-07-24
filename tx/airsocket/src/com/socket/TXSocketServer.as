package com.socket
{
	import com.net.socket.parser.SocketParser;
	import com.socket.client.AirClient;
	import com.utils.ModelHelp;
	
	import flash.net.Socket;
	import flash.utils.ByteArray;

	public class TXSocketServer extends AirSocketServer
	{
		public var parser:ServerSocketParser;
		public function TXSocketServer()
		{
			ModelHelp.initModel(this);
			parser = new ServerSocketParser(this);
			super();
		}
		
		override public function receive(client:AirClient, byte:ByteArray):void{
			parser.serverDecoder(client,byte);
		}
		
		override protected function createClient(socket:Socket,index:Number):AirClient{
			return new TxClient(socket,index,this);
		}
	}
}