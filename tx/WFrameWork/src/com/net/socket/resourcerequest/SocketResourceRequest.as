package com.net.socket.resourcerequest
{
	import com.net.request.vo.RequestVO;
	import com.net.socket.SocketServer;
	import com.utils.work.Work;
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	public class SocketResourceRequest extends SocketServer
	{
		protected var ip:String;
		protected var prot:int;
		protected var cmd:int;
		public function SocketResourceRequest(ip:String,prot:int)
		{
			this.ip = ip;
			this.prot = prot;
			workList = [];
			workDict = new Dictionary();
			sendByteArray = new ByteArray();
		}
		
		private var workList:Array;
		private var workDict:Dictionary;
		public function streamAsyncRequest(url:String,handler:Function):void{
			if(!url || handler==null){
				return;
			}
			var vo:RequestVO = workDict[url];
			if(!vo){
				vo = new RequestVO(url);
				workDict[url] = vo;
				workList.unshift(vo);
			}
			vo.addHandler(handler);
			if(!connected){
				connect(ip,prot);
			}
		}
		
		public function removeStreamAsyncRequest(url:String,handler:Function):void{
			var vo:RequestVO = workDict[url];
			if(!vo){
				return;
			}
			
			if(!vo.removeHandler(handler)){
				removeRequest(url);
			}
		}
		
		protected function removeRequest(url:String):void{
			workDict[url] = null;
			delete workDict[url];
		}
		
		override protected function socketConnectHandler(event:Event):void{
			super.socketConnectHandler(event);
			doWork();
		}
		
		protected var sendByteArray:ByteArray
		protected function encodeRequest(work:RequestVO):ByteArray{
			sendByteArray.position = 0;
			sendByteArray.length = 0;
			sendByteArray.writeObject(work.id);
			return sendByteArray;
		}
		
		public function doWork():void{
			if(!workList.length){
				close();
				return;
			}
			var work:RequestVO = workList.pop();
			send(encodeRequest(work));
		}
		
		override public function receive(byte:ByteArray):void{
			var arr:Array = byte.readObject();
			var vo:RequestVO = workDict[arr[1]];
			vo.doHandler(arr);
			doWork();
		}
	}
}