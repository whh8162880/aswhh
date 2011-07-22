package com.theworld.scene
{
	import com.scene.core.LayoutType;
	import com.scene.core.SceneBase;
	import com.theworld.utils.TXHelp;
	
	import rfcomponents.SkinBase;

	public class SceneMain extends SceneBase
	{
		public function SceneMain(scenename:String = 'SceneMain')
		{
			super(scenename)
		}
		
		override public function initialize():void{
			var panel:SkinBase = TXHelp.chatController.getView();
			regPanel(panel.skin,NaN,NaN,LayoutType.LEFT_H,LayoutType.BOTTOM_V);
			
			panel = TXHelp.mapController.getView();
			regPanel(panel.skin,NaN,NaN,LayoutType.RIGHT_H,LayoutType.TOP_V);
			super.initialize();
		}
		
		override protected function initStart():void{
			TXHelp.chatController.show();
			TXHelp.mapController.show();
		}
		
	}
}