package com.socket
{	
	import com.socket.client.AirClient;
	import com.socket.client.ClientGroup;
	
	import flash.events.Event;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	import flash.net.Socket;
	import flash.sampler.stopSampling;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class AirSocketServer extends ServerSocket
	{
		public function AirSocketServer()
		{
			clientDict = new Dictionary();
			index = 0;
			receiveFunction = receive;
			groupDict = new Dictionary();
		}
		
		override public function listen(backlog:int=0):void{
			addEventListener(Event.CLOSE,serverSocketCloseHandler);
			addEventListener(ServerSocketConnectEvent.CONNECT,serverSocketConnectHandler);
			super.listen(backlog);
		}
		
		public function receive(client:AirClient,byte:ByteArray):void{
			
		}
		
		private var index:Number;
		private var clientDict:Dictionary;
		public var receiveFunction:Function;
		protected function serverSocketConnectHandler(event:ServerSocketConnectEvent):void{
			var socket:Socket = event.socket;
			var client:AirClient = createClient(socket,index);
			clientDict[index] = client;
			client.addEventListener(Event.CLOSE,clientCloseHandler);
			index++;
		}
		
		protected function createClient(socket:Socket,index:Number):AirClient{
			return new AirClient(socket,index,this);
		}
		
		protected function serverSocketCloseHandler(event:Event):void{
			removeEventListener(Event.CLOSE,serverSocketCloseHandler);
			while(index>=0){
				var client:AirClient = clientDict[index];
				if(client){
					client.close();
					clientDict[index] = null;
					delete clientDict[index];
				}
				index--;
			}
		}
		
		protected function clientCloseHandler(event:Event):void{
			var client:AirClient = event.currentTarget as AirClient;
			clientDict[client.index] = null;
			delete clientDict[client.index];
		}
		
		private var groupDict:Dictionary;
		public function getGroup(name:String,create:Boolean = false):ClientGroup{
			var group:ClientGroup = groupDict[name];
			if(!group){
				if(!create){
					return null;
				}
				group = new ClientGroup(name,this);
				groupDict[name] = group;
			}
			return group;
		}
		
		public function removeGroup(name:String):void{
			var group:ClientGroup = groupDict[name];
			if(!group){
				return;
			}
			groupDict[name] = null;
			delete groupDict[name];
			group.clear();
		}
		
		public function addIntoGroup(name:String,client:AirClient):void{
			var group:ClientGroup = getGroup(name,true);
			group.addClient(client);
		}
		
		public function outFromGroup(name:String,client:AirClient):void{
			var group:ClientGroup = groupDict[name];
			if(!group){
				return;
			}
			group.removeClient(client);
		}
		
		public function sendByGroup(name:String,data:ByteArray):void{
			var group:ClientGroup = groupDict[name];
			if(!group){
				return;
			}
			group.send(data);
		}
	}
}