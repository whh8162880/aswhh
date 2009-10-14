package {
	import com.display.label.Label;
	import com.display.list.ListBase;
	import com.display.skin.skins.ListInteractive;
	
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
			addChild(label);
			label.width = 1000;
			
			label.addDisplayObjectToLayer("under",new ListInteractive(),0);
			
			
			var list:ListBase = new ListBase();
//			addChild(list);
			list.data = ["你1","你23","你23","你23","你23","你23","你23"]
			
		}
	}
}
