package com.theworld.module.chat.channel
{
	import com.theworld.module.chat.vo.ChatChannelVO;
	import com.theworld.module.chat.vo.ChatMessageVO;
	import com.theworld.utils.TXCore;
	import com.utils.StringUtils;

	public class ChatChannel
	{
		public static const C_PRIVATE:int = 0;
		public static const C_WORLD:int = 6;
		
		public var index:int;
		public var cvo:ChatChannelVO;
		public var m:String = '<font color="{0}">{1}</font>';
		public function ChatChannel(vo:ChatChannelVO)
		{
			this.cvo = vo;
			this.index = vo.index;
		}
		
		public function renderText(vo:ChatMessageVO):String{
			return StringUtils.substitute(m,cvo.color,getTitle(vo)+vo.message);
		}
		
		protected function renderUserText(vo:ChatMessageVO):String{
			return TXCore.renderUserName(vo.fn,"#00FFFF") + ":"
		}
		
		protected function getTitle(vo:ChatMessageVO):String{
			return cvo.title + (vo.data ? "" : renderUserText(vo));
		}
		
	}
}