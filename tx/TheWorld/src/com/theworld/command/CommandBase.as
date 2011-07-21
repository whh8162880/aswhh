package com.theworld.command
{
	import com.event.RFEventDispatcher;
	
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	public class CommandBase extends RFEventDispatcher
	{
		protected var type:String;
		public function CommandBase(type:String)
		{
			super();
			this.type = type;
			commandDict = new Dictionary();
			commands = [];
			init();
		}
		
		protected function init():void{
			
		}
		
		public function getType():String{
			return type;
		}
		
		public function doCommand(cmds:Array):void{
			execCommand(cmds);
		}
		
		protected function execCommand(cmds:Array):void{
			if(!cmds || !cmds.length){
				return;
			}
			var f:Function = commandDict[cmds[0]];
			if(f!=null){
				f(cmds);
			}
		}
		
		public var commands:Array;
		private var commandDict:Dictionary;
		public function addCmd(cmd:String,data:Function = null):void{
			if(commands.indexOf(cmd)==-1){
				commands.push(cmd);
			}
			if(data!=null){
				commandDict[cmd] = data;
			}
		}
	}
}