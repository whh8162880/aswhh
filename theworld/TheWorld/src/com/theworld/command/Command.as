package com.theworld.command
{
	import com.theworld.command.cmd.GCommand;
	
	import flash.utils.Dictionary;

	public class Command
	{
		private static var instance:Command = new Command();
		public static function doCommand(str:String):Boolean{
			return instance.doCommand(str);
		}
		
		private var commandDict:Dictionary;
		public function Command()
		{
			init();
		}
		
		
		
		public function init():void{
			commandDict = new Dictionary();
			var gcmd:GCommand = new GCommand();
			commandDict["sleep"] = gcmd;
		}
		
		public function doCommand(str:String):Boolean{
//			if(str.charAt(0)!="@"){
//				return false;
//			}
			str = str.replace(/[\s　]{2,}/g," "); 
			var arr:Array = str.split(" ");
			var cmd:CommandBase = commandDict[arr[0]];
			if(!cmd){
				return false;
			}
			cmd.doCommand(arr);
			return true;
		}
	}
}