package com.socket.parser
{
	import com.model.user.UserModel;
	import com.socket.AirSocketServer;
	import com.socket.ServerSocketParser;
	import com.socket.TxClient;
	import com.socket.client.AirClient;
	import com.theworld.module.game.avatar.player.HeroVO;
	import com.unit.User;
	import com.utils.ModelHelp;
	
	import flash.filesystem.File;
	
	public class LoginServerSocketParser extends AServerSocketParserBase
	{
		private var userModel:UserModel;
		public function LoginServerSocketParser(serverSocketParser:ServerSocketParser, socketServer:AirSocketServer)
		{
			userModel = ModelHelp.userModel;
			super(serverSocketParser, socketServer);
			regcmd(10000,login);
			regcmd(10001,regPlayer);
			regcmd(10002,intogame);
		}
		
		private function login(client:TxClient,data:*):void{
			var user:User = userModel.getUser(data);
			client.setUser(user);
			client.sendCommand(10000,user.vo);
		}
		
		private function regPlayer(client:TxClient,data:*):void{
			var vo:HeroVO = client.user.vo;
			vo.name = data[0];
			vo.sex = data[1];
			vo.x = 30;
			vo.y = 30;
			client.sendCommand(10001,[1,vo]);
		}
		
		private function intogame(client:TxClient,data:*):void{
			var vo:HeroVO = client.user.vo;
			client.sendCommand(10002,[1,vo.x,vo.y]);
		}
	}
}