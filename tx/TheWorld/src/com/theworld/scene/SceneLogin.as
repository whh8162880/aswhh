package com.theworld.scene
{
	import com.scene.core.SceneBase;
	import com.theworld.components.panel.TXPanel;
	import com.theworld.core.CoreGlobal;
	import com.theworld.net.socket.TxSocket;
	
	import flash.events.Event;
	
	import rfcomponents.text.Text;
	
	public class SceneLogin extends SceneBase
	{
		public function SceneLogin()
		{
			super('SceneLogin');
		}
		
		override public function initialize():void{
			var panel:TXPanel = createLoginPanel();
			panel.show();
			super.initialize();
		}
		
		
		
		private function connect(ip:String,prot:int):void{
			var socket:TxSocket = new TxSocket();
			socket.addEventListener(Event.CONNECT,connectHandler);
			CoreGlobal.socket = socket;
			socket.connect(ip,prot);
		}
		
		
		private function connectHandler(event:Event):void{
			trace("连接服务器成功");
			nextScene = "SceneMain"
			//sleep();
		}
		
		private function loginHandler(event:Event):void{
			trace(userTxt.label,ipTxt.label,portTxt.label);
			connect(ipTxt.label,int(portTxt.label))
		}
		private var userTxt:Text;
		private var ipTxt:Text;
		private var portTxt:Text;
		private function createLoginPanel():TXPanel{
			var panel:TXPanel = new TXPanel();
			panel.create(600,400);
			panel.createTextFiled(20,20,100,20,false,"用户名:");
			userTxt = panel.createTextFiled(120,20,100,20,true,"whh");
			
			panel.createTextFiled(20,45,100,20,false,"IP:");
			ipTxt = panel.createTextFiled(120,45,100,20,true,'127.0.0.1');
			
			panel.createTextFiled(20,70,100,20,false,"端口:");
			portTxt = panel.createTextFiled(120,70,100,20,true,'1986');

			
			panel.createButton(20,100,100,20,"登陆",loginHandler);
			return panel;
		}
	}
}