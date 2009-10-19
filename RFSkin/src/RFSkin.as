package {
	import com.display.LayoutType;
	import com.display.button.ButtonBase;
	import com.display.label.Label;
	import com.display.list.ListBase;
	import com.display.panel.PanelBase;
	import com.display.skin.skins.ListInteractive;
	import com.display.utils.geom.IntRectangle;
	import com.display.wskin.button.WButton;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	public class RFSkin extends Sprite
	{
		public function RFSkin()
		{
			
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE
//			
////			RFSystemManager.getInstance().setStage(stage);
//			
			var label:Label = new Label();
			label.data = {label:"你是一头猪"}
//			addChild(label);
			label.width = 200;
//			label.intRectangle = new IntRectangle(0,0,300,20);
			label.addDisplayObjectToLayer("under",new ListInteractive(),0);
			label.hAlign = LayoutType.MIDDLE
//			
			var list:ListBase = new ListBase();
			list.intRectangle = new IntRectangle(0,0,100,500);
//			addChild(list);
			list.data = ["你1","你23","你23","你23","你23","你23","你23"]
			
			var panel:PanelBase = new PanelBase(list);
			panel.enterKeyboardEnabled = true;
			panel.escKeyboardEnabled = true;
			panel.escClose = true;
//			addChild(panel);
//			
			var b:ButtonBase = new WButton();
			addChild(b);
		}
	}
}
