package com.theworld.module.chat.vo
{
	public class ChatMessageVO
	{
		public function ChatMessageVO()
		{
		}
		
		/**
		 * 通道 
		 * 
		 *	0:私聊
			1:系统
			2:普通
			3:队伍
			4:帮派
			5:门派
			6:世界
			7:闲聊
		 */		
		public var index:int;
		
		/**
		 * 一些特殊的 
		 */		
		public var data:Object;
		
		/**
		 * fromGuid	发送者的guid
		 */		
		public var fg:String;
		
		/**
		 * fromName	发送者的name
		 */		
		public var fn:String;
		
		/**
		 *toGuid	接收者的guid 
		 */		
		public var tg:String;
		
		/**
		 *toName	接收者的name 
		 */		
		public var tn:String;
		
		/**
		 * 信息 
		 */		
		public var message:String;
		
		public function decode(arr:Array):ChatMessageVO{
			index = arr[0];
			fg = arr[1];
			fn = arr[2];
			message = arr[3];
			tg = arr[4];
			tn = arr[5];
			data = arr[6];
			return this;
		}
		
		public function encode():Array{
			return [index,fg,fn,message,tg,tn,data];
		}
	}
}