package
{
	import com.components.TestCheckBox;
	import com.components.TestPanel;
	import com.components.TestRadioButton;
	import com.components.test.TestListItemRender;
	import com.utils.InsertFunction;
	import com.utils.StageUtils;
	import com.utils.UILocator;
	import com.utils.work.Work;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import rfcomponents.checkbox.CheckBox;
	import rfcomponents.list.List;
	import rfcomponents.radiobutton.RadioButton;
	import rfcomponents.text.Text;
	
	public class RFComponents extends Sprite
	{
		private var txt:Text;
		private var inputTxt:Text;
		public function RFComponents()
		{
//			stage.align = StageAlign.TOP_LEFT;
//			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			StageUtils.initStage(stage);
			UILocator.bindContianer(stage,stage);
			StageUtils.check(true);
			
			var panel:TestPanel = new TestPanel();
			panel.create(300,200);
			panel.show();

			txt = panel.createTextFiled(20,20,100,20);
			inputTxt = panel.createTextFiled(20,50,100,20,true,"10000");
			panel.createButton(120,50,100,20,"计算",clickHandler);
			
			InsertFunction.regInsertFunction(StageUtils.STAGE_RENDER,check);
			
			
			
			
//			var list:List = new List(TestListItemRender,100,20);
//			panel.addChild(list.skin);
//			
//			list.data = ["test","test","test","test","test","test"];
		}
		
		private var flag:Boolean;
		private function clickHandler(event:MouseEvent):void{
			if(!flag){
				stage.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
			}else{
				stage.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
			}
		}
		
		private function enterFrameHandler(event:Event):void{
			var i:int = int(inputTxt.label);
			while(i-->=0){
				1+2+6*100;
			}
		}
		
		private function check(id:String,t:int):void{
			txt.label = "render "+t;
		}
	}
}