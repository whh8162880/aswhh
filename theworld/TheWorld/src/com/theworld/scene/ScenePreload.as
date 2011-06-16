package com.theworld.scene
{
	import com.net.request.RequestQueueLoader;
	import com.net.request.StreamAsyncRequest;
	import com.scene.core.SceneBase;
	import com.theworld.core.CoreGlobal;
	
	import flash.utils.ByteArray;
	
	import mx.events.Request;
	
	public class ScenePreload extends SceneBase
	{
		public function ScenePreload(sceneName:String)
		{
			super(sceneName);
		}
		
		override protected function initStart():void{
			var loading:RequestQueueLoader = new RequestQueueLoader();
			loading.push(new StreamAsyncRequest(CoreGlobal.serverpath+"map/1_map.dat"),mapLoadingComplete,"map");
			loading.addEventListener(
		}
		
		private function mapLoadingComplete(data:ByteArray):void{
			
		}
	}
}