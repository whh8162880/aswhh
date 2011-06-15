package
{
	import com.scene.core.SceneManager;
	import com.theworld.scene.SceneMain;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	[SWF(frameRate='30', backgroundColor='0xDDDDDD', width=800,height=600)]
	
	public class TheWorld extends Sprite
	{
		public function TheWorld()
		{
			var sm:SceneManager = new SceneManager(stage);
			sm.setSize(800,600);
			sm.setContainer(this);
			sm.regScene(new SceneMain());
			sm.showScene("SceneMain");
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}
	}
}