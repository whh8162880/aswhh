package
{
	import com.net.socket.SocketServer;
	import com.tween.Tweener;
	import com.tween.easing.Quad;
	import com.tween.easing.Quart;
	import com.utils.InsertFunction;
	import com.utils.StageUtils;
	
	import flash.display.Sprite;

	[SWF(fameRate='30',width='800',height='600')]
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
			
//			function updata(value:Array):void{
//				s.x = value[0];
//			}
//			
//			function complete():void{
//				//trace("complete");
//			}
//			
//			var tweener:Tweener = new Tweener();
//			tweener.addTask(s.x,s.x+400);
//			tweener.ease = Quart.easeInOut;
//			tweener.onUpdata = updata;
//			tweener.onComplete = complete;
//			tweener.play(2000);
			
			
			
		}
	}
}