package com.theworld.core
{
	import com.theworld.module.game.avatar.player.HeroVO;
	import com.theworld.net.socket.TxSocket;
	
	import flash.display.Stage;

	public class CoreGlobal
	{
		public function CoreGlobal()
		{
		}
		
		public static var stage:Stage;
		
		public static var serverpath:String = 'http://127.0.0.1/';
		
		public static var mappath:String = 'http://127.0.0.1/map/';
		
		public static var configPath:String ='http://127.0.0.1/config/';
		
		
		public static var socket:TxSocket
		
		public static var currentRole:HeroVO = new HeroVO();
		{
			currentRole.name = '天下'
		}
	}
}