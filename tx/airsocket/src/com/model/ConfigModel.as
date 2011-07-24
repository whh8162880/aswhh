package com.model
{
	import com.socket.TXSocketServer;
	
	import flash.utils.ByteArray;
	
	public class ConfigModel extends Model
	{
		public function ConfigModel(socketServer:TXSocketServer)
		{
			super(socketServer);
		}
		
		public function encode(cmd:int,data:Object):ByteArray{
			var writeByte:ByteArray = new ByteArray();
			writeByte.position = 0;
			writeByte.length = 0;
			writeByte.writeObject([cmd,data]);
			writeByte.position = 0;
			return writeByte;
		}
	}
}