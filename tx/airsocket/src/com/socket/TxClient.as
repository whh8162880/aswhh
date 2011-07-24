package com.socket
{
	import com.socket.client.AirClient;
	import com.socket.parser.ChatServerSocketParser;
	import com.theworld.module.game.avatar.player.HeroVO;
	import com.unit.User;
	import com.utils.ModelHelp;
	
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	public class TxClient extends AirClient
	{
		public var user:User;
		protected var writeByte:ByteArray;
		public function TxClient(socket:Socket, index:Number, server:AirSocketServer)
		{
			super(socket, index, server);
			writeByte = new ByteArray();
		}
		
		public function setUser(user:User):void{
			this.user = user;
			server.addIntoGroup(ChatServerSocketParser.WORLD,this);
		}
		
		public function sendCommand(cmd:int,data:Object):void{
			writeByte.position = 0;
			writeByte.length = 0;
			writeByte.writeObject([cmd,data]);
			writeByte.position = 0;
			send(writeByte);
		}
		
		override protected function onClose():void{
			ModelHelp.userModel.saveAndClose(user.vo.guid);
		}
		
	}
}