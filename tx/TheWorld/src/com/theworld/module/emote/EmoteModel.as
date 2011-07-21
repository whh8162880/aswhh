package com.theworld.module.emote
{
	import com.mvc.Model;
	import com.theworld.command.Command;
	import com.theworld.command.CommandBase;
	import com.theworld.command.cmd.EmoteCommand;
	import com.theworld.core.CoreGlobal;
	import com.theworld.module.chat.ChatModel;
	import com.theworld.module.emote.vo.EmoteVO;
	import com.theworld.utils.TXCore;
	import com.theworld.utils.TXHelp;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class EmoteModel extends Model
	{
		private var chatmodel:ChatModel;
		public function EmoteModel()
		{
			chatmodel = TXHelp.chatModel;
		}
		
		private var emotelist:Array;
		private var emoteDict:Dictionary;
		public function decoder(b:ByteArray):void{
			b.position = 0;
			b.inflate();
			emotelist = b.readObject();
			emoteDict = new Dictionary();
			var cmd:CommandBase = new EmoteCommand();
			for each(var vo:EmoteVO in emotelist){
				emoteDict[vo.cn] = emoteDict[vo.en] = vo;
				cmd.addCmd(vo.cn);
				cmd.addCmd(vo.en);
			}
			Command.regCommand(cmd);
		}
		
		public function doEmote(cmd:String,target:String,self:String):void{
			showEmote(cmd,target,self);
		}
		
		
		public function showEmote(cmd:String,target:String,self:String):void{
			var vo:EmoteVO = emoteDict[cmd];
			if(!vo){
				return;
			}
			var str:String = '';
			if(self){
				str = vo.self;
			}else if(target){
				str = vo.target;
			}else{
				str = vo.none;
			}
			var username:String = CoreGlobal.currentRole.name;
			
			str = str.replace(/\$N/g,TXCore.renderUserName(username,"#00FF00"));
			str = str.replace(/\$n/g,TXCore.renderUserName(target,"#FF0000"));
			
			chatmodel.addMessage(str);
		}		
	}
}