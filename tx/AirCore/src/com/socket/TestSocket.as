package com.socket
{
//	import com.socket.client.AirClient;
	
	import flash.events.Event;
	import flash.net.ServerSocket;
	
	public class TestSocket extends ServerSocket
	{
		public function TestSocket()
		{
			
		}
		
		override public function listen(backlog:int=0):void{
			//init();
			super.listen(backlog);
		}
		
		public function init():void{
			addEventListener(Event.CONNECT,connentHandler);
			addEventListener(Event.CLOSE,connentHandler);
		}
		private function connentHandler(event:Event):void{
			
		}
				
	}
}