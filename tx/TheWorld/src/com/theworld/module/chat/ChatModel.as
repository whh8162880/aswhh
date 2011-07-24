package com.theworld.module.chat
{
	import com.mvc.Model;
	import com.theworld.core.CoreGlobal;
	import com.theworld.module.chat.channel.ChatChannel;
	import com.theworld.module.chat.event.ChatEvent;
	import com.theworld.module.chat.vo.ChatChannelVO;
	import com.theworld.module.chat.vo.ChatMessageVO;
	import com.theworld.utils.TXHelp;
	
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	public class ChatModel extends Model
	{
		protected var channelDict:Dictionary
		public function ChatModel()
		{
			super();
			channelDict = new Dictionary();
		}
		
		public function addChannel(vo:ChatChannel):void{
			channelDict[vo.index] = vo;
		}
		
		public function addMessage(str:String):void{
			this.dispatchEvent(new ChatEvent(ChatEvent.ADD_MESSAGE,str));
		}
		
		public function clear():void{
			this.dispatchEvent(new ChatEvent(ChatEvent.CLEAR));
		}
		
		public function receiveMessageVO(vo:ChatMessageVO):void{
			var channel:ChatChannel = channelDict[vo.index];
			if(channel){
				addMessage(channel.renderText(vo));
			}
		}
		
		/**
		 * 私聊通道 
		 * @param tn
		 * @param msg
		 * 
		 */		
		public function sendPrivateMessage(tn:String,msg:String):void{
			var vo:ChatMessageVO = new ChatMessageVO();
			vo.index = 0;
			vo.tn = tn;
			vo.message = msg;
			sendMessage(15002,vo);
		}
		
		/**
		 * 一般通道，很多人都能知道的通道
		 * @param channel
		 * @param msg
		 * @param type
		 * 
		 */		
		public function sendNormalMessage(channel:int,msg:String):void{
			var vo:ChatMessageVO = new ChatMessageVO();
			vo.index = channel;
			vo.message = msg;
			sendMessage(15003,vo);
		}
		
		/**
		 * 特性：
		 * 		emote 文字描述 
		 * @param channel
		 * @param tn
		 * @param msg
		 * 
		 */		
		public function sendEmoteMessage(channel:int,tn:String,msg:String):void{
			
		}
		
		protected function sendMessage(cmd:int,vo:ChatMessageVO):void{
			vo.fg = CoreGlobal.currentRole.guid;
			vo.fn = CoreGlobal.currentRole.name;
			CoreGlobal.send(cmd,vo);
		}
		
	}
}