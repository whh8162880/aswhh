package com.theworld.scene
{
	import com.scene.core.SceneBase;
	import com.theworld.core.CoreGlobal;
	import com.theworld.net.socket.TxSocket;
	import com.theworld.vo.LoginVO;
	
	import flash.events.Event;
	
	public class SceneInit extends SceneBase
	{
		public function SceneInit(sceneName:String = 'SceneInit')
		{
			super(sceneName);
		}
		
		override public function initialize():void{
			var vo:LoginVO = CoreGlobal.loginVO;
			connect(vo.gameip,vo.gameport);
			super.initialize();
		}
		
		private function connect(ip:String,prot:int):void{
			var socket:TxSocket = new TxSocket();
			socket.addEventListener(Event.CONNECT,connectHandler);
			CoreGlobal.socket = socket;
			socket.connect(ip,prot);
		}
		
		
		private function connectHandler(event:Event):void{
			trace("连接服务器成功");
			nextScene = "SceneMain"
			//sleep();
		}
		
		override protected function initStart():void{
			
		}
	}
}