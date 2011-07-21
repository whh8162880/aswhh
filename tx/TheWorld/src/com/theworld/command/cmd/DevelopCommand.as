package com.theworld.command.cmd
{
	import com.theworld.command.CommandBase;
	import com.theworld.utils.TXHelp;
	
	public class DevelopCommand extends CommandBase
	{
		public function DevelopCommand()
		{
			super("develop");
			
			addCmd("/clear",clear);
		}
		
		public function clear(cmds:Array):void{
			TXHelp.chatModel.clear();
		}
		
		
	}
}