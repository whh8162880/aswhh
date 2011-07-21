package com.theworld.net.socket.parser
{
	import com.net.socket.SocketServer;
	import com.net.socket.parser.SocketParser;
	import com.net.socket.parser.SocketParserBase;
	import com.theworld.module.chat.ChatModel;
	import com.theworld.utils.TXHelp;
	
	public class TxSocketParserBase extends SocketParserBase
	{
		public function TxSocketParserBase(parser:SocketParser, server:SocketServer)
		{
			super(parser, server);
			chatModel = TXHelp.chatModel;
		}
		
		protected var chatModel:ChatModel;
		protected function showMessage(str:String):void{
			chatModel.addMessage(str);
		}
	}
}