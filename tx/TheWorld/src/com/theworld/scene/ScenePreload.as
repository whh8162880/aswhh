package com.theworld.scene
{
	import com.net.request.RequestQueueLoader;
	import com.net.request.StreamAsyncRequest;
	import com.net.request.event.RemoteOperationEvent;
	import com.scene.core.SceneBase;
	import com.theworld.core.CoreGlobal;
	import com.theworld.module.emote.vo.EmoteVO;
	import com.theworld.module.game.city.CityVO;
	import com.theworld.utils.TXHelp;
	import com.theworld.utils.UILocator;
	
	import flash.events.Event;
	import flash.net.registerClassAlias;
	import flash.utils.ByteArray;
	
	import mx.events.Request;
	
	public class ScenePreload extends SceneBase
	{
		public function ScenePreload()
		{
			super("ScenePreload");
			
			registerClassAlias("CityVO",CityVO);
			registerClassAlias("EmoteVO",EmoteVO);
		}
		
		override public function initialize():void{
			UILocator.bindContianer(CoreGlobal.stage,CoreGlobal.stage);
			super.initialize();
		}
		
		
		override protected function initStart():void{
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
		
		private function queueCompleteHandler(event:Event):void{
			sleep();
		}
		
		override protected function doStop():void{
			nextScene = 'SceneLogin';
		}
	}
}