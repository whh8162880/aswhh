package com.socket.client
{
	import com.socket.AirSocketServer;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	public class AirClient extends EventDispatcher
	{
		public var socket:Socket;
		public var server:AirSocketServer;
		public var index:Number;
		protected var msgLen:int;
		protected var readBuffer:ByteArray;
		protected var groupList:Array;
		public function AirClient(socket:Socket,index:Number,server:AirSocketServer)
		{
			this.socket = socket;
			this.server = server;
			this.index = index;
			readBuffer = new ByteArray();
			msgLen = 0;
			groupList = [];
			socket.addEventListener(ProgressEvent.SOCKET_DATA,socketDataHandler);
			socket.addEventListener(Event.CLOSE,socketCloseHandler);
			onClient();
		}
		
		protected function onClient():void{
			
		}
		
		public function send(byte:ByteArray):void{
			socket.writeInt(byte.length);
			socket.writeBytes(byte);
			socket.flush();
		}
		
		public function receive(byte:ByteArray):void{
			server.receiveFunction(this,byte);
		}
		
		
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
		
		
		/**
		 *  
		 * @param event
		 * progressData :
		 *  	len = readint();
		 * 		available = len;
		 * 
		 */		
		protected function socketDataHandler(event:ProgressEvent = null):void{
			var availableLen:int = socket.bytesAvailable;
			if(!msgLen){
				if(availableLen<4){
					return;
				}
				msgLen = socket.readInt();
				availableLen -= 4;
			}
			
			if(!msgLen){
				return;
			}
			
			if(availableLen >= msgLen){
				readBuffer.length = 0;
				readBuffer.position = 0;
				socket.readBytes(readBuffer,0,msgLen);
				receive(readBuffer);
				//读完一条命令后 缓冲区内可能又新的数据 继续读
				socketDataHandler();
			}
		}
		
		protected function socketCloseHandler(event:Event):void{
			close(event);
		}
		
		public function close(event:Event=null):void{
			socket.removeEventListener(ProgressEvent.SOCKET_DATA,socketDataHandler);
			socket.removeEventListener(Event.CLOSE,socketCloseHandler);
			if(event){
				dispatchEvent(event);
			}else{
				socket.close();
			}
			
			while(groupList.length){
				(groupList[0] as ClientGroup).removeClient(this);
			}
			
			socket = null;
			index = 0;

		}
		
		
		protected function encodeData(command:int,obj:Object):ByteArray{
			var b:ByteArray = new ByteArray();
			b.writeObject([command,obj]);
			b.position - 0;
			return b;
		}
		
	}
}