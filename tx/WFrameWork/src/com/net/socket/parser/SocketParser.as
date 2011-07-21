package com.net.socket.parser
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class SocketParser
	{
		public function SocketParser()
		{
			parserDict = new Dictionary();
		}
		
		protected var parserDict:Dictionary;
		public function decoder(byte:ByteArray):void{
			var o:Array = byte.readObject();
			var vo:SocketParserVO = getParser(o[0]);
			if(vo){
				vo.doFunction(o[1]);
			}
		}
		
		public function regCmd(command:int,func:Function):void{
			var vo:SocketParserVO = getParser(command,true);
			vo.func = func;
		}
		
		public function regInsertCmd(command:int,func:Function):void{
			var vo:SocketParserVO = getParser(command,true);
			vo.addInsertFunc(func);
		}
		
		public function removeInsertCmd(command:int,func:Function):void{
			var vo:SocketParserVO = getParser(command,true);
			vo.removeInsertFunc(func);
		}
		
		protected function getParser(command:int,autoCreate:Boolean = false):SocketParserVO{
			var vo:SocketParserVO = parserDict[command];
			if(!vo){
				if(!autoCreate){
					return null;
				}
				vo = new SocketParserVO();
				vo.command = command;
				parserDict[command] = vo;
			}
			return vo;
		}
	}
}