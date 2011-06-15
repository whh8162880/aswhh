package com.net.socket
{
	import flash.net.Socket;
	
	public class SocketServer extends Socket
	{
		public function SocketServer(host:String=null, port:int=0)
		{
			super(host, port);
		}
	}
}