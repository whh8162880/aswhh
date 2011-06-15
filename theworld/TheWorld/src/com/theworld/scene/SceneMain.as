package com.theworld.scene
{
	import com.scene.core.SceneBase;
	import com.theworld.command.Command;
	
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;

	public class SceneMain extends SceneBase
	{
		public function SceneMain(scenename:String = 'SceneMain')
		{
			super(scenename)
		}
		
		private var inputTF:TextField;
		private var tfarea:TextField;
		override public function initialize():void{
			inputTF = new TextField();
			inputTF.width=400;
			inputTF.height = 20;
			inputTF.background = true;
			inputTF.border = true;
			inputTF.x = 10;
			inputTF.y = 400;
			inputTF.type = TextFieldType.INPUT;
			addChild(inputTF);
			inputTF.addEventListener(KeyboardEvent.KEY_UP,keyhandler);
			
			
			tfarea = new TextField();
			tfarea.x = 10;
			tfarea.y = 10;
			tfarea.width = 400;
			tfarea.height = 375;
			tfarea.border = true;
			addChild(tfarea);
			
			super.initialize();
		}
		
		
		private function keyhandler(event:KeyboardEvent):void{
			if(event.keyCode == Keyboard.ENTER){
				var str:String = inputTF.text;
				if(!Command.doCommand(str)){
					tfarea.appendText(str+"\n");
				}
				inputTF.text = '';
			}
		}
	}
}