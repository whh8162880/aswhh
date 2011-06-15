package com.theworld.command
{
	import com.event.RFEventDispatcher;
	
	import flash.events.IEventDispatcher;
	
	public class CommandBase extends RFEventDispatcher
	{
		protected var type:String;
		public function CommandBase()
		{
			super();
			init();
		}
		
		protected function init():void{
			
		}
		
		public function doCommand(cmds:Array):void{
			cmds.shift();
			execCommand(cmds);
		}
		
		protected function execCommand(cmds:Array):void{
			if(!cmds.length){
				return;
			}
			var cmd:String = cmds.shift();
			if(this.hasOwnProperty("f_"+cmd)){
				this["f_"+cmd](cmds);
			}else{
				trace("找不到这条命令!")
			}
		}
	}
}