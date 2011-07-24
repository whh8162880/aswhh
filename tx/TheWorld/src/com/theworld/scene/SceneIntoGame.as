package com.theworld.scene
{
	import com.scene.core.SceneBase;
	import com.theworld.core.CoreGlobal;
	import com.theworld.module.game.avatar.player.HeroVO;
	
	import flash.events.Event;
	import flash.net.sendToURL;
	
	public class SceneIntoGame extends SceneBase
	{
		public function SceneIntoGame(sceneName:String='SceneIntoGame')
		{
			super(sceneName);
		}
		
		override protected function initStart():void{
			var hero:HeroVO = CoreGlobal.currentRole;
			CoreGlobal.sendCallback(10002,hero.guid,intoHandler);
		}
		
		private function intoHandler(data:*):void{
			var hero:HeroVO = CoreGlobal.currentRole;
			nextScene = 'SceneMain';
			sleep();
		}
	}
}