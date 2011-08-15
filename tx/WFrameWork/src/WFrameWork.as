package
{
	import com.net.socket.SocketServer;
	import com.tween.Tweener;
	import com.tween.easing.Quad;
	import com.tween.easing.Quart;
	import com.utils.InsertFunction;
	import com.utils.StageUtils;
	import com.utils.fps.State;
	
	import flash.display.Sprite;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;

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
			
			addChild(new State());
			
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
			
			setTimeout(test2,1000,5);
		}
		
		private function test(max:int):void{
			var i:int;
			var t:int;
			var c:int = 100000
			handler = handler2;
			i = c;
			t = getTimer();
			while(i--){
				handler();
			}
			trace(""+(getTimer()-t));
			
			i = c;
			t = getTimer();
			while(i--){
				handler2();
			}
			trace(""+(getTimer()-t));
			
			i = c;
			t = getTimer();
			while(i--){
				handler3();
			}
			trace(""+(getTimer()-t));
			trace("\n")
			
			if(max)
				setTimeout(test,1000,--max)
		}
		
		
		
		
		private var handler:Function;
		
		private function handler2():void{
			
		}
		
		public static function handler3():void{
			
		}
		
		
		private function test2(max:int):void{
			var a:TestClass = new TestClass();
			var i:int;
			var t:int;
			var c:int = 1000000
			i = c;
			t = getTimer();
			while(i--){
				a.a+1;
			}
			trace("\n"+(getTimer()-t));
			
			i = c;
			t = getTimer();
			while(i--){
				a.c+1;
			}
			trace(""+(getTimer()-t));
			
			i = c;
			t = getTimer();
			while(i--){
				a.calc(1,1)
			}
			trace(""+(getTimer()-t));
			
			if(max)
				setTimeout(test2,1000,--max)
		}
	}
	
}

class TestClass{
	public var a:int;
	public var b:int;
	
	private var _c:int
	public function get c():int{
		return _c;
	}
	public function calc(a:int,b:int):void{
		a+b;
	}
}