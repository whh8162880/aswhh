package com.socket
{
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;

	public class PolicyServer extends AirSocketServer
	{
		public function PolicyServer()
		{
		}
		
		private var cmd:String = '<policy-file-request/>';
		private var policyxml:String = '<?xml version="1.0"?><cross-domain-policy><site-control permitted-cross-domain-policies="all"/><allow-access-from domain="*" to-ports="*" /></cross-domain-policy>';
		override protected function serverSocketConnectHandler(event:ServerSocketConnectEvent):void{
			var socket:Socket = event.socket;
			socket.addEventListener(ProgressEvent.SOCKET_DATA,socketDataHandler);
		}
		
		protected function socketDataHandler(event:ProgressEvent):void{
			var socket:Socket = event.currentTarget as Socket;
			socket.removeEventListener(ProgressEvent.SOCKET_DATA,socketDataHandler);
			socket.writeUTFBytes(policyxml);
			socket.flush();
			socket.close();
		}
	}
}