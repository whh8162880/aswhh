package com.theworld.module.chat
{
	import com.theworld.command.Command;
	import com.theworld.components.panel.TXPanel;
	
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.ui.Keyboard;
	
	public class ChatView extends TXPanel
	{
		
		private var inputTF:TextField;
		private var tfarea:TextField;
		
		public function ChatView()
		{
			super();
			
			create(400,200);
			
		}
		
		override protected function setDrag():void{
			
		}
		
		override protected function bindComponents():void{
			inputTF = new TextField();
			inputTF.width=380;
			inputTF.height = 20;
			inputTF.background = true;
			inputTF.border = true;
			inputTF.x = 10;
			inputTF.y = 175;
			inputTF.type = TextFieldType.INPUT;
			addChild(inputTF);
			inputTF.addEventListener(KeyboardEvent.KEY_UP,keyhandler);
			
			tfarea = new TextField();
			tfarea.x = 10;
			tfarea.y = 10;
			tfarea.multiline = tfarea.wordWrap = true;
			tfarea.width = 380;
			tfarea.height = 160;
			tfarea.border = true;
			addChild(tfarea);
		}
		
		private function keyhandler(event:KeyboardEvent):void{
			if(event.keyCode == Keyboard.ENTER){
				var str:String = inputTF.text;
				if(!Command.doCommand(str)){
					addMessage(str);
				}
				inputTF.text = '';
			}
		}
		
		
		public function addMessage(str:String):void{
			tfarea.htmlText += (str+"\n")
		}
		
		public function clearTestArea():void{
			tfarea.text = '';
		}
	}
}