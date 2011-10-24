package com.module.plugin.vo
{
	public class PluginCommandVO
	{
		public function PluginCommandVO()
		{
		}
		
		public var command:String;
		
		public var func:Function;
		
		public var disc:String;
		
		public function decode(command:String,func:Function,disc:String):PluginCommandVO{
			this.command = command;
			this.func = func;
			this.disc = disc;
			return this;
		}
		
		public function toString():String{
			return command + "		" + disc;
		}
	}
}