package com.theworld.command
{
	import com.theworld.command.cmd.DevelopCommand;
	import com.theworld.command.cmd.GCommand;
	
	import flash.utils.Dictionary;

	public class Command
	{
		private static var instance:Command = new Command();
		public static function doCommand(str:String):Boolean{
			return instance.doCommand(str);
		}
		
		public static function regCommand(cmd:CommandBase):void{
			instance.regCommand(cmd);
		}
		
	
		public static function regCommandValue(type:String,cmd:String):void{
			instance.regCommandValue(type,cmd);
		}
		private var commandParserDict:Dictionary;
		private var commandDict:Dictionary;
		public function Command()
		{
			init();
		}
		
		
		
		public function init():void{
			commandDict = new Dictionary();
			commandParserDict = new Dictionary();
			regCommand(new GCommand());
			regCommand(new DevelopCommand());
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
		
		
		public function regCommand(cmd:CommandBase):void{
			var type:String = cmd.getType()
			commandParserDict[type] = cmd;
			for each(var value:String in cmd.commands){
				regCommandValue(type,value);
			}
		}
		
		public function regCommandValue(type:String,cmd:String):void{
			commandDict[cmd] = commandParserDict[type];
		}
	}
}