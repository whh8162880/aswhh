package {
	import com.display.label.Label;
	
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
		}
	}
}
