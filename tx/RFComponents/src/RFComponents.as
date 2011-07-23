package
{
	import com.components.TestPanel;
	import com.components.test.TestListItemRender;
	import com.utils.UILocator;
	import com.utils.Work;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import rfcomponents.list.List;
	
	public class RFComponents extends Sprite
	{
		public function RFComponents()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			Work.bindStage(stage);
			UILocator.bindContianer(stage,stage);
			
			var panel:TestPanel = new TestPanel();
			panel.create(300,200);
			panel.show();
			
			var list:List = new List(TestListItemRender,100,20);
			panel.addChild(list.skin);
			
			list.data = ["test","test","test","test","test","test"];
		}
	}
}