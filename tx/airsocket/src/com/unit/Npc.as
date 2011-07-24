package com.unit
{
	import com.socket.TXSocketServer;

	public class Npc
	{
		protected var server:TXSocketServer;
		public function Npc(server:TXSocketServer)
		{
			this.server = server;
		}
	}
}