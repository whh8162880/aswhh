package com.unit
{
	import com.socket.TXSocketServer;
	import com.theworld.module.game.avatar.player.HeroVO;

	public class User extends Npc
	{
		public var vo:HeroVO;
		public function User(vo:HeroVO,server:TXSocketServer)
		{
			super(server);
			this.vo = vo;
		}
	}
}