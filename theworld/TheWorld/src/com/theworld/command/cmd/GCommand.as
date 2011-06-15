package com.theworld.command.cmd
{
	import com.theworld.command.CommandBase;
	
	public class GCommand extends CommandBase
	{
		public function GCommand()
		{
			super();
			this.type = 'g';
		}
		
		override public function doCommand(cmds:Array):void{
			execCommand(cmds);
		}
		
		public function f_sleep(cmds:Array):void{
			trace("睡觉")
		}
	}
}