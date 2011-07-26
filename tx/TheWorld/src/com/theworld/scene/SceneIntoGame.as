package com.theworld.scene
{
	import com.map.MapModel;
	import com.scene.core.SceneBase;
	import com.theworld.core.CoreGlobal;
	import com.theworld.module.game.avatar.player.HeroVO;
	import com.theworld.utils.TXHelp;
	
	import flash.events.Event;
	import flash.net.sendToURL;
	
	public class SceneIntoGame extends SceneBase
	{
		private var mapmodel:MapModel
		public function SceneIntoGame(sceneName:String='SceneIntoGame')
		{
			super(sceneName);
		}
		
		override protected function initStart():void{
			mapmodel = TXHelp.mapModel;
			var hero:HeroVO = CoreGlobal.currentRole;
			CoreGlobal.resourceSocket.streamAsyncRequest(CoreGlobal.mappath+"maprescfg.dat",maprescfgloaderHandler);
		}
		
		private function maprescfgloaderHandler(id:String,data:Object):void{
			data = data[2];
			data.position = 0;
			data.inflate();
			var hero:HeroVO = CoreGlobal.currentRole;
			mapmodel.setMapres(data.readObject());
			mapmodel.initHero(hero.x,hero.y).addEventListener(Event.COMPLETE,mapCompleteHandler);;
		}
		
		private function intoHandler(data:*):void{
			var hero:HeroVO = CoreGlobal.currentRole;
			nextScene = 'SceneMain';
			sleep();
		}
		
		private function mapCompleteHandler(event:Event):void{
			TXHelp.mapController.initSceneSize(4,4);
			CoreGlobal.sendCallback(10002,CoreGlobal.currentRole.guid,intoHandler);
		}
	}
}