package com.theworld.module.chat
{
	import com.mvc.Controller;
	import com.theworld.module.chat.channel.ChatChannel;
	import com.theworld.module.chat.event.ChatEvent;
	import com.theworld.module.chat.vo.ChatChannelVO;
	
	import flash.events.IEventDispatcher;
	
	import rfcomponents.SkinBase;
	
	public class ChatController extends Controller
	{
		public function ChatController(target:IEventDispatcher=null)
		{
			super(target);
		}
		private var model:ChatModel;
		private var view:ChatView;
		override protected function doSetModel(model:*):void{
			this.model = model;
			this.model.addEventListener(ChatEvent.ADD_MESSAGE,addMessageHandler);
			this.model.addEventListener(ChatEvent.CLEAR,clearMessage);
			
			var arr:Array = [];
			var vo:ChatChannelVO;
			var channel:ChatChannel;
			vo = new ChatChannelVO();
			vo.color = "#00FF00";
			vo.index = ChatChannel.C_WORLD;
			vo.title = '［世界］';
			channel = new ChatChannel(vo);
			arr.push(channel);
			
			vo = new ChatChannelVO();
			vo.color = "#FFFF00";
			vo.index = ChatChannel.C_PRIVATE;
			vo.title = '［密］';
			channel = new ChatChannel(vo);
			arr.push(channel);
			
			for each(channel in arr){
				this.model.addChannel(channel);
			}
		}
		
		override protected function doSetView(view:SkinBase):void{
			this.view = view as ChatView;
			this.view.addEventListener(ChatEvent.SEND_MESSAGE,sendMessageHandler);
		}
		
		private function addMessageHandler(event:ChatEvent):void{
			view.addMessage(event.data.toString());
		}
		
		public function clearMessage(event:ChatEvent):void{
			view.clearTestArea();
		}
		
		private function sendMessageHandler(event:ChatEvent):void{
			model.sendNormalMessage(ChatChannel.C_WORLD,event.data.toString());
		}
	}
}