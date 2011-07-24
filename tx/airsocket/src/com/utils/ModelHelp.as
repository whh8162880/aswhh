package com.utils
{
	import com.model.ConfigModel;
	import com.model.user.UserModel;
	import com.socket.TXSocketServer;

	public class ModelHelp
	{
		public static var userModel:UserModel;
		public static var configModel:ConfigModel;
		
		
		public static function initModel(server:TXSocketServer):void{
			userModel = new UserModel(server);
			configModel = new ConfigModel(server);
		}
	}
}