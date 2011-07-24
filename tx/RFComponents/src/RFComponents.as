package
{
	import com.components.TestCheckBox;
	import com.components.TestPanel;
	import com.components.TestRadioButton;
	import com.components.test.TestListItemRender;
	import com.utils.UILocator;
	import com.utils.work.Work;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import rfcomponents.checkbox.CheckBox;
	import rfcomponents.list.List;
	import rfcomponents.radiobutton.RadioButton;
	
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

			var r:RadioButton = new TestRadioButton(100,20,"sex");
			r.label = 'whhwhhwhh';
			r.x = r.y = 20;
			panel.addChild(r.skin);
			
			r = new TestRadioButton(100,20,"sex");
			r.label = 'hcchcchcc';
			r.x = 130 
			r.y = 20;
			panel.addChild(r.skin);
			
			
			var c:CheckBox = new TestCheckBox(100,20);
			c.label = 'whcwhc';
			c.x = 20
			c.y = 50;
			panel.addChild(c.skin);
			
			
//			var list:List = new List(TestListItemRender,100,20);
//			panel.addChild(list.skin);
//			
//			list.data = ["test","test","test","test","test","test"];
		}
	}
}