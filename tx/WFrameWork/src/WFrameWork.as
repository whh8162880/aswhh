package
{
	import com.effect.FruitCut;
	import com.net.socket.SocketServer;
	import com.tween.Tweener;
	import com.tween.easing.Quad;
	import com.tween.easing.Quart;
	import com.utils.InsertFunction;
	import com.utils.StageUtils;
	import com.utils.fps.State;
	import com.utils.math.IntPoint;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import test.plugin.PluginTest;

	[SWF(frameRate='30',width='800',height='600',backgroundColor='0x111111')]
	public class WFrameWork extends Sprite
	{
		public function WFrameWork()
		{
			StageUtils.initStage(stage);
			var s:Sprite = new Sprite();
			s.graphics.beginFill(0xFF0000);
			s.graphics.drawCircle(0,0,20);
			s.graphics.endFill();
			s.y = 50;
			s.x = 50;
			addChild(s);
			addChild(new State());
			
			var i:int = 1;
			while(i--){
				
			}
			
			new PluginTest()
			
			//stage.addEventListener(MouseEvent.CLICK,clickHandler);
		}
		
		private function clickHandler(event:MouseEvent):void{
			test();
		}
		
		private function test():void{
			var arr:Array = [];
			var i:int = 50;
			var c:int = i;
			while(i--){
				arr.push(new IntPoint(stage.stageWidth * Math.random(),stage.stageHeight * Math.random()));
			}
			
			var d:DisplayObject = new FruitCut().start(arr,c*300,300);
			addChild(d);
		}
	}
}