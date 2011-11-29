package com.theworld.scene
{
	import com.net.request.RequestQueueLoader;
	import com.net.request.StreamAsyncRequest;
	import com.net.request.event.RemoteOperationEvent;
	import com.net.socket.resourcerequest.SocketResourceRequest;
	import com.module.scene.core.SceneBase;
	import com.theworld.core.CoreGlobal;
	import com.theworld.module.emote.vo.EmoteVO;
	import com.theworld.module.game.avatar.player.HeroVO;
	import com.theworld.module.game.city.CityVO;
	import com.theworld.utils.TXHelp;
	import com.theworld.vo.LoginVO;
	
	import flash.events.Event;
	import flash.net.registerClassAlias;
	
	public class ScenePreload extends SceneBase
	{
		public function ScenePreload()
		{
			super("ScenePreload");
		}
		
		override public function initialize():void{
			var loginvo:LoginVO = CoreGlobal.loginVO;
			var socket:SocketResourceRequest = new SocketResourceRequest(loginvo.resip,loginvo.resport);
			CoreGlobal.resourceSocket = socket;
			socket.streamAsyncRequest(CoreGlobal.configPath+"map.dat",socketResHandler);
			socket.streamAsyncRequest(CoreGlobal.configPath+"emote.dat",socketResHandler);
			super.initialize();
		}
		
		
		override protected function initStart():void{
			
			
			return;
			var queue:RequestQueueLoader = new RequestQueueLoader();
			queue.push(new StreamAsyncRequest(CoreGlobal.configPath+"map.dat","mapdefine"),queueHandler,"地图列表");
			queue.push(new StreamAsyncRequest(CoreGlobal.configPath+"emote.dat","emotedefine"),queueHandler,"emote");
			queue.addEventListener(Event.COMPLETE,queueCompleteHandler);
			queue.start();
		}
		
		private function queueHandler(event:RemoteOperationEvent):void{
			if(event.type != RemoteOperationEvent.REMOTE_OPERATION_SUCCESED){
				trace(event.id+' error');
				return;
			}
			switch(event.id){
				case "mapdefine":
					TXHelp.cityModel.decoder(event.data);
					break;
				case "emotedefine":
					TXHelp.emoteModel.decoder(event.data);
					break;
			}
		}
		
		private function socketResHandler(id:String,arr:Array):void{
			if(arr[0]==0){
				trace(id+' error');
				return;
			}
			switch(id){
				case CoreGlobal.configPath+"map.dat":
					TXHelp.cityModel.decoder(arr[2]);
					break;
				case CoreGlobal.configPath+"emote.dat":
					TXHelp.emoteModel.decoder(arr[2]);
					sleep();
					break;
			}
		}
		
		private function queueCompleteHandler(event:Event):void{
			sleep();
		}
		
		override protected function doStop():void{
			nextScene = 'SceneInit';
		}
	}
}