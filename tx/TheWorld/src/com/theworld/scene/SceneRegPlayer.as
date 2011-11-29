package com.theworld.scene
{
	import com.module.scene.core.SceneBase;
	import com.theworld.components.panel.TXPanel;
	import com.theworld.core.CoreGlobal;
	
	import flash.events.Event;
	
	import rfcomponents.radiobutton.RadioButtonGroup;
	import rfcomponents.text.Text;
	
	public class SceneRegPlayer extends SceneBase
	{
		public function SceneRegPlayer(sceneName:String='SceneRegPlayer')
		{
			super(sceneName);
		}
		
		private var panel:TXPanel;
		private var nameTxt:Text;
		override public function initialize():void{
			panel = new TXPanel();
			panel.create(500,300);
			panel.createTextFiled(20,20,60,20,false,"姓名");
			nameTxt = panel.createTextFiled(90,20,60,20,true,"whh");
			panel.createRadioButton(20,50,60,20,"sex","男","F");
			panel.createRadioButton(90,50,60,20,"sex","女","M");
			panel.createButton(20,80,60,20,"注册",createCompleteHandler);
		}
		
		override protected function initStart():void{
			panel.show();
		}
		
		private function createCompleteHandler(event:Event):void{
			var group:RadioButtonGroup = RadioButtonGroup.getGroup("sex");
			CoreGlobal.sendCallback(10001,[nameTxt.label,group.selectRadioButton.data],createCallbackHandler);
		}
		
		private function createCallbackHandler(data:*):void{
			if(data[0] == 1){
				CoreGlobal.currentRole = data[1];
				nextScene = 'SceneIntoGame';
				sleep();
			}
		}
	}
}