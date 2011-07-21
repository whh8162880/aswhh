package com.theworld.module.chat
{
	import com.mvc.Model;
	import com.theworld.module.chat.event.ChatEvent;
	import com.theworld.module.chat.vo.ChatMessageVO;
	
	import flash.events.IEventDispatcher;
	
	public class ChatModel extends Model
	{
		public function ChatModel()
		{
			super();
		}
		
		public function addMessage(str:String):void{
			this.dispatchEvent(new ChatEvent(ChatEvent.ADD_MESSAGE,str));
		}
		
		public function clear():void{
			this.dispatchEvent(new ChatEvent(ChatEvent.CLEAR));
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
			
		}
		
	}
}