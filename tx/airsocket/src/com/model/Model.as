package com.model
{
	import com.OpenFile;
	import com.socket.TXSocketServer;
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	public class Model extends EventDispatcher
	{
		protected var socketServer:TXSocketServer;
		protected var configFilePath:String;
		public function Model(socketServer:TXSocketServer)
		{
			this.socketServer = socketServer;
			configFilePath = File.applicationDirectory.nativePath+"/txdata/"
			init();
		}
		protected function init():void{
			
		}
		
		protected function getFile(path:String,useconfigpath:Boolean = true):ByteArray{
			if(useconfigpath){
				path = configFilePath + path;
			}
			var f:File = new File(path);
			return OpenFile.open(f);
		}
	}
}