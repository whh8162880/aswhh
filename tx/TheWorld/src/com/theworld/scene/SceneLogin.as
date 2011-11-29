package com.theworld.scene
{
	import com.module.scene.core.SceneBase;
	import com.theworld.components.panel.TXPanel;
	import com.theworld.core.CoreGlobal;
	import com.theworld.net.socket.TxSocket;
	import com.theworld.vo.LoginVO;
	
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
		
		
		
		private function loginHandler(event:Event):void{
			var vo:LoginVO = new LoginVO();
			vo.name = userTxt.label;
			vo.gameip = ipTxt.label;
			vo.gameport = int(portTxt.label);
			vo.resip = rIpTxt.label;
			vo.resport = int(rPortTxt.label);
			CoreGlobal.loginVO = vo;
			nextScene = 'ScenePreload';
			sleep();
		}
		private var userTxt:Text;
		private var ipTxt:Text;
		private var portTxt:Text;
		private var rIpTxt:Text;
		private var rPortTxt:Text;
		private function createLoginPanel():TXPanel{
			var panel:TXPanel = new TXPanel();
			panel.create(600,400);
			panel.createTextFiled(20,20,100,20,false,"用户名:");
			userTxt = panel.createTextFiled(120,20,100,20,true,"whh");
			
			panel.createTextFiled(20,45,100,20,false,"游戏IP:");
			ipTxt = panel.createTextFiled(120,45,100,20,true,'127.0.0.1');
			
			panel.createTextFiled(20,70,100,20,false,"游戏端口:");
			portTxt = panel.createTextFiled(120,70,100,20,true,'1986');

			panel.createTextFiled(220,45,100,20,false,"资源IP:");
			rIpTxt = panel.createTextFiled(320,45,100,20,true,'127.0.0.1');
			
			panel.createTextFiled(220,70,100,20,false,"资源端口:");
			rPortTxt = panel.createTextFiled(320,70,100,20,true,'1991');
			
			panel.createButton(20,100,100,20,"登陆",loginHandler);
			return panel;
		}
	}
}