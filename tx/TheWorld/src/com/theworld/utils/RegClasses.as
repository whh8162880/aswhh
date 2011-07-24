package com.theworld.utils
{
	import com.theworld.module.chat.vo.ChatMessageVO;
	import com.theworld.module.emote.vo.EmoteVO;
	import com.theworld.module.game.avatar.player.HeroVO;
	import com.theworld.module.game.city.CityVO;
	
	import flash.net.registerClassAlias;

	public class RegClasses
	{
		
		public static function init():void{
			registerClassAlias("ChatMessageVO",ChatMessageVO);
			registerClassAlias("CityVO",CityVO);
			registerClassAlias("EmoteVO",EmoteVO);
			registerClassAlias("HeroVO",HeroVO);
		}
	}
}