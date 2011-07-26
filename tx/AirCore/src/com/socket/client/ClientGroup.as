package com.socket.client
{
	import com.socket.AirSocketServer;
	import com.utils.work.Work;
	
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;

	public class ClientGroup extends EventDispatcher
	{
		public var socketServer:AirSocketServer;
		public function ClientGroup(name:String,socketServer:AirSocketServer)
		{
			groupList = [];
			clientList = [];
			this.name = name;
			this.socketServer = socketServer;
		}
		public var name:String;
		protected var groupList:Array;
		protected var clientList:Array;
		public function addGroup(group:ClientGroup):void{
			if(groupList.indexOf(group) == -1){
				groupList.push(group);
			}
		}
		
		public function removeGroup(group:ClientGroup):void{
			var i:int = groupList.indexOf(group);
			if(i<0){
				return;
			}
			groupList.splice(i,1);
		}
		
		public function addClient(client:AirClient):void{
			if(clientList.indexOf(client) == -1){
				clientList.push(client);
				client.addGroup(this);
			}
		}
		
		public function removeClient(client:AirClient):void{
			var i:int = clientList.indexOf(client);
			if(i<0){
				return;
			}
			clientList[i].removeGroup(this);
			clientList.splice(i,1);
		}
		
		public function getClientList():Array{
			return clientList;
		}
		
		public function clear():void{
			groupList.length = 0;
			while(clientList.length){
				clientList[0].removeGroup(this);
				clientList.shift();
			}
		}
		
		private var currentSendByte:ByteArray;
		public function send(byte:ByteArray):void{
			var list:Array = clientList.concat();
			for each(var group:ClientGroup in groupList){
				list = list.concat(group.getClientList());
			}
			currentSendByte = byte;
			Work.addTask(name,list,doSend);
		}
		
		public function cancelSend():void{
			Work.removeTask(name);
		}
		
		protected function doSend(socket:AirClient):void{
			currentSendByte.position = 0;
			socket.send(currentSendByte);
		}
	}
}