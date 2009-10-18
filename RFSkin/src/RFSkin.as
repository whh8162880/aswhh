package {
	import com.display.LayoutType;
	import com.display.keyboard.KeyStroke;
	import com.display.keyboard.KeyboardManager;
	import com.display.label.Label;
	import com.display.list.ListBase;
	import com.display.skin.skins.ListInteractive;
	import com.display.utils.geom.IntRectangle;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	public class RFSkin extends Sprite
	{
		public function RFSkin()
		{
			
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE
			
			var label:Label = new Label();
			label.data = {label:"你是一头猪"}
//			addChild(label);
			label.width = 200;
//			label.intRectangle = new IntRectangle(0,0,300,20);
			label.addDisplayObjectToLayer("under",new ListInteractive(),0);
			label.hAlign = LayoutType.MIDDLE
			
			var list:ListBase = new ListBase();
			list.intRectangle = new IntRectangle(0,0,100,500);
			addChild(list);
			list.data = ["你1","你23","你23","你23","你23","你23","你23"]
			
			var keyboard:KeyboardManager = new KeyboardManager()
			keyboard.init(stage);
			keyboard.regFunction(close,false,false,false,KeyStroke.VK_ESCAPE);
			keyboard.regFunction(open,false,false,false,KeyStroke.VK_ENTER);
			keyboard.regFunction(ctrlz,false,true,false,KeyStroke.VK_Z);
			keyboard.regFunction(abc,false,false,false,KeyStroke.VK_A,KeyStroke.VK_B,KeyStroke.VK_C);
		}
		
		
		private function close():void{
			trace("close")
		}
		
		private function open():void{
			trace("open")
		}
		
		private function ctrlz():void{
			trace("ctrl+z")
		}
		
		private function ctrlshiftz():void{
			trace('ctrl+shift+z')
		}
		
		private function ctrlshiftaltz():void{
			trace('ctrl+shift+alt+z')
		}
		
		private function abc():void{
			trace('abc')
		}
	}
}
