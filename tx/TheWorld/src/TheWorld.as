package
{
	import com.scene.core.SceneManager;
	import com.theworld.core.CoreGlobal;
	import com.theworld.scene.SceneInit;
	import com.theworld.scene.SceneLogin;
	import com.theworld.scene.SceneMain;
	import com.theworld.scene.ScenePreload;
	import com.utils.UILocator;
	import com.utils.Work;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	[SWF(frameRate='30', backgroundColor='0xDDDDDD', width=1000,height=600)]
	
	public class TheWorld extends Sprite
	{
		public function TheWorld()
		{
			CoreGlobal.stage = stage;
			UILocator.bindContianer(stage,stage);
			Work.bindStage(stage);
			
			var sm:SceneManager = new SceneManager(stage);
			sm.setSize(1000,600);
			sm.setContainer(this);
			sm.regScene(new SceneMain());
			sm.regScene(new SceneLogin());
			sm.regScene(new ScenePreload());
			sm.regScene(new SceneInit());
			sm.showScene("SceneLogin");
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
	}
}