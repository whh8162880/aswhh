package com.socket
{
	import com.OpenFile;
	import com.socket.client.AirClient;
	
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class ResourceSocket extends AirSocketServer
	{
		private var filePath:String;
		private var sendbyte:ByteArray;
		public function ResourceSocket(filePath:String)
		{
			this.filePath = filePath;
			sendbyte = new ByteArray();
			bytecache = new Dictionary();
			super();
		}
		
		public var bytecache:Dictionary;
		override public function receive(client:AirClient,byte:ByteArray):void{
			var url:String = byte.readObject();
			if(!url){
				client.send(encodeByte([0,url]));
				return;
			}
			var b:ByteArray = bytecache[url];
			if(!b){
				var file:File = new File(filePath+url);
				if(!file.exists){
					client.send(encodeByte([0,url]));
					return;
				}else{
					b = OpenFile.open(file);
					bytecache[url] = b;
				}
			}
			client.send(encodeByte([1,url,b]));
		}
		
		protected function encodeByte(data:Object):ByteArray{
			sendbyte.position = 0;
			sendbyte.length = 0;
			sendbyte.writeObject(data);
			return sendbyte;
		}
	}
}