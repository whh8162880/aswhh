package com.net.socket
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	public class SocketServer extends Socket
	{
		protected var msgLen:int;
		protected var readBuffer:ByteArray;
		public var receiveFunction:Function;
		public function SocketServer(host:String=null, port:int=0)
		{
			super(host, port);
			addEventListener(Event.CONNECT,socketConnectHandler);
			addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
			addEventListener(Event.CLOSE,socketCloseHandler);
			readBuffer = new ByteArray();
			receiveFunction = receive;
		}
		
		override public function close():void{
			super.close();
			socketCloseHandler();
		}
		
		protected function socketConnectHandler(event:Event):void{
			trace("socketConnect")
			addEventListener(ProgressEvent.SOCKET_DATA,socketDataHandler);
		}
		
		protected function socketCloseHandler(event:Event = null):void{
			trace("socketClose")
			removeEventListener(ProgressEvent.SOCKET_DATA,socketDataHandler);
		}
		
		protected function ioErrorHandler(event:Event):void{
			trace("socket ioError")
		}
		
		protected function securityErrorHandler(event:Event):void{
			trace("socket securityError")
		}
		/**
		 * 接收到数据 进行处理 
		 * @param byte
		 * 
		 */		
		public function receive(byte:ByteArray):void{
			
		}
		
		/**
		 * 发送数据 
		 * @param byte
		 * 
		 */		
		public function send(byte:ByteArray):void{
			writeInt(byte.length);
			writeBytes(byte);
			flush();
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
			var availableLen:int = bytesAvailable;
			if(!msgLen){
				if(availableLen<4){
					return;
				}
				msgLen = readInt();
				availableLen -= 4;
			}
			
			if(!msgLen){
				return;
			}
			
			if(availableLen >= msgLen){
				readBuffer.length = 0;
				readBuffer.position = 0;
				readBytes(readBuffer,0,msgLen);
				receiveFunction(readBuffer);
				//读完一条命令后 缓冲区内可能又新的数据 继续读
				availableLen -= msgLen;
				msgLen = 0;
				if(connected && availableLen>0)
					socketDataHandler();
			}
		}
	}
}