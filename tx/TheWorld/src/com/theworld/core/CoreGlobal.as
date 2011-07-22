package com.theworld.core
{
	import com.net.socket.resourcerequest.SocketResourceRequest;
	import com.theworld.module.game.avatar.player.HeroVO;
	import com.theworld.net.socket.TxSocket;
	import com.theworld.vo.LoginVO;
	
	import flash.display.Stage;

	public class CoreGlobal
	{
		public function CoreGlobal()
		{
		}
		
		public static var stage:Stage;
		
		public static var serverpath:String = 'http://127.0.0.1/';
		
		public static var mappath:String = 'map/';
		
		public static var configPath:String ='config/';
		
		public static var loginVO:LoginVO;
		
		
		public static var socket:TxSocket;
		
		public static var resourceSocket:SocketResourceRequest;
		
		public static var currentRole:HeroVO = new HeroVO();
		{
			currentRole.name = '天下'
		}
		
	}
}