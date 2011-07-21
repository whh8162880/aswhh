package com.theworld.module.chat
{
	import com.mvc.Controller;
	import com.theworld.module.chat.event.ChatEvent;
	
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
		}
		
		override protected function doSetView(view:SkinBase):void{
			this.view = view as ChatView;
		}
		
		private function addMessageHandler(event:ChatEvent):void{
			view.addMessage(event.data.toString());
		}
		
		public function clearMessage(event:ChatEvent):void{
			view.clearTestArea();
		}
	}
}