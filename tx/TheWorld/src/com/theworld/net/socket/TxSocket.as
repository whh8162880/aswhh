package com.theworld.net.socket
{
	import com.net.socket.SocketServer;
	import com.net.socket.parser.SocketParser;
	import com.theworld.net.socket.parser.ChatSocketParser;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class TxSocket extends SocketServer
	{
		public var parser:SocketParser;
		protected var writeBuffer:ByteArray;
		public function TxSocket()
		{
			parser = new SocketParser();
			writeBuffer = new ByteArray();
			super();
			receiveFunction = parser.decoder;
			initCmd();
		}
		
		public function initCmd():void{
			new ChatSocketParser(parser,this);
		}
		
		public function sendCommand(cmd:int,data:Object):void{
			writeBuffer.position = 0;
			writeBuffer.length = 0;
			writeBuffer.writeObject([cmd,data]);
			writeBuffer.position = 0;
			send(writeBuffer);
		}
		
		public function sendCallback(cmd:int,data:Object,func:Function):void{
			parser.regCallbackCmd(cmd,func);
			sendCommand(cmd,data);
		}
	}
}