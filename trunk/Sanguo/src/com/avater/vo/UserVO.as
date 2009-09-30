package com.avater.vo
{
	public class UserVO
	{
		public function UserVO()
		{
		}
		
		public var guid:String = "guest";
		public var nickname:String;
		
		// "F" "M"
		public var sex:String = "M";
		public var level:int;
		
		//0游客,1普通用户,2管理员,3超级管理员,9GM 
		public var userType:int=0;
		
		public var title:String;
		
		//0 npc,1玩家,2敌对的玩家,3可以攻击不敌对的npc,4敌对的NPC
		public var gameType:int = 1

	}
}