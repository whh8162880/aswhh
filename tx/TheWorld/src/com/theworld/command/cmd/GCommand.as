package com.theworld.command.cmd
{
	import com.theworld.command.CommandBase;
	
	public class GCommand extends CommandBase
	{
		public function GCommand()
		{
			super("g");
			
			addCmd("sleep",sleep);
		}
		
		public function sleep(cmds:Array):void{
			trace("睡觉")
		}
	}
}