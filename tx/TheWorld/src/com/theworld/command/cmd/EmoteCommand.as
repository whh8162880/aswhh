package com.theworld.command.cmd
{
	import com.theworld.command.CommandBase;
	import com.theworld.module.emote.EmoteModel;
	import com.theworld.module.txmap.TXMapController;
	import com.theworld.utils.TXHelp;
	
	public class EmoteCommand extends CommandBase
	{
		protected var model:EmoteModel
		public function EmoteCommand()
		{
			super("emote");
			model = TXHelp.emoteModel;
		}
		
		private var values:Array = ['i','me'];
		override public function doCommand(cmds:Array):void{
			var type:String  = cmds.shift();
			var value:String = (cmds.length ? cmds.shift() : null);
			var target:String;
			var self:String;
			if(values.indexOf(value)==-1){
				target = value;
			}else{
				self = value;
			}
			model.doEmote(type,target,self);
		}
		
	}
}