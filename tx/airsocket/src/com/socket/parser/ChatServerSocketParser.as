package com.socket.parser
{
	import com.socket.AirSocketServer;
	import com.socket.ServerSocketParser;
	import com.socket.TxClient;
	import com.socket.client.AirClient;
	import com.theworld.module.chat.channel.ChatChannel;
	import com.theworld.module.chat.vo.ChatMessageVO;
	
	import flash.utils.Dictionary;
	
	public class ChatServerSocketParser extends AServerSocketParserBase
	{
		/**
		 * 世界频道 
		 */		
		public static const WORLD:String = 'channel_world';
		
		private var channelParserDict:Dictionary
		public function ChatServerSocketParser(serverSocketParser:ServerSocketParser,socketServer:AirSocketServer)
		{
			super(serverSocketParser,socketServer);
			initChannel();
			regcmd(15002,receivePrivateChat);
			regcmd(15003,receiveNormalChat);
		}
		
		private function initChannel():void{
			channelParserDict = new Dictionary();
			channelParserDict[ChatChannel.C_WORLD] = worldChannelChat;
		}
		
		public function receivePrivateChat(client:TxClient,data:*):void{
			
		}
		
		public function receiveNormalChat(client:TxClient,data:*):void{
			var vo:ChatMessageVO = data;
			if(!vo){
				return;
			}
			var f:Function = channelParserDict[vo.index];
			if(f==null){
				return;
			}
			f(client,data);
		}
		
		private function worldChannelChat(client:TxClient,data:*):void{
			socketServer.sendByGroup(WORLD,encode(15003,data));
		}
	}
}